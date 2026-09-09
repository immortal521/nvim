local M = {}

M.url = "https://github.com/folke/flash.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local primary = palette.primary or palette.blue
	local label_bg = palette.pink or palette.red

	return {
		FlashBackdrop = { fg = palette.fg_gutter or palette.comment },
		FlashLabel = { fg = palette.bg, bg = label_bg, bold = true },
		FlashMatch = { fg = palette.fg, bg = palette.bg_highlight },
		FlashCurrent = { fg = palette.bg, bg = primary, bold = true },
		FlashPrompt = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.bg_dim },
		FlashPromptIcon = { fg = primary, bold = true },
	}
end

return M
