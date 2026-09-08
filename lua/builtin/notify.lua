---@class builtin.notify.Options
---@field enabled? boolean
---@field timeout? number|false
---@field anchor? "NE"|"SE"
---@field width? integer
---@field max_width? number
---@field padding? integer 内容与边框之间的水平空白列数
---@field zindex? integer
---@field border? string|false
---@field border_hl? table<string, string>
---@field animation? "fade"|"slide"|"fade_slide"|"none"
---@field enter_animation? "fade"|"slide"|"fade_slide"|"none"
---@field leave_animation? "fade"|"slide"|"fade_slide"|"none"
---@field easing? string
---@field enter_duration? integer
---@field leave_duration? integer
---@field reflow_animation? "slide"|"none"
---@field reflow_duration? integer
---@field reflow_easing? string
---@field markdown? boolean 是否启用 Markdown 语法高亮

---@class builtin.notify.NotifyOpts: builtin.notify.Options
---@field title? string|false
---@field icon? string|false
---@field id? string
---@field replace? boolean
---@field mode? "append"|"replace"
---@field backend? "notify"|"fidget"
---@field message_hl? string|table<string, string>
---@field transparent? boolean
---@field auto_width? boolean

local M = {}

local levels = vim.log.levels
local level_names = {
	[levels.ERROR] = "Error",
	[levels.WARN] = "Warn",
	[levels.INFO] = "Info",
	[levels.DEBUG] = "Debug",
	[levels.TRACE] = "Trace",
}
local icons = {
	[levels.ERROR] = "",
	[levels.WARN] = "",
	[levels.INFO] = "",
	[levels.DEBUG] = "󰃤",
	[levels.TRACE] = "󰐤",
}

local defaults = {
	timeout = 3000,
	anchor = "NE",
	width = 36,
	max_width = 0.45,
	padding = 1,
	zindex = 200,
	border = "rounded",
	border_hl = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "FloatBorder",
		debug = "DiagnosticHint",
		trace = "Comment",
		success = "DiagnosticOk",
	},
	animation = "fade_slide",
	enter_animation = nil,
	leave_animation = "fade_slide",
	easing = "outQuad",
	enter_duration = 180,
	leave_duration = 180,
	reflow_animation = "slide",
	reflow_duration = 180,
	reflow_easing = "outQuad",
	markdown = true,
	backends = {
		notify = { enabled = true, anchor = "NE" },
		fidget = { enabled = true, anchor = "SE", border = false, title = false },
	},
}

---@class builtin.notify.Entry
---@field id? string
---@field win builtin.win
---@field anchor "NE"|"SE"
---@field height integer
---@field timer? uv.uv_timer_t
---@field generation integer
---@field closing? boolean
---@field message string
---@field border_hl string
---@field stack_gap integer
local stacks = { NE = {}, SE = {} }
local ids = { NE = {}, SE = {} }
local namespace = vim.api.nvim_create_namespace("BuiltinNotify")
local next_id = 0
local configured = false
local options = vim.deepcopy(defaults)
local history = {}
local history_id = 0
local interaction_namespace = vim.api.nvim_create_namespace("BuiltinNotifyInteraction")
local interaction_configured = false

local function anchor_of(opts)
	return opts.anchor == "SE" and "SE" or "NE"
end

local function width_for(opts)
	local max_width = math.max(1, math.floor(vim.o.columns * opts.max_width))
	return math.min(max_width, opts.width)
end

local function animation_for(opts, phase)
	return opts[phase .. "_animation"] or opts.animation or "none"
end

local function has_animation(animation, name)
	return animation == name or animation == "fade_slide"
end

local function rebuild_ids(anchor)
	ids[anchor] = {}
	for index, entry in ipairs(stacks[anchor]) do
		if entry.id then
			ids[anchor][entry.id] = index
		end
	end
end

