---@diagnostic disable: await-in-sync
local M = {}

-- 日志级别配置（分别处理列表展示与预览展示）
local LEVEL_CONFIG = {
	INFO = { ansi = "\27[34m [INFO]\27[0m", plain = "[INFO]" },
	WARN = { ansi = "\27[33m [WARN]\27[0m", plain = "[WARN]" },
	ERROR = { ansi = "\27[31m [ERROR]\27[0m", plain = "[ERROR]" },
	DEBUG = { ansi = "\27[35m [DEBUG]\27[0m", plain = "[DEBUG]" },
	TRACE = { ansi = "\27[90m [TRACE]\27[0m", plain = "[TRACE]" },
}

local function append_text_lines(lines, value)
	for _, line in ipairs(vim.split(tostring(value), "\n", { plain = true })) do
		lines[#lines + 1] = line:gsub("\r$", "")
	end
end

---生成 Notification 的 Markdown 预览内容
---@param item table
---@return string[]
local function build_preview_lines(item)
	local title = item.title or {}
	local message = item.message or {}
	local lvl_info = LEVEL_CONFIG[item.level] or { plain = "[" .. tostring(item.level) .. "]" }

	local lines = {
		"# " .. (title[1] or "Notify"),
		"",
		string.format("- **Level**: `%s`", lvl_info.plain),
	}

	if item.backend then
		lines[#lines + 1] = string.format("- **Backend**: `%s`", item.backend)
	end

	if title[2] and title[2] ~= "" then
		lines[#lines + 1] = string.format("- **Time**: `%s`", title[2])
	end

	vim.list_extend(lines, { "", "## Message", "" })

	if type(message) == "table" then
		for _, line in ipairs(message) do
			append_text_lines(lines, line)
		end
	else
		append_text_lines(lines, message)
	end

	return lines
end

---获取格式化后的通知和 messages 历史列表数据
---@return table[]
function M.source()
	---@diagnostic disable-next-line: undefined-field
	local history = Builtin.notify.history()

	-- 按 ID 倒序（最新的在前）
	table.sort(history, function(a, b)
		return a.id > b.id
	end)

	local items = {}
	local seen_messages = {}
	local groups = {}
	local group_order = {}
	for _, item in ipairs(history) do
		local title = item.title and item.title[1] or "Notify"
		local backend = item.backend or "notify"
		local key = tostring(item.id)
		if backend == "fidget" and item.append then
			key = backend .. "\31" .. (item.notification_id or title)
		end
		local group = groups[key]
		if not group then
			group = {
				backend = backend,
				count = 0,
				latest = item,
				messages = {},
			}
			groups[key] = group
			group_order[#group_order + 1] = group
		end
		group.count = group.count + 1
		group.messages[#group.messages + 1] = {
			index = item.index or item.id,
			text = type(item.message) == "table" and table.concat(item.message, "\n") or tostring(item.message),
		}
	end

	for _, group in ipairs(group_order) do
		table.sort(group.messages, function(a, b)
			return a.index < b.index
		end)
		local item = group.latest
		local title = item.title and item.title[1] or "Notify"
		local time = item.title and item.title[2] or ""
		local lvl_info = LEVEL_CONFIG[item.level] or { ansi = "\27[90m [" .. tostring(item.level) .. "]\27[0m" }
		local messages = vim.tbl_map(function(message)
			return message.text
		end, group.messages)
		local msg_str = table.concat(messages, " | ")
		-- fzf 的每个条目必须占一行；预览保留同一来源的完整消息列表。
		msg_str = msg_str:gsub("[\r\n]+", " ")
		local display_title = group.count > 1 and (title .. " (" .. group.count .. ")") or title
		local display = string.format("%s  %-15s \27[90m%-8s\27[0m %s", lvl_info.ansi, display_title, time, msg_str)
		local raw = vim.deepcopy(item)
		raw.message = messages
		raw.backend = group.backend
		items[#items + 1] = {
			raw = raw,
			title = display_title,
			display = display,
		}
		for _, message in ipairs(messages) do
			seen_messages[message:gsub("[\r\n]+", " ")] = true
		end
	end

	-- bus 启动前产生的 :messages 不会经过 msg_show 订阅，补入尚未记录的行。
	local ok, messages = pcall(vim.fn.execute, "messages")
	if ok and type(messages) == "string" then
		for _, line in ipairs(vim.split(messages, "\n", { plain = true, trimempty = true })) do
			if line ~= "" and not seen_messages[line] then
				items[#items + 1] = {
					raw = {
						id = -#items,
						level = "INFO",
						backend = "messages",
						title = { "Messages", "" },
						message = line,
					},
					title = "Messages",
					display = string.format("%s  %-15s %s", LEVEL_CONFIG.INFO.ansi, "Messages", line),
				}
			end
		end
	end

	return items
end

function M.picker(opts)
	opts = opts or {}
	local fzf = require("fzf-lua")
	local builtin = require("fzf-lua.previewer.builtin")

	local items = M.source()

	if #items == 0 then
		vim.notify("No notifications found", vim.log.levels.WARN)
		return
	end

	local item_map = {}
	local entries = {}
	for i, item in ipairs(items) do
		entries[i] = item.display
		item_map[item.display] = item
		item_map[fzf.utils.strip_ansi_coloring(item.display)] = item
	end

	-- 继承 builtin.base，避免路径 stat 报错
	local NotifyPreviewer = builtin.base:extend()

	function NotifyPreviewer:new(o, opts_param, fzf_win)
		---@diagnostic disable-next-line: param-type-mismatch
		NotifyPreviewer.super.new(self, o, opts_param, fzf_win)
		setmetatable(self, NotifyPreviewer)
		return self
	end
	function NotifyPreviewer:populate_preview_buf(entry_str)
		local tmpbuf = self:get_tmp_buffer()
		local clean_entry = fzf.utils.strip_ansi_coloring(entry_str)
		---@type table?
		local item = item_map[entry_str] or item_map[clean_entry]

		if item then
			local preview_lines = build_preview_lines(item.raw)
			vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, preview_lines)
			vim.bo[tmpbuf].filetype = "markdown"
			-- 使用 Neovim 的 Markdown 渲染接口；不支持时保留原始 Markdown 文本。
			pcall(vim.lsp.util.stylize_markdown, tmpbuf, preview_lines, {})
			self.win:update_preview_title(item.title)
		end

		self:set_preview_buf(tmpbuf)
		self.win:update_preview_scrollbar()
	end

	function NotifyPreviewer:gen_winopts()
		return vim.tbl_extend("force", self.winopts, { wrap = true, number = false })
	end

	-- 调用 fzf-lua
	fzf.fzf_exec(entries, {
		prompt = "Notifications> ",
		-- fzf-lua 通过 `_ctor` 实例化自定义 previewer；直接传 class
		-- 会在选项合并阶段丢失其构造行为。
		previewer = {
			_ctor = function()
				return NotifyPreviewer
			end,
		},
		fzf_opts = {
			["--ansi"] = true,
		},
		winopts = {
			preview = {
				hidden = false,
				layout = "horizontal",
			},
		},
		actions = {
			["default"] = function(selected)
				if not (selected and selected[1]) then
					return
				end

				local clean_sel = fzf.utils.strip_ansi_coloring(selected[1])

				---@type table?
				local item = item_map[selected[1]] or item_map[clean_sel]
				if item then
					local msg = type(item.raw.message) == "table" and table.concat(item.raw.message, "\n")
						or item.raw.message

					vim.fn.setreg("+", msg)
					vim.fn.setreg('"', msg)

					vim.notify(
						string.format("Copied notification message from [%s] to clipboard!", item.title),
						vim.log.levels.INFO
					)
				end
			end,
		},
	})
end

return M
