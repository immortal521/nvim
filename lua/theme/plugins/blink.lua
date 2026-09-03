local M = {}

M.url = "https://github.com/Saghen/blink.cmp"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	-- stylua: ignore
	local ret = {
		BlinkCmpDoc                 = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.bg_highlight },
		BlinkCmpDocBorder           = { fg = palette.fg_gutter,  bg =opts.transparent and "NONE" or palette.bg_highlight },
		BlinkCmpGhostText           = { fg = palette.terminal_black },
		BlinkCmpKindCodeium         = { fg = palette.cyan },
		BlinkCmpKindCopilot         = { fg = palette.cyan },
		BlinkCmpKindDefault         = { fg = palette.fg_muted },
		BlinkCmpKindSupermaven      = { fg = palette.cyan },
		BlinkCmpKindTabNine         = { fg = palette.cyan },
		BlinkCmpLabel               = { fg = palette.fg },
		BlinkCmpLabelDeprecated     = { fg = palette.fg_gutter, strikethrough = true },
		BlinkCmpLabelMatch          = { fg = palette.blue_bright },
		BlinkCmpMenu                = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.bg_highlight },
		BlinkCmpMenuBorder          = { fg = palette.fg_gutter, bg = opts.transparent and "NONE" or palette.bg_highlight },
		BlinkCmpSignatureHelp       = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.bg_highlight },
		BlinkCmpSignatureHelpBorder = { fg = palette.fg_gutter, bg = opts.transparent and "NONE" or palette.bg_highlight },
	}

	require("theme.kinds").kinds(ret, "BlinkCmpKind%s")

	return ret
end

return M