local function set_position(entry, row, col)
	if not entry.win:valid() then
		return
	end
	entry.win.opts.row = row or entry.win.opts.row
	entry.win.opts.col = col or entry.win.opts.col
	local config = vim.api.nvim_win_get_config(entry.win.win)
	config.relative = "editor"
	config.anchor = entry.win.opts.anchor
	config.row = entry.win.opts.row
	config.col = entry.win.opts.col
	vim.api.nvim_win_set_config(entry.win.win, {
		relative = "editor",
		anchor = entry.win.opts.anchor,
		row = entry.win.opts.row,
		col = entry.win.opts.col,
		width = config.width,
		height = config.height,
		border = config.border,
		title = config.title,
		title_pos = config.title_pos,
		zindex = config.zindex,
	})
end

local function set_geometry(entry, width, row, col)
	if not entry.win:valid() then
		return
	end
	entry.win.opts.width = width or entry.win.opts.width
	entry.win.opts.row = row or entry.win.opts.row
	entry.win.opts.col = col or entry.win.opts.col
	local config = vim.api.nvim_win_get_config(entry.win.win)
	vim.api.nvim_win_set_config(entry.win.win, {
		relative = "editor",
		anchor = entry.win.opts.anchor,
		row = entry.win.opts.row,
		col = entry.win.opts.col,
		width = entry.win.opts.width,
		height = config.height,
		border = config.border,
		title = config.title,
		title_pos = config.title_pos,
		zindex = config.zindex,
	})
	if entry.border_hl then
		local normal_hl = entry.normal_hl or "NormalFloat"
		vim.api.nvim_set_option_value(
			"winhighlight",
			("Normal:%s,NormalNC:%s,FloatBorder:%s,FloatTitle:%s"):format(
				normal_hl,
				normal_hl,
				entry.border_hl,
				entry.border_hl
			),
			{ win = entry.win.win }
		)
	end
end

local function animate_row(entry, row)
	if not entry.win:valid() then
		return
	end
	local current = entry.win.opts.row or row
	if options.reflow_animation == "none" then
		set_position(entry, row)
		return
	end
	local id = "builtin_notify_" .. entry.win.id
	Builtin.animate(current, row, function(value)
		if entry.win:valid() then
			set_position(entry, value)
		end
	end, { id = id, int = true, easing = options.reflow_easing, duration = { total = options.reflow_duration } })
end

local function apply_border(entry)
	if entry.win:valid() and entry.border_hl then
		local normal_hl = entry.normal_hl or "NormalFloat"
		entry.win.opts.wo.winhighlight = ("Normal:%s,NormalNC:%s,FloatBorder:%s,FloatTitle:%s"):format(
			normal_hl,
			normal_hl,
			entry.border_hl,
			entry.border_hl
		)
		vim.api.nvim_set_option_value("winhighlight", entry.win.opts.wo.winhighlight, { win = entry.win.win })
	end
end

local function fade_in(entry, opts)
	if not has_animation(animation_for(opts, "enter"), "fade") then
		return
	end
	if not entry.win:valid() then
		return
	end
	local win = entry.win.win
	if not win then
		return
	end
	vim.wo[win].winblend = 100
	Builtin.animate(100, 0, function(value)
		if entry.win:valid() then
			vim.wo[win].winblend = value
		end
	end, {
		id = "builtin_notify_fade_" .. entry.win.id,
		int = true,
		easing = opts.easing,
		duration = { total = opts.enter_duration },
	})
end

local function slide_in(entry, opts)
	if not has_animation(animation_for(opts, "enter"), "slide") or not entry.win:valid() then
		return
	end
	local target_width = entry.win.opts.width
	set_geometry(entry, 1)
	Builtin.animate(1, target_width, function(value)
		if entry.win:valid() then
			set_geometry(entry, value)
		end
	end, {
		id = "builtin_notify_slide_" .. entry.win.id,
		int = true,
		easing = opts.easing,
		duration = { total = opts.enter_duration },
	})
end

