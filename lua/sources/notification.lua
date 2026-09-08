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

---获取格式化后的 Notification 历史列表数据
---@return table[]
function M.source()
	---@diagnostic disable-next-line: undefined-field
	local history = Builtin.notify.history()

	if vim.tbl_isempty(history) then
		return {}
	end

	-- 按 ID 倒序（最新的在前）
	table.sort(history, function(a, b)
		return a.id > b.id
	end)

	local items = {}
	for _, item in ipairs(history) do
		local lvl_info = LEVEL_CONFIG[item.level] or { ansi = "\27[90m [" .. tostring(item.level) .. "]\27[0m" }
		local title = item.title and item.title[1] or "Notify"
		local time = item.title and item.title[2] or ""
		local msg_str = type(item.message) == "table" and table.concat(item.message, " ") or tostring(item.message)
		-- fzf 的每个条目必须占一行；预览仍使用 raw.message 保留原始换行。
		msg_str = msg_str:gsub("[\r\n]+", " ")

		-- 列表格式：级别、标题、时间和消息均保持可搜索文本；来源在 preview 中展示。
		local display = string.format("%s  %-15s \27[90m%-8s\27[0m %s", lvl_info.ansi, title, time, msg_str)

		items[#items + 1] = {
			raw = item,
			title = title,
			display = display,
		}
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
