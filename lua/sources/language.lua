local M = {}

local function preview_lines(item)
	local lines = {
		"# " .. item.name,
		"",
		"- **Filetypes**: `" .. item.filetypes .. "`",
		"- **LSP**: `" .. (item.lsp ~= "" and item.lsp or "none") .. "`",
		"- **Formatters**: `" .. (item.formatters ~= "" and item.formatters or "none") .. "`",
		"- **Linters**: `" .. (item.linters ~= "" and item.linters or "none") .. "`",
		"",
		"## 配置源码",
		"",
	}
	local content = vim.fn.readfile(item.file)
	vim.list_extend(lines, { "```lua" })
	vim.list_extend(lines, content)
	vim.list_extend(lines, { "```" })
	return lines
end

function M.picker(opts)
	opts = opts or {}
	local fzf = require("fzf-lua")
	local builtin = require("fzf-lua.previewer.builtin")
	local items = require("toolchain").lang.source_items()
	local item_map = {}
	local entries = {}

	for _, item in ipairs(items) do
		local display = string.format("%-12s  %s", item.name, item.filetypes)
		entries[#entries + 1] = display
		item_map[display] = item
		item_map[fzf.utils.strip_ansi_coloring(display)] = item
	end

	local LanguagePreviewer = builtin.base:extend()
	function LanguagePreviewer:new(o, preview_opts, fzf_win)
		LanguagePreviewer.super.new(self, o, preview_opts, fzf_win)
		setmetatable(self, LanguagePreviewer)
		return self
	end

	function LanguagePreviewer:populate_preview_buf(entry_str)
		local buf = self:get_tmp_buffer()
		local item = item_map[entry_str] or item_map[fzf.utils.strip_ansi_coloring(entry_str)]
		if item then
			local lines = preview_lines(item)
			vim.bo[buf].filetype = "markdown"
			local ok = pcall(vim.lsp.util.stylize_markdown, buf, lines, {})
			if not ok then
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			end
			self.win:update_preview_title(item.name)
		end
		self:set_preview_buf(buf)
	end

	local function select(selected)
		local item = selected and item_map[selected[1]]
		if not item and selected and selected[1] then
			item = item_map[fzf.utils.strip_ansi_coloring(selected[1])]
		end
		if not item then
			return
		end
		vim.cmd.edit(vim.fn.fnameescape(item.file))
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
	end

	fzf.fzf_exec(entries, {
		prompt = "Languages> ",
		previewer = {
			_ctor = function()
				return LanguagePreviewer
			end,
		},
		winopts = {
			preview = {
				hidden = false,
				layout = "horizontal",
			},
		},
		actions = { ["default"] = select },
	})
end

return M
