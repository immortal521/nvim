---@diagnostic disable: await-in-sync
local M = {}

-- 状态枚举
local STATUS = {
	ATTACHED = { id = 1, ansi = "\27[34m󰖩\27[0m", plain = "󰖩", label = "Attached" },
	ENABLED = { id = 2, ansi = "\27[32m\27[0m", plain = "", label = "Configured" },
	INSTALLED = { id = 3, ansi = "\27[33m\27[0m", plain = "", label = "Installed" },
	UNAVAILABLE = { id = 4, ansi = "\27[90m\27[0m", plain = "", label = "Not Installed" },
}

---检测 CMD 可执行文件是否存在
---@param cmd? string[]|function
---@return boolean
local function is_executable(cmd)
	if type(cmd) == "function" then
		cmd = cmd()
	end
	return type(cmd) == "table" and type(cmd[1]) == "string" and vim.fn.executable(vim.fs.basename(cmd[1])) == 1
end

---生成 LSP 配置的 Markdown 预览内容
---@param item table
---@return string[]
local function build_preview_lines(item)
	local config = item.config or {}
	local st = item.status

	local lines = {
		"# " .. item.name,
		"",
		string.format("- **Status**: %s **%s**", st.plain, st.label),
	}

	if config.cmd then
		local cmd_str = type(config.cmd) == "table" and table.concat(config.cmd, " ") or tostring(config.cmd)
		lines[#lines + 1] = "- **CMD**: `" .. cmd_str .. "`"
	end

	if config.filetypes and #config.filetypes > 0 then
		lines[#lines + 1] = "- **Filetypes**: `" .. table.concat(config.filetypes, ", ") .. "`"
	end

	vim.list_extend(lines, { "", "## Configuration", "```lua" })
	vim.list_extend(lines, vim.split(vim.inspect(config), "\n", { plain = true }))
	lines[#lines + 1] = "```"

	return lines
end

---@param opts? { installed?: boolean, configured?: boolean, attached?: boolean }
function M.source(opts)
	opts = opts or {}

	-- 获取当前 Attach 的 Client 名称集合
	---@type table<string, boolean>
	local attached = {}
	for _, client in ipairs(vim.lsp.get_clients()) do
		attached[client.name] = true
	end

	local filter = opts.configured and { enabled = true } or nil
	local configs = vim.lsp.get_configs(filter)
	local items = {}

	for _, config in ipairs(configs) do
		local name = config.name or ""
		local is_attached = attached[name] == true
		local is_enabled = vim.lsp.is_enabled(name)
		local is_installed = is_executable(config.cmd)

		-- 确定状态
		local st = STATUS.UNAVAILABLE
		if is_attached then
			st = STATUS.ATTACHED
		elseif is_enabled then
			st = STATUS.ENABLED
		elseif is_installed then
			st = STATUS.INSTALLED
		end

		-- 过滤逻辑
		local keep = true
		if opts.installed and not is_installed then
			keep = false
		end
		if opts.attached and not is_attached then
			keep = false
		end

		if keep then
			items[#items + 1] = {
				name = name,
				config = config,
				status = st,
				display = string.format("%s %-20s", st.ansi, name),
			}
		end
	end

	return items
end

function M.picker(opts)
	local fzf = require("fzf-lua")
	local builtin = require("fzf-lua.previewer.builtin")

	local items = M.source(opts)

	-- 按优先级 id 升序，同级按名称字母序
	table.sort(items, function(a, b)
		if a.status.id ~= b.status.id then
			return a.status.id < b.status.id
		end
		return a.name < b.name
	end)

	local item_map = {}
	local entries = {}
	for i, item in ipairs(items) do
		entries[i] = item.display
		item_map[item.display] = item
		item_map[fzf.utils.strip_ansi_coloring(item.display)] = item
	end

	-- 预览器构建
	local LspPreviewer = builtin.buffer_or_file:extend()

	function LspPreviewer:populate_preview_buf(entry_str)
		local tmpbuf = self:get_tmp_buffer()
		---@type table?
		local item = item_map[entry_str] or item_map[fzf.utils.strip_ansi_coloring(entry_str)]

		if item then
			vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, build_preview_lines(item))
			vim.bo[tmpbuf].filetype = "markdown"
		end

		self:set_preview_buf(tmpbuf)
		self.win:update_preview_scrollbar()
	end

	function LspPreviewer:gen_winopts()
		return vim.tbl_extend("force", self.winopts, { wrap = true, number = false })
	end

	-- 调用 fzf-lua
	fzf.fzf_exec(entries, {
		prompt = "LSP Servers> ",
		previewer = LspPreviewer,
		actions = {
			["default"] = function(selected)
				if not (selected and selected[1]) then
					return
				end

				---@type table?
				local item = item_map[selected[1]] or item_map[fzf.utils.strip_ansi_coloring(selected[1])]
				if item then
					local config_str = vim.inspect(item.config)
					vim.fn.setreg("+", config_str)
					vim.fn.setreg('"', config_str)
					vim.notify(
						string.format("Copied LSP configuration for [%s] to clipboard!", item.name),
						vim.log.levels.INFO
					)
				end
			end,
		},
	})
end

return M
