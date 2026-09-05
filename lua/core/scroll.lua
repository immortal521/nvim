---@class core.scroll
local M = {}

local stats = { targets = 0, animating = 0, reset = 0, skipped = 0, scrolls = 0 }
local uv = vim.uv
local SCROLL_UP, SCROLL_DOWN = Utils.keycode("<c-y>"), Utils.keycode("<c-e>")

---@class core.scroll.State
---@field animation? core.animate.Animation
---@field win integer
---@field buf integer
---@field view vim.fn.winsaveview.ret
---@field current vim.fn.winsaveview.ret
---@field target vim.fn.winsaveview.ret
---@field scrolloff number
---@field changedtick number
---@field last number
---@field _wo vim.wo
local State = {}
State.__index = State

---@type table<integer, core.scroll.State>
local states = {}

---@param win integer
function State.get(win)
	local buf = vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win)
	if not buf then
		states[win] = nil
		return nil
	end

	---@type vim.fn.winsaveview.ret
	local view = vim.api.nvim_win_call(win, vim.fn.winsaveview)
	local ret = states[win]
	if not (ret and ret:valid()) then
		if ret ~= nil then
			ret:stop()
		end
		ret = setmetatable({}, State)
		ret.buf = buf
		ret._wo = {}
		ret.changedtick = vim.api.nvim_buf_get_changedtick(buf)
		ret.current = vim.deepcopy(view)
		ret.last = 0
		ret.target = vim.deepcopy(view)
		ret.win = win
	end

	ret.scrolloff = ret._wo.scrolloff or vim.wo[win].scrolloff
	ret.view = view
	states[win] = ret
	return ret
end

function State:stop()
	self:wo()
	if self.animation ~= nil then
		self.animation:stop()
		self.animation = nil
	end
end

---@param opts? vim.wo|{}
function State:wo(opts)
	if not opts then
		if vim.api.nvim_win_is_valid(self.win) then
			for k, v in pairs(self._wo) do
				vim.wo[self.win][k] = v
			end
		end
		self._wo = {}
		return
	else
		for k, v in pairs(opts) do
			self._wo[k] = self._wo[k] or vim.wo[self.win][k]
			vim.wo[self.win][k] = v
		end
	end
end

function State:valid()
	return states[self.win] == self
		and vim.api.nvim_win_is_valid(self.win)
		and vim.api.nvim_buf_is_valid(self.buf)
		and vim.api.nvim_win_get_buf(self.win) == self.buf
		and vim.api.nvim_buf_get_changedtick(self.buf) == self.changedtick
end

function State:update()
	if vim.api.nvim_win_is_valid(self.win) then
		self.current = vim.api.nvim_win_call(self.win, vim.fn.winsaveview)
	end
end

---@param win integer
function State.reset(win)
	if states[win] ~= nil then
		states[win]:stop()
		states[win] = nil
	end
end

function M.enable()
	-- M.debug()
	states = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		State.get(win)
	end

	local group = vim.api.nvim_create_augroup("core_scroll", { clear = true })

	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		callback = vim.schedule_wrap(function(ev)
			for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
				State.get(win)
			end
		end),
	})

	vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
		group = group,
		callback = function(ev)
			for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
				State.get(win)
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		callback = vim.schedule_wrap(function(ev)
			for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
				if states[win] ~= nil then
					states[win]:update()
				end
			end
		end),
	})

	vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
		group = group,
		callback = function(ev)
			if (ev.file == "/" or ev.file == "?") and vim.o.incsearch then
				for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
					State.reset(win)
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("WinScrolled", {
		group = group,
		callback = function()
			for win, changes in pairs(vim.v.event) do
				win = tonumber(win)
				if win and changes.topline ~= 0 then
					M.check(win)
				end
			end
		end,
	})
end

