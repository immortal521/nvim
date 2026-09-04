local M = {}

M.url = "https://github.com/goolord/alpha-nvim"

---@param palette theme.Palette
---@param _ theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, _)
	return {
		AlphaHeader = { fg = palette.primary or palette.blue, bold = true },
		AlphaHeaderLabel = { fg = palette.peach or palette.orange },
		AlphaButtons = { fg = palette.fg },
		AlphaShortcut = { fg = palette.primary or palette.blue, bold = true },
		AlphaButton = { fg = palette.fg },
		AlphaFooter = { fg = palette.fg_muted or palette.comment, italic = true },
	}
end

return M
