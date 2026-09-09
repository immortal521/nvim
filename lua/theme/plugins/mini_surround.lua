local M = {}

M.url = "https://github.com/echasnovski/mini.surround"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local primary = palette.primary or palette.blue

	return {
		MiniSurround = { fg = palette.bg, bg = primary, bold = true },
		MiniSurroundPrompt = { fg = primary, bold = true },
	}
end

return M