local function animate_out(entry, opts, callback)
	local animation = animation_for(opts, "leave")
	local fade = has_animation(animation, "fade")
	local slide = has_animation(animation, "slide")
	if not entry.win:valid() or animation == "none" or (not fade and not slide) then
		callback()
		return
	end
	local pending = (fade and 1 or 0) + (slide and 1 or 0)
	local done = false
	local finish = function()
		pending = pending - 1
		if pending <= 0 and not done then
			done = true
			callback()
		end
	end
	-- 窗口尺寸变化或同一窗口上的其他动画可能中断回调。
	-- 在预定退出时间结束前保留窗口，并用兜底计时器确保最终关闭。
	vim.defer_fn(function()
		if not done then
			done = true
			callback()
		end
	end, (opts.leave_duration or 0) + 40)
	local win = entry.win.win
	if fade and win then
		Builtin.animate(vim.wo[win].winblend, 100, function(value, ctx)
			if entry.win:valid() then
				vim.wo[win].winblend = value
			end
			if ctx.done then
				finish()
			end
		end, {
			id = "builtin_notify_fade_" .. entry.win.id,
			int = true,
			easing = opts.easing,
			duration = { total = opts.leave_duration },
		})
	end
	if slide then
		local start_width = entry.win.opts.width
		Builtin.animate(start_width, 1, function(value, ctx)
			if entry.win:valid() then
				set_geometry(entry, value)
			end
			if ctx.done then
				finish()
			end
		end, {
			id = "builtin_notify_slide_" .. entry.win.id,
			int = true,
			easing = opts.easing,
			duration = { total = opts.leave_duration },
		})
	end
end

local function reflow(anchor, entering)
	local stack = stacks[anchor]
	local cursor = anchor == "NE" and 1 or vim.o.lines - 1
	local direction = anchor == "NE" and 1 or -1
	for _, entry in ipairs(stack) do
		if entry.win:valid() then
			if entry == entering then
				set_position(entry, cursor)
			elseif entering then
				animate_row(entry, cursor)
			elseif #stack > 1 then
				set_position(entry, cursor)
			else
				animate_row(entry, cursor)
			end
			local border_rows = entry.win.opts.border and 2 or 0
			cursor = cursor + direction * (entry.height + border_rows + entry.stack_gap)
		end
	end
end

local function remove(anchor, index, animate)
	local entry = table.remove(stacks[anchor], index)
	if not entry then
		return
	end
	if entry.timer then
		entry.timer:stop()
		entry.timer:close()
		entry.timer = nil
	end
	local close = function()
		if entry.win:valid() then
			entry.win:close()
		end
	end
	if animate and not entry.closing then
		entry.closing = true
		animate_out(entry, options, close)
	else
		close()
	end
	rebuild_ids(anchor)
	reflow(anchor)
end

local function arm_timer(entry, timeout)
	entry.timeout = timeout
	entry.generation = entry.generation + 1
	local generation = entry.generation
	if entry.timer then
		entry.timer:stop()
		entry.timer:close()
		entry.timer = nil
	end
	if entry.hovered then
		return
	end
	if timeout == false or not timeout or timeout <= 0 then
		return
	end
	entry.timer = vim.defer_fn(function()
		-- vim.defer_fn closes its timer after the callback; don't close it again
		-- from remove().
		entry.timer = nil
		if generation ~= entry.generation then
			return
		end
		for index, candidate in ipairs(stacks[entry.anchor]) do
			if candidate == entry then
				remove(entry.anchor, index, true)
				return
			end
		end
	end, timeout)
end

local function set_hovered_window(win)
	for _, stack in pairs(stacks) do
		for _, entry in ipairs(stack) do
			local hovered = entry.win and entry.win.win == win
			if hovered and not entry.hovered then
				entry.hovered = true
				if entry.timer then
					entry.timer:stop()
					entry.timer:close()
					entry.timer = nil
				end
			elseif not hovered and entry.hovered then
				entry.hovered = false
				arm_timer(entry, entry.timeout)
			end
		end
	end
end

