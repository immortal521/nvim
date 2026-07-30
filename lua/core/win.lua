---@class core.win
---@field id integer
---@field buf? integer
---@field scratch_buf? integer
---@field win? integer
---@field opts core.win.Config
---@field augroup? integer
---@field backdrop? core.win
---@field keys core.win.Keys[]
---@field events (core.win.Event|{event:string|string[]})[]
---@field meta table<string, any>
---@field closed? boolean
---@overload fun(opts? :core.win.Config|{}): core.win
local M = setmetatable({}, {
	__call = function(t, ...)
		return t.new(...)
	end,
})
M.__index = M

M.meta = {
	desc = "Create and manage floating windows or splits",
}

local id = 0
local event_stack = {} ---@type string[]

local SCROLL_UP = Utils.keycode("<c-y>")
local SCROLL_DOWN = Utils.keycode("<c-e>")

---@class core.win.Keys: vim.api.keyset.keymap
---@field [1]? string
---@field [2]? string|string[]|fun(self: core.win): string?
---@field mode? string|string[]

---@class core.win.Event: vim.api.keyset.create_autocmd
---@field buf? true
---@field win? true
---@field callback? fun(self: core.win, ev:vim.api.keyset.create_autocmd.callback_args):boolean?

---@class core.win.Backdrop
---@field bg? string
---@field blend? integer
---@field transparent? boolean defaults to true
---@field win? core.win.Config overrides the backdrop window config

---@class core.win.Dim
---@field width integer width of the window, without borders
---@field height integer height of the window, without borders
---@field row integer row of the window (0-indexed)
---@field col integer column of the window (0-indexed)
---@field border? boolean whether the window has a border

---@alias core.win.Action.fn fun(self: core.win):(boolean|string?)
---@alias core.win.Action.spec core.win.Action|core.win.Action.fn
---@class core.win.Action
---@field action core.win.Action.fn
---@field desc? string

---@class core.win.Config: vim.api.keyset.win_config
---@field style? string
---@field show? boolean Show the window immediately (default: true)
---@field footer_keys? boolean|string[] Show keys footer. When string[], only show those keys with lhs (default: false)
---@field height? integer|fun(self:core.win):integer Height of the window. Use <1 for relative height. 0 means full height. (default: 0.9)
---@field width? integer|fun(self:core.win):integer Width of the window. Use <1 for relative width. 0 means full width. (default: 0.9)
---@field min_height? integer Minimum height of the window
---@field max_height? integer Maximum height of the window
---@field min_width? integer Minimum width of the window
---@field max_width? integer Maximum width of the window
---@field col? integer|fun(self:core.win):integer Column of the window. Use <1 for relative column. (default: center)
---@field row? integer|fun(self:core.win):integer Row of the window. Use <1 for relative row. (default: center)
---@field minimal? boolean Disable a bunch of options to make the window minimal (default: true)
---@field position? "float"|"bottom"|"top"|"left"|"right"|"current"
---@field border? "none"|"top"|"right"|"bottom"|"left"|"top_bottom"|"hpad"|"vpad"|"rounded"|"single"|"double"|"solid"|"shadow"|"bold"|string[]|false|true
---@field buf? integer If set, use this buffer instead of creating a new one
---@field file? string If set, use this file instead of creating a new buffer
---@field enter? boolean Enter the window after opening (default: false)
---@field backdrop? integer|false|core.win.Backdrop Opacity of the backdrop (default: 60)
---@field wo? vim.wo|{} window options
---@field bo? vim.bo|{} buffer options
---@field b? table<string, any> buffer local variables
---@field w? table<string, any> window local variables
---@field ft? string filetype to use for treesitter/syntax highlighting. Won't override existing filetype
---@field scratch_ft? string filetype to use for scratch buffers
---@field keys? table<string, false|string|fun(self: core.win)|core.win.Keys> Key mappings
---@field on_buf? fun(self: core.win) Callback after opening the buffer
---@field on_win? fun(self: core.win) Callback after opening the window
---@field on_close? fun(self: core.win) Callback after closing the window
---@field fixbuf? boolean don't allow other buffers to be opened in this window
---@field text? string|string[]|fun():(string[]|string) Initial lines to set in the buffer
---@field actions? table<string,  core.win.Action.spec> Actions that can be used in key mappings
---@field resize? boolean Automatically resize the window when the editor is resized
---@field stack? boolean When enabled, multiple split windows with the same position will be stacked together (useful for terminals)
local defaults = {
	show = true,
	fixbuf = true,
	relative = "editor",
	position = "float",
	minimal = true,
	wo = {
		winhighlight = "Normal:CoreNormal,NormalNC:CoreNormalNC,WinBar:CoreWinBar,WinBarNC:CoreWinBarNC,FloatTitle:CoreTitle,FloatFooter:CoreFooter,WinSeparator:CoreWinSeparator",
	},
	bo = {},
	title_pos = "center",
	keys = {
		q = "close",
	},
	footer_pos = "center",
	footer_keys = false,
}

Core.config.style("float", {
	position = "float",
	backdrop = 60,
	height = 0.9,
	width = 0.9,
	zindex = 50,
})

Core.config.style("help", {
	position = "float",
	backdrop = false,
	border = "top",
	row = -1,
	width = 0,
	height = 0.3,
})

Core.config.style("split", {
	position = "bottom",
	height = 0.4,
	width = 0.4,
})