---@param win integer
---@param from vim.fn.winsaveview.ret
---@param to vim.fn.winsaveview.ret
local function scroll_lines(win, from, to)
	if from.topline == to.topline then
		return math.abs(from.topfill - to.topfill)
	end
	if to.topline < from.topline then
		from, to = to, from
	end
	local start_row, end_row, offset = from.topline - 1, to.topline - 1, 0
	if from.topfill > 0 then
		start_row = start_row + 1
		offset = from.topfill + 1
	end
	if to.topfill > 0 then
		offset = offset - to.topfill
	end
	if not vim.api.nvim_win_text_height then
		return end_row - start_row + offset
	end
	return vim.api.nvim_win_text_height(win, { start_row = start_row, end_row = end_row }).all + offset - 1
end

---@param win integer
---@private
function M.check(win)
	local state = State.get(win)
	if not state then
		return
	end

	if vim.wo[state.win].scrollbind and vim.api.nvim_get_current_win() ~= state.win then
		state:stop()
		return
	end

	if math.abs(state.view.topline - state.current.topline) <= 1 then
		stats.skipped = stats.skipped + 1
		state.current = vim.deepcopy(state.view)
		return
	end

	stats.scrolls = stats.scrolls + 1

	stats.targets = stats.targets + 1

	state.target = vim.deepcopy(state.view)

	state:stop()

	local now = uv.hrtime()
	-- local repeat_delta = (now - state.last) / 1e6
	state.last = now

	-- local is_repeat = repeat_delta <= 100

	local scrolls = 0
	local col_from, col_to = 0, 0
	local move_from, move_to = 0, 0
	vim.api.nvim_win_call(state.win, function()
		move_to = vim.fn.winline()
		vim.fn.winrestview(state.current)
		move_from = vim.fn.winline()
		state:update()
		scrolls = scroll_lines(win, state.current, state.target)
		col_from = vim.fn.virtcol({ state.current.lnum, state.current.col })
		col_to = vim.fn.virtcol({ state.current.lnum, state.target.col })
	end)

	local down = state.target.topline > state.current.topline
		or (state.target.topline == state.current.topline and state.target.topfill < state.current.topfill)

	local scrolled = 0

	state.animation = require("core.animate")(0, scrolls, function(value, ctx)
		if not state:valid() then
			state:stop()
			return
		end

		vim.api.nvim_win_call(win, function()
			if ctx.done then
				vim.fn.winrestview(state.target)
				state:update()
				state:stop()
				return
			end
			local count = vim.v.count
			local commands = {}

			local scroll_target = math.floor(value)
			local scroll = scroll_target - scrolled
			if scroll > 0 then
				scrolled = scrolled + scroll
				commands[#commands + 1] = ("%d%s"):format(scroll, down and SCROLL_DOWN or SCROLL_UP)
			end

			local move = math.floor(value * math.abs(move_to - move_from) / scrolls)
			local move_target = move_from + ((move_to < move_from) and -1 or 1) * move
			commands[#commands + 1] = ("%dH"):format(move_target + 1)

			local virtcol = math.floor(col_from + (col_to - col_from) * value / scrolls)
			commands[#commands + 1] = ("%d|"):format(virtcol + 1)

			vim.cmd(("keepjumps normal! %s"):format(table.concat(commands, "")))

			---@diagnostic disable-next-line: preferred-local-alias
			if vim.v.count ~= count then
				local cursor = vim.api.nvim_win_get_cursor(win)
				vim.cmd(("keepjumps normal! %dzh"):format(count))
				vim.api.nvim_win_set_cursor(win, cursor)
			end

			state:update()
		end)
	end, { duration = { step = 10, total = 200 } })
end

local debug_timer = uv.new_timer()

---@private
function M.debug()
	if debug_timer == nil then
		return
	end

	if debug_timer:is_active() then
		return debug_timer:stop()
	end
	local last = {}

	debug_timer:start(50, 50, function()
		local data = vim.tbl_deep_extend("force", { stats = stats }, states)
		for key, value in pairs(data) do
			if not vim.deep_equal(last[key], value) then
				Utils.log.debug(vim.inspect(value))
			end
		end
		last = vim.deepcopy(data)
	end)
end

return M
