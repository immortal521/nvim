local M = {}

M.url = "https://github.com/echasnovski/mini.surround"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local primary = palette.primary or palette.blue

	return {
		-- 配对符号选区/高亮
		MiniSurround = { fg = palette.bg, bg = primary, bold = true },
		-- 交互式输入配对符号时的提示文本
		MiniSurroundPrompt = { fg = primary, bold = true },
	}
end

return M
