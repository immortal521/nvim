---@diagnostic disable: await-in-sync
local M = {}

-- ANSI 颜色图标（用于 Picker 列表）
local icons_ansi = {
	attached = "\27[34m󰖩\27[0m", -- 蓝色 Attached
	enabled = "\27[32m\27[0m", -- 绿色 Configured / Enabled
	installed = "\27[33m\27[0m", -- 黄色 Installed (但未启用)
	unavailable = "\27[90m\27[0m", -- 灰色 Not Installed
}

-- 纯字符图标（用于 Preview 预览缓冲区，避免 ANSI 影响 Markdown 高亮）
local icons_plain = {
	attached = "󰖩",
	enabled = "",
	installed = "",
	unavailable = "",
}

---生成 LSP 配置的 Markdown 预览内容
---@param item table
---@return string[]
local function build_preview_lines(item)
	local lines = {}
	local config = item.config or {}

	lines[#lines + 1] = "# " .. item.name
	lines[#lines + 1] = ""

	-- 按优先级只显示最高级的单个状态（图标在前）
	local status_str
	if item.attached then
		status_str = string.format("%s **Attached**", icons_plain.attached)
	elseif item.enabled then
		status_str = string.format("%s **Configured**", icons_plain.enabled)
	elseif item.installed then
		status_str = string.format("%s **Installed**", icons_plain.installed)
	else
		status_str = string.format("%s **Not Installed**", icons_plain.unavailable)
	end

	lines[#lines + 1] = "- **Status**: " .. status_str

	if config.cmd then
		local cmd_str = type(config.cmd) == "table" and table.concat(config.cmd, " ") or tostring(config.cmd)
		lines[#lines + 1] = "- **CMD**: `" .. cmd_str .. "`"
	end

	if config.filetypes and #config.filetypes > 0 then
		lines[#lines + 1] = "- **Filetypes**: `" .. table.concat(config.filetypes, ", ") .. "`"
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "## Configuration"
	lines[#lines + 1] = "```lua"

	local inspect_str = vim.inspect(config)
	vim.list_extend(lines, vim.split(inspect_str, "\n"))

	lines[#lines + 1] = "```"

	return lines
end

---@param opts? {
---  installed?: boolean,
---  configured?: boolean,
---  attached?: boolean|number
---}
function M.source(opts)
	opts = opts or {}

	-- 已挂载到缓冲区的 Client 集合
	local attached = {}
	for _, client in ipairs(vim.lsp.get_clients()) do
		attached[client.name] = true
	end

	-- 获取配置列表
	local filter = {}
	if opts.configured then
		filter.enabled = true
	end

	local configs = vim.lsp.get_configs(filter)
	local items = {}

	for _, config in ipairs(configs) do
		---@type string
		local name = config.name or ""
		local enabled = vim.lsp.is_enabled(name)

		local cmd = type(config.cmd) == "table" and config.cmd or nil
		local installed = false
		if cmd and cmd[1] and type(cmd[1]) == "string" then
			local exe = vim.fs.basename(cmd[1])
			installed = vim.fn.executable(exe) == 1
		end

		local want = true

		if opts.installed and not installed then
			want = false
		end

		if opts.attached == true and not attached[name] then
			want = false
		end

		if want then
			local icon

			if attached[name] then
				icon = icons_ansi.attached
			elseif enabled then
				icon = icons_ansi.enabled
			elseif installed then
				icon = icons_ansi.installed
			else
				icon = icons_ansi.unavailable
			end

			table.insert(items, {
				name = name,
				config = config,
				installed = installed,
				enabled = enabled,
				attached = attached[name] or false,
				display = string.format("%s %-20s", icon, name),
			})
		end
	end

	return items
end

local function sort_key(item)
	if item.attached then
		return 1
	elseif item.enabled then
		return 2
	elseif item.installed then
		return 3
	else
		return 4
	end
end

function M.picker(opts)
	local fzf = require("fzf-lua")
	local builtin = require("fzf-lua.previewer.builtin")

	local items = M.source(opts)

	table.sort(items, function(a, b)
		local ka, kb = sort_key(a), sort_key(b)
		if ka == kb then
			return a.name < b.name
		end
		return ka < kb
	end)

	local map = {}
	local entries = {}
	for _, item in ipairs(items) do
		local clean_display = fzf.utils.strip_ansi_coloring(item.display)
		map[item.display] = item
		map[clean_display] = item

		entries[#entries + 1] = item.display
	end

	-- 1. 自定义 Buffer 预览器（正确继承 builtin.buffer_or_file）
	local LspPreviewer = builtin.buffer_or_file:extend()

	function LspPreviewer:new(o, opts_param, fzf_win)
		---@diagnostic disable-next-line: param-type-mismatch
		LspPreviewer.super.new(self, o, opts_param, fzf_win)
		setmetatable(self, LspPreviewer)
		return self
	end

	function LspPreviewer:populate_preview_buf(entry_str)
		local tmpbuf = self:get_tmp_buffer()
		local clean_entry = fzf.utils.strip_ansi_coloring(entry_str)
		---@type table?
		local item = map[clean_entry] or map[entry_str]

		if item then
			local lines = build_preview_lines(item)
			vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
			vim.bo[tmpbuf].filetype = "markdown"
		end

		self:set_preview_buf(tmpbuf)
		self.win:update_preview_scrollbar()
	end

	function LspPreviewer:gen_winopts()
		return vim.tbl_extend("force", self.winopts, {
			wrap = true,
			number = false,
		})
	end

	-- 2. 调用 fzf-lua
	fzf.fzf_exec(entries, {
		prompt = "LSP Servers> ",
		previewer = LspPreviewer,
		actions = {
			["default"] = function(selected)
				if selected and selected[1] then
					local clean_selected = fzf.utils.strip_ansi_coloring(selected[1])

					---@type table?
					local item = map[clean_selected] or map[selected[1]]
					if item then
						local config_str = vim.inspect(item.config)
						vim.fn.setreg("+", config_str)
						vim.fn.setreg('"', config_str)
						vim.notify(
							"Copied LSP configuration for [" .. item.name .. "] to clipboard!",
							vim.log.levels.INFO
						)
					end
				end
			end,
		},
	})
end

return M