local function setup_interaction()
	if interaction_configured then
		return
	end
	interaction_configured = true
	vim.o.mousemoveevent = true
	vim.on_key(function(key)
		if key == vim.keycode("<MouseMove>") then
			set_hovered_window(vim.fn.getmousepos().winid)
		end
	end, interaction_namespace)

	local group = vim.api.nvim_create_augroup("BuiltinNotifyInteraction", { clear = true })
	vim.api.nvim_create_autocmd("WinEnter", {
		group = group,
		callback = function()
			set_hovered_window(vim.api.nvim_get_current_win())
		end,
	})
	vim.api.nvim_create_autocmd("WinLeave", {
		group = group,
		callback = function()
			set_hovered_window(nil)
		end,
	})
end

local function render(entry, message, level, opts)
	local text = type(message) == "string" and message or vim.inspect(message)
	if opts.mode == "append" and entry.message and entry.message ~= "" then
		text = entry.message .. "\n" .. text
	end
	entry.message = text
	local lines = vim.split(text, "\n", { plain = true })
	local show_title = opts.title ~= false
	local title = show_title and (opts.title or level_names[level] or "Notification") or nil
	local show_icon = opts.icon ~= false and (show_title or opts.icon ~= nil)
	local icon = show_icon and (opts.icon or icons[level] or icons[levels.INFO]) or nil
	if show_icon and not show_title then
		lines[1] = icon .. " " .. lines[1]
	end
	local level_name = (level_names[level] or "Info"):lower()
	local border_hl = opts.border_hl[level_name] or opts.border_hl.info or "FloatBorder"
	local padding = math.max(0, opts.padding or 0)
	local pad = string.rep(" ", padding)
	local window_width = width_for(opts)
	if opts.auto_width then
		local longest = 1
		for _, line in ipairs(lines) do
			longest = math.max(longest, vim.fn.strdisplaywidth(line))
		end
		window_width = math.min(window_width, longest + 2 * padding)
	end
	local content_width = math.max(1, window_width - 2 * padding)
	local function fit_line(line)
		line = tostring(line)
		if vim.fn.strdisplaywidth(line) > content_width then
			line = vim.fn.strcharpart(line, 0, content_width)
		end
		return line .. string.rep(" ", math.max(0, content_width - vim.fn.strdisplaywidth(line)))
	end
	local rendered_lines = {}
	if show_title then
		local type_line = pad .. fit_line((" %s  %s "):format(icon, title)) .. pad
		-- Neovim 只提供 Markdown 语法高亮，不会把 `---` 绘制成图形分隔线。
		-- 使用等宽线字符，确保没有 Markdown 渲染器时仍然可见。
		local separator = pad .. string.rep("─", content_width) .. pad
		rendered_lines = { type_line, separator }
	end
	for _, line in ipairs(lines) do
		rendered_lines[#rendered_lines + 1] = pad .. fit_line(line) .. pad
	end
	local height = math.max(1, math.min(#rendered_lines, math.floor(vim.o.lines * 0.4)))
	entry.height = height
	entry.stack_gap = 0
	entry.win.opts.height = height
	entry.win.opts.width = window_width
	entry.win.opts.ft = opts.markdown == false and "builtin_notify" or "markdown"
	vim.bo[entry.win.buf].filetype = entry.win.opts.ft
	entry.border_hl = border_hl
	local normal_hl = opts.transparent and "Normal" or "NormalFloat"
	entry.normal_hl = normal_hl
	entry.win.opts.wo.winhighlight = ("Normal:%s,NormalNC:%s,FloatBorder:%s,FloatTitle:%s"):format(
		normal_hl,
		normal_hl,
		border_hl,
		border_hl
	)
	entry.win:set_title(show_title and ((show_icon and icon .. " ") or "") .. title or "")
	vim.bo[entry.win.buf].modifiable = true
	vim.api.nvim_buf_clear_namespace(entry.win.buf, namespace, 0, -1)
	vim.api.nvim_buf_set_lines(entry.win.buf, 0, -1, false, rendered_lines)
	if show_title then
		vim.api.nvim_buf_add_highlight(entry.win.buf, namespace, border_hl, 0, 0, -1)
		vim.api.nvim_buf_add_highlight(entry.win.buf, namespace, border_hl, 1, 0, -1)
	end
	local message_hl = opts.message_hl
	if type(message_hl) == "table" then
		message_hl = message_hl[level_name] or message_hl.info
	end
	if not message_hl and not show_title then
		message_hl = border_hl
	end
	if message_hl then
		local first_message_line = show_title and 2 or 0
		for line = first_message_line, #rendered_lines - 1 do
			vim.api.nvim_buf_add_highlight(entry.win.buf, namespace, message_hl, line, 0, -1)
		end
	end
	vim.bo[entry.win.buf].modifiable = false
	entry.win:update()
	apply_border(entry)
end

local function record_history(message, level, opts)
	local title = opts.title == false and (opts.backend == "fidget" and "Fidget" or "")
		or opts.title
		or level_names[level]
		or "Notification"
	history_id = history_id + 1
	table.insert(history, {
		id = history_id,
		level = (level_names[level] or "INFO"):upper(),
		backend = opts.backend or "notify",
		title = { title, os.date("%H:%M:%S") },
		message = type(message) == "string" and message or vim.inspect(message),
	})
	if #history > 500 then
		table.remove(history, 1)
	end
end

---@param message any
---@param level? integer
---@param opts? builtin.notify.NotifyOpts
---@return builtin.win
function M.notify(message, level, opts)
	level = level or levels.INFO
	local requested_opts = opts or {}
	local backend_opts = options.backends and options.backends[requested_opts.backend or "notify"] or {}
	opts = vim.tbl_extend("force", {}, options, backend_opts, requested_opts)
	record_history(message, level, opts)
	local anchor = anchor_of(opts)
	local index = opts.id and ids[anchor][opts.id]
	local entry = index and stacks[anchor][index]

	if entry and entry.win:valid() and opts.replace ~= false then
		render(entry, message, level, opts)
		arm_timer(entry, opts.timeout)
		reflow(anchor)
		return entry.win
	end

	next_id = next_id + 1
	entry = {
		id = opts.id,
		anchor = anchor,
		height = 1,
		generation = 0,
		message = "",
		stack_gap = 0,
	}
	local initial_level = (level_names[level] or "Info"):lower()
	entry.border_hl = opts.border_hl[initial_level] or opts.border_hl.info or "FloatBorder"
	entry.win = Builtin.win({
		show = false,
		row = anchor == "NE" and 1 or vim.o.lines - 1,
		col = vim.o.columns - 1,
		anchor = anchor,
		width = width_for(opts),
		height = 1,
		border = opts.border,
		focusable = true,
		enter = false,
		zindex = opts.zindex,
		wo = {
			wrap = false,
			number = false,
			cursorline = false,
			winhighlight = ("Normal:NormalFloat,NormalNC:NormalFloat,FloatBorder:%s,FloatTitle:%s"):format(
				entry.border_hl,
				entry.border_hl
			),
		},
		on_close = function()
			for i, candidate in ipairs(stacks[anchor]) do
				if candidate == entry then
					remove(anchor, i)
					return
				end
			end
		end,
	})
	entry.win:show()
	render(entry, message, level, opts)
	table.insert(stacks[anchor], 1, entry)
	rebuild_ids(anchor)
	arm_timer(entry, opts.timeout)
	reflow(anchor, entry)
	fade_in(entry, opts)
	slide_in(entry, opts)
	return entry.win
end

---@return table[]
function M.history()
	return vim.deepcopy(history)
end

function M.clear_history()
	history = {}
	history_id = 0
end

function M.dismiss(id)
	for anchor in pairs(stacks) do
		local index = ids[anchor][id]
		if index then
			remove(anchor, index, true)
		end
	end
end

---@param opts? { anchor?: "NE"|"SE" }
function M.dismiss_all(opts)
	local anchors = opts and opts.anchor and { opts.anchor } or { "NE", "SE" }
	for _, anchor in ipairs(anchors) do
		for index = #stacks[anchor], 1, -1 do
			remove(anchor, index, true)
		end
	end
end

local function typed(level, message, opts)
	return M.notify(message, level, opts)
end

function M.info(message, opts)
	return typed(levels.INFO, message, opts)
end

function M.warn(message, opts)
	return typed(levels.WARN, message, opts)
end

function M.error(message, opts)
	return typed(levels.ERROR, message, opts)
end

function M.debug(message, opts)
	return typed(levels.DEBUG, message, opts)
end

function M.trace(message, opts)
	return typed(levels.TRACE, message, opts)
end

function M.success(message, opts)
	opts = vim.tbl_extend("force", { icon = "", title = "Success" }, opts or {})
	opts.border_hl = vim.tbl_extend("force", { info = "DiagnosticOk" }, opts.border_hl or {})
	return typed(levels.INFO, message, opts)
end

function M.fidget(message, level, opts)
	local fidget_opts = options.backends and options.backends.fidget or {}
	opts = vim.tbl_extend("force", {
		anchor = fidget_opts.anchor or "SE",
		backend = "fidget",
		title = false,
		icon = fidget_opts.icon,
		padding = fidget_opts.padding or 0,
		width = fidget_opts.width,
		max_width = fidget_opts.max_width,
		transparent = true,
		auto_width = true,
		markdown = fidget_opts.markdown,
		border = fidget_opts.border,
		border_hl = fidget_opts.border_hl,
		message_hl = fidget_opts.message_hl,
	}, opts or {})
	return M.notify(message, level or levels.INFO, opts)
end

local function setup_notify_backend(backend_opts)
	if backend_opts.enabled == false then
		return
	end
	Builtin.bus.register_subscriber("builtin.notify", {
		exact = {
			"notify",
			"msg.clear",
		},
		min_level = levels.TRACE,
		handler = function(message)
			if message.tag == "msg.clear" then
				M.dismiss_all({ anchor = backend_opts.anchor })
				return
			end
			if message.tag == "notify" then
				local notify_opts = vim.tbl_deep_extend("force", {
					anchor = backend_opts.anchor,
					backend = "notify",
				}, message.data or {})
				M.notify(message.content, message.level, notify_opts)
				return
			end
		end,
	})
end

local function setup_fidget_backend(backend_opts)
	if backend_opts.enabled == false then
		return
	end
	Builtin.bus.register_subscriber("builtin.fidget", {
		exact = {
			"msg.clear",
			"msg.show.undo",
			"msg.show.echo",
			"msg.show.echomsg",
			"msg.show.unknown",
			"msg.show.bufwrite",
			"msg.show.progress",
			"msg.show.list_cmd",
			"msg.show.lua_print",
		},
		min_level = levels.TRACE,
		handler = function(message)
			if message.tag == "msg.clear" then
				M.dismiss_all({ anchor = backend_opts.anchor })
				return
			end
			local modes = {
				["msg.show.bufwrite"] = "append",
				["msg.show.lua_print"] = "append",
				["msg.show.echo"] = "append",
			}
			M.notify(message.content, message.level, {
				anchor = backend_opts.anchor,
				backend = "fidget",
				id = message.tag,
				mode = modes[message.tag] or "replace",
				title = false,
				icon = backend_opts.icon,
				padding = backend_opts.padding or 0,
				transparent = true,
				auto_width = true,
				markdown = backend_opts.markdown,
				border = backend_opts.border,
				border_hl = backend_opts.border_hl,
				message_hl = backend_opts.message_hl,
			})
		end,
	})
end

function M.setup(opts)
	if configured then
		return
	end
	configured = true
	options = vim.tbl_deep_extend("force", options, opts or {})
	setup_interaction()
	Builtin.bus.setup()
	local backends = options.backends or {}
	setup_notify_backend(backends.notify or {})
	setup_fidget_backend(backends.fidget or {})
	vim.notify = function(message, level, notify_opts)
		Builtin.bus.emit("notify", level or levels.INFO, message, notify_opts)
	end
	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("BuiltinNotify", { clear = true }),
		callback = function()
			reflow("NE")
			reflow("SE")
		end,
	})
end

return M