Core.config.style("minimal", {
	wo = {
		cursorcolumn = false,
		cursorline = false,
		cursorlineopt = "both",
		colorcolumn = "",
		fillchars = "eob: ,lastline:…",
		foldcolumn = "0",
		list = false,
		listchars = "extends:…,tab:  ",
		number = false,
		relativenumber = false,
		signcolumn = "no",
		spell = false,
		winbar = "",
		statuscolumn = "",
		wrap = false,
		sidescrolloff = 0,
	},
})

local split_commands = {
	editor = {
		top = "topleft",
		right = "vertical botright",
		bottom = "botright",
		left = "vertical topleft",
	},
	win = {
		top = "aboveleft",
		right = "vertical rightbelow",
		bottom = "belowright",
		left = "vertical leftabove",
	},
}

local win_opts = {
	"anchor",
	"border",
	"bufpos",
	"col",
	"external",
	"fixed",
	"focusable",
	"footer",
	"footer_pos",
	"height",
	"hide",
	"noautocmd",
	"relative",
	"row",
	"style",
	"title",
	"title_pos",
	"width",
	"win",
	"zindex",
}

---@type table<string, string[]>
local borders = {
	left = { "", "", "", "", "", "", "", "│" },
	right = { "", "", "", "│", "", "", "", "" },
	top = { "", "─", "", "", "", "", "", "" },
	bottom = { "", "", "", "", "", "─", "", "" },
	top_bottom = { "", "─", "", "", "", "─", "", "" },
	hpad = { "", "", "", " ", "", "", "", " " },
	vpad = { "", " ", "", "", "", " ", "", "" },
}

Utils.hlgroup.set_hl({
	Backdrop = { bg = "#000000" },
	Footer = "FloatFooter",
	FooterDesc = "DiagnosticInfo",
	FooterKey = "DiagnosticVirtualTextInfo",
	Normal = "NormalFloat",
	NormalNC = "NormalFloat",
	Title = "FloatTitle",
	WinBar = "Title",
	WinBarNC = "CoreWinBar",
	WinKey = "Keyword",
	WinKeySep = "NonText",
	WinKeyDesc = "Function",
	WinSeparator = "WinSeparator",
}, { prefix = "Core", default = true })

--@private
---@param ...? core.win.Config|string|{}
---@return core.win.Config
function M.resolve(...)
	local done = {} ---@type table<string, boolean>
	local merge = {} ---@type core.win.Config[]
	local stack = {}
	for i = 1, select("#", ...) do
		local next = select(i, ...) ---@type core.win.Config|string?
		if next then
			table.insert(stack, next)
		end
	end
	while #stack > 0 do
		local next = table.remove(stack)
		next = type(next) == "string" and Core.config.styles[next] or next
		---@cast next core.win.Config?
		if next and type(next) == "table" then
			table.insert(merge, 1, next)
			if next.style and not done[next.style] then
				done[next.style] = true
				table.insert(stack, next.style)
			end
		end
	end
	local ret = #merge == 0 and {} or #merge == 1 and merge[1] or vim.tbl_deep_extend("force", {}, unpack(merge))
	ret.style = nil
	return ret
end

---@param opts? core.win.Config|{}
---@return core.win
function M.new(opts)
	local self = setmetatable({}, M)
	id = id + 1
	self.id = id
	self.meta = {}
	opts = M.resolve(Core.config.get("win", defaults), opts)
	if opts.minimal then
		opts = M.resolve("minimal", opts)
	end
	if opts.position == "float" then
		opts = M.resolve("float", opts)
	else
		opts = M.resolve("split", opts)
		local vertical = opts.position == "left" or opts.position == "right"
		opts.wo = opts.wo or {}
		opts.wo.winfixheight = not vertical
		opts.wo.winfixwidth = vertical
	end
	---@diagnostic disable-next-line: unnecessary-if
	if opts.relative == "win" then
		opts.win = opts.win or vim.api.nvim_get_current_win()
	end

	self.keys = {}
	self.events = {}
	local done = {} ---@type table<string, core.win.Keys?>
	opts.keys = opts.keys or {}
	for key, spec in pairs(opts.keys) do
		if spec then
			if type(spec) == "string" then
				spec = { key, spec, desc = spec }
			elseif type(spec) == "function" then
				spec = { key, spec }
			elseif type(spec) == "table" and spec[1] and not spec[2] then
				spec = vim.deepcopy(spec) -- deepcopy just in case
				spec[1], spec[2] = key, spec[1]
			end
			---@cast spec core.win.Keys
			local lhs = Utils.normkey(spec[1] or "")
			local mode = type(spec.mode) == "table" and spec.mode or { spec.mode or "n" }
			---@cast mode string[]
			mode = #mode == 0 and { "n" } or mode
			for _, m in ipairs(mode) do
				local k = m .. ":" .. lhs
				if done[k] then
					Utils.log.warn(
						("# Duplicate key mapping for `%s` mode=%s (check case):\n```lua\n%s\n```\n```lua\n%s\n```"):format(
							lhs,
							m,
							vim.inspect(done[k]),
							vim.inspect(spec)
						)
					)
				end
				done[k] = spec
			end
			table.insert(self.keys, spec)
		end
	end
	-- last defined mapping is found first, so for `nowait` to work,
	-- we need to sort in reverse order
	table.sort(self.keys, function(a, b)
		return (a[1] or "") > (b[1] or "")
	end)

	self:on("WinClosed", self.on_close, { win = true })
	self:on("WinResized", function()
		if self.backdrop and not self:is_floating() then
			self.backdrop:close()
			self.backdrop = nil
		end
	end)

	-- update window size when resizing
	self:on("VimResized", self.on_resize)

	---@cast opts core.win.Config
	self.opts = opts
	if opts.show ~= false then
		self:show()
	end
	return self
end

function M:on_resize()
	if self.opts.resize ~= false then
		self:update()
	end
end

---@param actions string|string[]
function M:execute(actions)
	return self:action(actions)()
end

---@param actions string|string[]
---@return (fun(): boolean|string?) action, string? desc
function M:action(actions)
	actions = type(actions) == "string" and { actions } or actions
	---@cast actions string[]
	local desc = {} ---@type string[]
	for a, name in ipairs(actions) do
		desc[a] = name:gsub("_", " ")
		if self.opts.actions and self.opts.actions[name] then
			local action = self.opts.actions[name]
			desc[a] = type(action) == "table" and action.desc and action.desc or desc[a]
		end
	end
	return function()
		for _, name in ipairs(actions) do
			if self.opts.actions and self.opts.actions[name] then
				local a = self.opts.actions[name]
				local fn = type(a) == "function" and a or a.action
				local ret = fn(self)
				if ret then
					return type(ret) == "string" and ret or nil
				end
			elseif self[name] then
				self[name](self)
				return
			else
				return name
			end
		end
	end,
		table.concat(desc, ", ")
end

---@param opts? {col_width?: integer, key_width?: integer, win?: core.win.Config}
function M:toggle_help(opts)
	opts = opts or {}
	local col_width, key_width = opts.col_width or 30, opts.key_width or 10
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "core_win_help" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end
	local ns = vim.api.nvim_create_namespace("core.win.help")
	local win = M.new(M.resolve({ style = "help" }, opts.win or {}, {
		show = false,
		focusable = false,
		zindex = self.opts.zindex or 50 + 1,
		bo = { filetype = "core_win_help" },
	}))
	self:on("WinClosed", function()
		win:close()
	end, { win = true })
	self:on("BufLeave", function()
		win:close()
	end, { buf = true })
	local dim = win:dim()

	-- NOTE: we use the actual buffer keymaps instead of self.keys,
	-- since we want to show all keymaps, not just the ones we've defined on the window
	local keys = {} ---@type vim.api.keyset.get_keymap[]
	---@cast self.buf integer
	vim.list_extend(keys, vim.api.nvim_buf_get_keymap(self.buf, "n"))
	vim.list_extend(keys, vim.api.nvim_buf_get_keymap(self.buf, "i"))
	table.sort(keys, function(a, b)
		return (a.desc or a.lhs or "") < (b.desc or b.lhs or "")
	end)

	local done = {} ---@type table<string, boolean>
	keys = vim.tbl_filter(function(keymap)
		local key = Utils.normkey(keymap.lhs or "")
		if done[key] or (keymap.desc and keymap.desc:find("which%-key")) then
			return false
		end
		done[key] = true
		return true
	end, keys)

	local cols = math.floor((dim.width - 1) / col_width)
	local rows = math.ceil(#keys / cols)
	win.opts.height = rows
	local help = {} ---@type {[1]:string, [2]:string}[][]
	local row, col = 0, 1

	---@param str string
	---@param len integer
	---@param align? "left"|"right"
	local function trunc(str, len, align)
		local w = vim.api.nvim_strwidth(str)
		if w > len then
			return vim.fn.strcharpart(str, 0, len - 1) .. "…"
		end
		return align == "right" and (string.rep(" ", len - w) .. str) or (str .. string.rep(" ", len - w))
	end

	for _, keymap in ipairs(keys) do
		local key = Utils.normkey(keymap.lhs or "")
		row = row + 1
		if row > rows then
			row, col = 1, col + 1
		end
		help[row] = help[row] or {}
		vim.list_extend(help[row], {
			{ trunc(key, key_width, "right"), "CoreWinKey" },
			{ " " },
			{ "➜", "CoreWinKeySep" },
			{ " " },
			{ trunc(keymap.desc or "", col_width - key_width - 3), "CoreWinKeyDesc" },
		})
	end
	win:show()
	for l, line in ipairs(help) do
		---@cast win.buf integer
		vim.api.nvim_buf_set_lines(win.buf, l - 1, l, false, { "" })
		vim.api.nvim_buf_set_extmark(win.buf, ns, l - 1, 0, {
			virt_text = line,
			virt_text_pos = "overlay",
		})
	end
end

---@param event string|string[]
---@param cb fun(self: core.win, ev:vim.api.keyset.create_autocmd.callback_args):boolean?
---@param opts? core.win.Event
function M:on(event, cb, opts)
	opts = opts or {}
	opts.callback = cb
	table.insert(self.events, vim.tbl_extend("keep", { event = event }, opts))
	if self:valid() then
		self:_on(event, opts)
	end
end

---@param event string|string[]
---@param opts core.win.Event
function M:_on(event, opts)
	local event_opts = {} ---@type vim.api.keyset.create_autocmd
	local skip = { "buf", "win", "event" }
	for k, v in pairs(opts) do
		if not vim.tbl_contains(skip, k) then
			---@diagnostic disable-next-line: assign-type-mismatch
			event_opts[k] = v
		end
	end
	event_opts.group = event_opts.group or self.augroup
	event_opts.callback = function(ev)
		table.insert(event_stack, ev.event)
		---@diagnostic disable-next-line: param-type-mismatch
		local ok, err = pcall(opts.callback, self, ev)
		table.remove(event_stack)
		---@diagnostic disable-next-line: return-type-mismatch
		return not ok and error(err) or err
	end
	if event_opts.pattern or event_opts.buffer then
	-- don't alter the pattern or buffer
	elseif opts.win then
		event_opts.pattern = self.win .. ""
	elseif opts.buf then
		event_opts.buffer = self.buf
	end
	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_create_autocmd(event, event_opts)
end

function M:focus()
	if self:valid() then
		---@cast self.win integer
		vim.api.nvim_set_current_win(self.win)
	end
end

function M:redraw()
	---@diagnostic disable-next-line: unnecessary-if
	if vim.api.nvim__redraw then
		vim.api.nvim__redraw({ win = self.win, valid = false, flush = true, cursor = false })
	else
		vim.cmd("redraw")
	end
end

function M:hscroll(left)
	---@cast self.win integer
	vim.api.nvim_win_call(self.win, function()
		vim.cmd(("normal! %s"):format(left and "zh" or "zl"))
	end)
end

---@param up? boolean
function M:scroll(up)
	---@cast self.win integer
	vim.api.nvim_win_call(self.win, function()
		vim.cmd(("normal! %d%s"):format(vim.wo[self.win].scroll, up and SCROLL_UP or SCROLL_DOWN))
	end)
end

function M:destroy()
	pcall(function()
		self:close()
	end)
	self.events = {}
	self.keys = {}
	self.meta = {}
	-- self.opts = {}
end

---@param opts? { buf: boolean }
function M:close(opts)
	---@diagnostic disable-next-line: assign-type-mismatch
	opts = opts or {}
	local wipe = opts.buf ~= false and self.buf == self.scratch_buf

	local win = self.win
	local buf = wipe and self.buf
	local scratch_buf = self.scratch_buf ~= self.buf and self.scratch_buf or nil
	self:on_close()

	self.win = nil
	if scratch_buf then
		self.scratch_buf = nil
	end
	if buf then
		self.buf = nil
	end

	local close = function()
		local errors = {} ---@type string[]
		if win and vim.api.nvim_win_is_valid(win) then
			local ok, err = pcall(vim.api.nvim_win_close, win, true)
			if not ok and (err and err:find("E444")) then
				-- last window, so creat a split and close it again
				vim.cmd("silent! vsplit")
				pcall(vim.api.nvim_win_close, win, true)
			elseif not ok then
				---@diagnostic disable-next-line: assign-type-mismatch
				errors[#errors + 1] = err
			end
		end
		if buf and vim.api.nvim_buf_is_valid(buf) then
			local ok, err = pcall(vim.api.nvim_buf_delete, buf, { force = true })
			errors[#errors + 1] = not ok and err or nil
		end
		if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
			local ok, err = pcall(vim.api.nvim_buf_delete, scratch_buf, { force = true })
			errors[#errors + 1] = not ok and err or nil
		end
		if self.augroup then
			pcall(vim.api.nvim_del_augroup_by_id, self.augroup)
			self.augroup = nil
		end
		if #errors > 0 then
			error(table.concat(errors, "\n"))
		end
	end
	local retries = 0
	local try_close ---@type fun()
	try_close = function()
		local ok, err = pcall(close)
		if ok or not err then
			return
		end

		-- command window is open
		if err:find("E11") then
			vim.defer_fn(try_close, 200)
			return
		end

		-- text lock
		if err:find("E565") and retries < 20 then
			retries = retries + 1
			vim.defer_fn(try_close, 50)
			return
		end

		if not ok then
			Utils.log.error("Failed to close window: " .. err)
		end
	end
	-- HACK: WinClosed is not recursive, so we need to schedule it
	-- if we're in a WinClosed event
	if vim.tbl_contains(event_stack, "WinClosed") or not pcall(close) then
		vim.schedule(try_close)
	end
end

function M:hide()
	self:close({ buf = false })
	return self
end

function M:toggle()
	if self:valid() then
		self:hide()
	else
		self:show()
	end
	return self
end

---@param title string|{[1]:string, [2]:string}[]
---@param pos? "center"|"left"|"right"
function M:set_title(title, pos)
	if not self:has_border() then
		return
	end
	if type(title) == "string" then
		title = vim.trim(title)
		if title ~= "" then
			-- HACK: add extra space when last char is non word
			-- like for icons etc
			if not title:sub(-1):match("%w") then
				title = title .. " "
			end
			title = " " .. title .. " "
		end
	elseif #title == 0 then
		title = ""
	end
	pos = pos or self.opts.title_pos or "center"
	if vim.deep_equal(self.opts.title, title) and self.opts.title_pos == pos then
		return
	end
	self.opts.title = title
	self.opts.title_pos = pos
	if not self:valid() then
		return
	end
	-- Don't try to update if the relative window is invalid.
	-- It will be fixed once a full update is done.
	---@cast self.win integer
	local relative_win = vim.api.nvim_win_get_config(self.win).win
	if relative_win and not vim.api.nvim_win_is_valid(relative_win) then
		return
	end
	vim.api.nvim_win_set_config(self.win, {
		title = self.opts.title,
		title_pos = self.opts.title_pos,
	})
end

---@private
function M:open_buf()
	if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
		-- keep existing buffer
		self.buf = self.buf
	elseif self.scratch_buf and vim.api.nvim_buf_is_valid(self.scratch_buf) then
		-- keep existing scratch buffer
		self.buf = self.scratch_buf
	elseif self.opts.file then
		self.buf = vim.fn.bufadd(self.opts.file)
		if not vim.api.nvim_buf_is_loaded(self.buf) then
			vim.bo[self.buf].readonly = true
			vim.bo[self.buf].swapfile = false
			vim.fn.bufload(self.buf)
			vim.bo[self.buf].modifiable = false
		end
	elseif self.opts.buf then
		self.buf = self.opts.buf
	else
		self:scratch()
	end
	return self.buf
end

function M:scratch()
	if self.buf == self.scratch_buf and self:buf_valid() then
		return
	end
	self.buf = vim.api.nvim_create_buf(false, true)
	vim.bo[self.buf].swapfile = false
	self.scratch_buf = self.buf
	local text = type(self.opts.text) == "function" and self.opts.text() or self.opts.text
	text = type(text) == "string" and vim.split(text, "\n") or text
	if text then
		---@cast text string[]
		vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, text)
	end
	---@diagnostic disable-next-line: need-check-nil
	if not self.opts.bo.filetype then
		if self.opts.scratch_ft then
			vim.bo[self.buf].filetype = self.opts.scratch_ft
		else
			---@diagnostic disable-next-line: need-check-nil
			vim.bo[self.buf].filetype = self.opts.bo.filetype or "core_win"
		end
		vim.bo[self.buf].syntax = ""
	end
	if self:win_valid() then
		---@cast self.win integer
		vim.api.nvim_win_set_buf(self.win, self.buf)
	end
end

---@private
function M:open_win()
	local relative = self.opts.relative or "editor"
	local position = self.opts.position or "float"
	local enter = self.opts.enter == nil or self.opts.enter or false
	if self.opts.focusable == false then
		enter = false
	end
	local opts = self:win_opts()
	if position == "float" then
		---@cast self.buf integer
		self.win = vim.api.nvim_open_win(self.buf, enter, opts)
	elseif position == "current" then
		self.win = vim.api.nvim_get_current_win()
		---@cast self.buf integer
		vim.api.nvim_win_set_buf(self.win, self.buf)
	else --split
		local parent = self.opts.win and vim.api.nvim_win_is_valid(self.opts.win) and self.opts.win or 0
		local vertical = position == "left" or position == "right"
		-- When stacking is enabled, find an existing window with the same relative/position
		-- and stack the new window perpendicular to it instead of creating a new split
		if parent == 0 and self.opts.stack then
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				if
					vim.w[win].core_win
					and vim.w[win].core_win.relative == relative
					and vim.w[win].core_win.position == position
					and vim.w[win].core_win.stack == true
				then
					parent = win
					relative = "win"
					position = vertical and "bottom" or "right"
					vertical = not vertical
					break
				end
			end
		end
		local cmd = split_commands[relative][position]
		local size = vertical and opts.width or opts.height
		local resize = ("%sresize %s"):format(vertical and "vertical " or "", size)
		vim.api.nvim_win_call(parent, function()
			vim.cmd("silent noswapfile " .. cmd .. " sbuffer " .. self.buf .. " | " .. resize)
			self.win = vim.api.nvim_get_current_win()
		end)
		if enter then
			---@cast self.win integer
			vim.api.nvim_set_current_win(self.win)
		end
		vim.schedule(function()
			self:equalize()
		end)
	end
	vim.w[self.win].core_win = {
		id = self.id,
		position = self.opts.position,
		relative = self.opts.relative,
		stack = self.opts.stack,
	}
end

---@private
function M:equalize()
	if self:is_floating() then
		return
	end
	local all = vim.tbl_filter(function(win)
		return vim.w[win].core_win
			and vim.w[win].core_win.relative == self.opts.relative
			and vim.w[win].core_win.position == self.opts.position
	end, vim.api.nvim_tabpage_list_wins(0))
	if #all <= 1 then
		return
	end
	local vertical = self.opts.position == "left" or self.opts.position == "right"
	---@diagnostic disable-next-line: undefined-field
	local parent_size = self:parent_size()[vertical and "height" or "width"]
	---@diagnostic disable-next-line: need-check-nil
	local size = math.floor(parent_size / #all)
	for _, win in ipairs(all) do
		vim.api.nvim_win_call(win, function()
			vim.cmd(("%s resize %s"):format(vertical and "horizontal" or "vertical", size))
		end)
	end
end

function M:update()
	if self:valid() then
		---@cast self.buf integer
		Utils.bo(self.buf, self.opts.bo or {})
		---@cast self.win integer
		Utils.wo(self.win, self.opts.wo or {})
		if self:is_floating() then
			local opts = self:win_opts()
			opts.noautocmd = nil
			vim.api.nvim_win_set_config(self.win, opts)
		end
	end
end

function M:on_current_tab()
	---@cast self.win integer
	return self:win_valid() and vim.api.nvim_get_current_tabpage() == vim.api.nvim_win_get_tabpage(self.win)
end

function M:show()
	if self:valid() then
		self:update()
		return self
	end
	self.augroup = vim.api.nvim_create_augroup("core_win_" .. self.id, { clear = true })

	self:open_buf()

	-- buffer local variables
	for k, v in pairs(self.opts.b or {}) do
		vim.b[self.buf][k] = v
	end

	-- OPTIM: prevent treesitter or syntax highlighting to attach on FileType if it's not already enabled
	local optim_hl = not vim.b[self.buf].ts_highlight and vim.bo[self.buf].syntax == ""
	vim.b[self.buf].ts_highlight = optim_hl or vim.b[self.buf].ts_highlight
	---@cast self.buf integer
	Utils.bo(self.buf, self.opts.bo or {})
	vim.b[self.buf].ts_highlight = not optim_hl and vim.b[self.buf].ts_highlight or nil

	if self.opts.on_buf then
		self.opts.on_buf(self)
	end

	if self.opts.footer_keys then
		self.opts.footer = {}
		table.sort(self.keys, function(a, b)
			return a[1] < b[1]
		end)
		local want = type(self.opts.footer_keys) == "table" and self.opts.footer_keys or nil
		---@cast want string[]|nil
		want = want and vim.tbl_map(Utils.normkey, want) or nil --[[@as string[]?]]
		for _, key in ipairs(self.keys) do
			local keymap = Utils.normkey(key[1] or "")
			if want == nil or vim.tbl_contains(want, keymap) then
				table.insert(self.opts.footer, { " ", "CoreFooter" })
				table.insert(self.opts.footer, { " " .. keymap .. " ", "CoreFooterKey" })
				table.insert(self.opts.footer, { " " .. (key.desc or keymap) .. " ", "CoreFooterDesc" })
			end
		end
		table.insert(self.opts.footer, { " ", "CoreFooter" })
	end

	self:open_win()
	self.closed = false
	-- window local variables
	for k, v in pairs(self.opts.w or {}) do
		vim.w[self.win][k] = v
	end
	if Utils.hlgroup.is_transparent() then
		self.opts.wo.winblend = 0
	end
	---@cast self.win integer
	Utils.wo(self.win, self.opts.wo or {})
	if self.opts.on_win then
		self.opts.on_win(self)
	end

	-- syntax highlighting
	local ft = self.opts.ft or vim.bo[self.buf].filetype
	if ft and not ft:find("^core_") and not vim.b[self.buf].ts_highlight and vim.bo[self.buf].syntax == "" then
		local lang = vim.treesitter.language.get_lang(ft)
		if not (lang and pcall(vim.treesitter.start, self.buf, lang)) then
			vim.bo[self.buf].syntax = ft
		end
	end

	for _, event in ipairs(self.events) do
		---@diagnostic disable-next-line: param-type-mismatch
		self:_on(event.event, event)
	end

	-- swap buffers when opening a new buffer in the same window
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = self.augroup,
		nested = true,
		callback = function()
			return self:fixbuf()
		end,
	})

	self:map()
	self:drop()

	return self
end

function M:fixbuf()
	-- window closes, so delete the autocmd
	if not self:win_valid() then
		return true
	end

	if not self:buf_valid() then
		return
	end

	if not self:on_current_tab() then
		return
	end

	---@cast self.win integer
	local buf = vim.api.nvim_win_get_buf(self.win)

	-- same buffer
	if buf == self.buf then
		return
	end

	-- don't swap if fixbuf is disabled
	if self.opts.fixbuf == false then
		self.buf = buf
		-- update window options
		Utils.wo(self.win, self.opts.wo or {})
		return
	end

	-- another buffer was opened in this window
	-- find another window to swap with
	local main ---@type integer?
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local win_buf = vim.api.nvim_win_get_buf(win)
		local is_float = vim.api.nvim_win_get_config(win).zindex ~= nil
		if win ~= self.win and not is_float then
			if vim.bo[win_buf].buftype == "" or vim.b[win_buf].core_main or vim.w[win].core_main then
				main = win
				break
			end
		end
	end

	if main then
		---@cast self.buf integer
		vim.api.nvim_win_set_buf(self.win, self.buf)
		vim.api.nvim_win_set_buf(main, buf)
		vim.api.nvim_set_current_win(main)
		vim.cmd.stopinsert()
	else
		-- no main window found, so close this window
		---@cast self.buf integer
		vim.api.nvim_win_set_buf(self.win, self.buf)
		vim.schedule(function()
			vim.cmd.stopinsert()
			vim.cmd("sbuffer " .. buf)
			if self.win and vim.api.nvim_win_is_valid(self.win) then
				vim.api.nvim_win_close(self.win, true)
			end
		end)
	end
end

---@param buf integer
function M:set_buf(buf)
	---@diagnostic disable-next-line: call-non-callable
	assert(self:valid(), "Window is not valid")
	self.buf = buf
	---@cast self.win integer
	vim.api.nvim_win_set_buf(self.win, buf)
	Utils.wo(self.win, self.opts.wo or {})
end

function M:map()
	if not self:buf_valid() then
		return
	end
	for _, spec in pairs(self.keys) do
		local opts = vim.deepcopy(spec)
		opts[1] = nil
		opts[2] = nil
		opts.mode = nil
		---@diagnostic disable-next-line: cast-type-mismatch, inject-field
		---@cast opts vim.keymap.set.Opts
		opts.buffer = self.buf
		opts.nowait = true
		local rhs = spec[2]
		local is_action = type(rhs) == "string" or type(rhs) == "table"
		if is_action then
			local desc = spec.desc
			---@diagnostic disable-next-line: param-type-mismatch
			rhs, desc = self:action(rhs)
			opts.desc = opts.desc or desc
		else
			rhs = function()
				---@diagnostic disable-next-line: call-non-callable, need-check-nil
				return spec[2](self)
			end
		end
		spec.desc = spec.desc or opts.desc
		---@diagnostic disable-next-line: param-type-mismatch
		---@cast spec core.win.Keys
		vim.keymap.set(spec.mode or "n", spec[1], rhs, opts)
	end
end

---@private
function M:on_close()
	-- close the backdrop
	if self.backdrop then
		self.backdrop:close()
		self.backdrop = nil
	end
	if self.closed then
		return
	end
	self.closed = true
	if self.opts.on_close then
		self.opts.on_close(self)
	end
	-- Go back to the previous window when closing,
	-- and it's the current window
	if vim.api.nvim_get_current_win() == self.win then
		pcall(vim.cmd.wincmd, "p")
	end
end

function M:add_padding()
	---@diagnostic disable-next-line: need-check-nil
	local listchars = vim.split(self.opts.wo.listchars or "", ",")
	listchars = vim.tbl_filter(function(s)
		return not s:find("eol:") and s ~= ""
	end, listchars)
	table.insert(listchars, "eol: ")
	---@diagnostic disable-next-line: need-check-nil
	self.opts.wo.listchars = table.concat(listchars, ",")
	---@diagnostic disable-next-line: need-check-nil
	self.opts.wo.list = true
	---@diagnostic disable-next-line: need-check-nil
	self.opts.wo.statuscolumn = " "
end

function M:is_floating()
	---@cast self.win integer
	return self:valid() and vim.api.nvim_win_get_config(self.win).zindex ~= nil
end

---@private
function M:drop()
	if self.backdrop then
		self.backdrop:close()
		self.backdrop = nil
	end
	local backdrop = self.opts.backdrop
	if not backdrop then
		return
	end
	backdrop = type(backdrop) == "number" and { blend = backdrop } or backdrop
	backdrop = backdrop == true and {} or backdrop
	---@diagnostic disable-next-line: param-type-mismatch
	backdrop = vim.tbl_extend("force", { bg = "#000000", blend = 60, transparent = true }, backdrop)
	---@cast backdrop core.win.Backdrop

	if
		(Utils.hlgroup.is_transparent() and backdrop.transparent)
		or not vim.o.termguicolors
		or backdrop.blend == 100
		or not self:is_floating()
	then
		return
	end

	local bg, winblend = backdrop.bg or "#000000", backdrop.blend

	if not backdrop.transparent then
		if Utils.hlgroup.is_transparent() then
			bg = nil
		else
			bg = Utils.hlgroup.blend(Utils.hlgroup.color("Normal", "bg"), bg, winblend / 100)
		end
		winblend = 0
	end

	local group = ("CoreBackdrop_%s"):format(bg and bg:sub(2) or "T")
	vim.api.nvim_set_hl(0, group, { bg = bg })

	self.backdrop = M.new(M.resolve({
		enter = false,
		backdrop = false,
		relative = "editor",
		height = 0,
		width = 0,
		style = "minimal",
		border = "none",
		focusable = false,
		---@diagnostic disable-next-line: need-check-nil
		zindex = self.opts.zindex - 1,
		wo = {
			winhighlight = "Normal:" .. group,
			winblend = winblend,
			colorcolumn = "",
		},
		bo = {
			buftype = "nofile",
			filetype = "core_win_backdrop",
		},
	}, backdrop.win))
end

function M:line(line)
	return self:lines(line, line)[1] or ""
end

---@param from? integer 1-indexed, inclusive
---@param to? integer 1-indexed, inclusive
function M:lines(from, to)
	---@cast self.buf integer
	return self:buf_valid() and vim.api.nvim_buf_get_lines(self.buf, from and from - 1 or 0, to or -1, false) or {}
end

---@param from? integer 1-indexed, inclusive
---@param to? integer 1-indexed, inclusive
function M:text(from, to)
	return table.concat(self:lines(from, to), "\n")
end

---@return { height: integer, width: integer }
function M:parent_size()
	---@cast self.opts.win integer
	if self.opts.relative == "win" and vim.api.nvim_win_is_valid(self.opts.win) then
		return {
			height = vim.api.nvim_win_get_height(self.opts.win),
			width = vim.api.nvim_win_get_width(self.opts.win),
		}
	end
	return {
		height = vim.o.lines,
		width = vim.o.columns,
	}
end

---@private
function M:win_opts()
	local opts = {} ---@type vim.api.keyset.win_config
	for _, k in ipairs(win_opts) do
		opts[k] = self.opts[k]
	end

	local border = self:border()

	opts.border = border and (borders[border] or border) or "none"

	if opts.relative == "cursor" then
		self.opts.row = self.opts.row or 0
		self.opts.col = self.opts.col or 0
	end

	local dim = self:dim()
	opts.height, opts.width = dim.height, dim.width
	opts.row, opts.col = dim.row, dim.col

	if vim.fn.has("nvim-0.10") == 0 then
		opts.footer, opts.footer_pos = nil, nil
	end

	if border then
		opts.title_pos = opts.title and (opts.title_pos or "center") or nil
		opts.footer_pos = opts.footer and (opts.footer_pos or "center") or nil
	else
		opts.title, opts.footer = nil, nil
		opts.title_pos, opts.footer_pos = nil, nil
	end

	return opts
end

---@return { height: integer, width: integer }
function M:size()
	local opts = self:win_opts()
	local height = opts.height or 60
	local width = opts.width or 80
	if self:has_border() then
		height = height + 2
		width = width + 2
	end
	return { height = height, width = width }
end

function M:has_border()
	return self:border() ~= nil
end
function M.is_border(border)
	return border and border ~= "" and border ~= "none"
end

function M:border()
	if not M.is_border(self.opts.border) then
		return
	end

	if self.opts.border == true then
		local border ---@type string|string[]|nil
		pcall(function()
			border = vim.o.winborder
			border = border:find(",") and vim.split(border, ",") or border
		end)
		return M.is_border(border) and border or "rounded"
	end
	return self.opts.border
end

function M:border_size()
	-- The array specifies the eight
	-- chars building up the border in a clockwise fashion
	-- starting with the top-left corner.
	-- { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }
	local border = self:border() or { "" }
	border = type(border) == "string" and borders[border] or border
	border = type(border) == "string" and { "x" } or border
	---@diagnostic disable-next-line: call-non-callable
	assert(type(border) == "table", "Invalid border type")
	---@cast border string[]
	while #border < 8 do
		vim.list_extend(border, border)
	end
	-- remove border hl groups
	border = vim.tbl_map(function(b)
		return type(b) == "table" and b[1] or b
	end, border)
	local function size(from, to)
		for i = from, to do
			if border[i] ~= "" then
				return 1
			end
		end
		return 0
	end
	---@type { top: number, right: number, bottom: number, left: number }
	return {
		top = size(1, 3),
		right = size(3, 5),
		bottom = size(5, 7),
		left = math.max(size(7, 8), size(1, 1)),
	}
end

function M:border_text_width()
	if not self:has_border() then
		return 0
	end
	local ret = 0
	for _, t in ipairs({ "title", "footer" }) do
		local str = self.opts[t] or {}
		str = type(str) == "string" and { str } or str
		---@cast str (string|string[])[]
		ret = math.max(ret, #table.concat(
			vim.tbl_map(function(s)
				return type(s) == "string" and s or s[1]
			end, str),
			""
		))
	end
	return ret
end

function M:buf_valid()
	return self.buf and vim.api.nvim_buf_is_valid(self.buf)
end

function M:win_valid()
	return self.win and vim.api.nvim_win_is_valid(self.win)
end
function M:valid()
	---@cast self.win integer
	return self:win_valid() and self:buf_valid() and vim.api.nvim_win_get_buf(self.win) == self.buf
end

---@param parent? core.win.Dim
function M:dim(parent)
	---@diagnostic disable-next-line: assign-type-mismatch
	parent = parent or self:parent_size()
	---@type core.win.Dim
	local ret = {
		height = 0,
		width = 0,
		col = 0,
		row = 0,
		border = self:has_border(),
	}

	---@param s? number|fun(win: core.win):number? size
	---@param ps number parent size
	local function size(s, ps, border_offset)
		s = type(s) == "function" and s(self) or s or 0
		---@cast s number
		if s == 0 then -- full size
			return ps - border_offset
		elseif s < 1 then -- relative size
			return math.floor(ps * s) - border_offset
		end
		return s
	end

	---@param p? integer|fun(win:core.win):integer? pos
	---@param s integer size
	---@param ps integer parent size
	local function pos(p, s, ps, border_from, border_to)
		p = type(p) == "function" and p(self) or p
		---@cast p number?
		if self.opts.relative == "cursor" then
			return p or 0
		end
		if not p then -- center
			return math.floor((ps - s) / 2) - border_from
		end
		---@cast p number
		if p < 0 then -- negative position
			return ps - s + p - border_from - border_to
		elseif p < 1 and p > 0 then -- relative position
			return math.floor(ps * p) + border_from
		end
		return p
	end

	local border = self:border_size()

	ret.height = size(self.opts.height, parent.height, border.top + border.bottom)
	ret.height = M.imax(ret.height, self.opts.min_height or 0, 1)
	ret.height = M.imin(ret.height, self.opts.max_height or ret.height, parent.height)
	ret.height = M.imax(ret.height, 1)

	ret.width = size(self.opts.width, parent.width, border.left + border.right)
	ret.width = M.imax(ret.width, self.opts.min_width or 0, 1)
	ret.width = M.imin(ret.width, self.opts.max_width or ret.width, parent.width)
	ret.width = M.imax(ret.width, 1)

	ret.row = pos(self.opts.row, ret.height, parent.height, border.top, border.bottom)
	ret.col = pos(self.opts.col, ret.width, parent.width, border.left, border.right)

	return ret
end

---@private
---@param ... number
---@return integer
function M.imax(...)
	return math.floor(math.max(...))
end

---@private
---@param ... number
---@return integer
function M.imin(...)
	return math.floor(math.min(...))
end

--- Calculate the next available zindex for windows.
--- New windows open on top of existing ones.
---@param opts? { zindex?: number, tab?: number|boolean, all?: boolean, max?: number }
---@overload fun(zindex: number): number
function M.zindex(opts)
	opts = opts or {}
	---@diagnostic disable-next-line: assign-type-mismatch
	opts = type(opts) == "number" and { zindex = opts } or opts
	local zindex = opts.zindex or 50
	local max = opts.max or 100
	local wins = opts.tab == false and vim.api.nvim_list_wins()
		or vim.api.nvim_tabpage_list_wins(math.floor(tonumber(opts.tab) or 0))
	for _, win in ipairs(wins) do
		if opts.all ~= false or vim.w[win].core_win then
			local other = (vim.api.nvim_win_get_config(win).zindex or 0)
			-- ignore very high zindex windows, like notifications, completion, etc
			if other > zindex and other < max then
				zindex = math.max(zindex, other + 2) --[[@as number]]
			end
		end
	end
	return zindex
end

return M
