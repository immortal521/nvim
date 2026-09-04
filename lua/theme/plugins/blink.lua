local M = {}

M.url = "https://github.com/Saghen/blink.cmp"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local float_bg = opts.transparent and "NONE" or (palette.bg_highlight or palette.bg_dim)
	local primary = palette.primary or palette.blue
	local primary_bright = palette.primary_bright or primary

	local ret = {
		BlinkCmpMenu = { fg = palette.fg, bg = float_bg },
		BlinkCmpMenuBorder = { fg = palette.border_highlight or palette.border, bg = float_bg },
		BlinkCmpMenuSelection = { fg = primary_bright, bg = palette.selection or palette.bg_highlight, bold = true },
		BlinkCmpLabel = { fg = palette.fg },
		BlinkCmpLabelMatch = { fg = primary_bright, bold = true },
		BlinkCmpLabelDeprecated = { fg = palette.fg_gutter, strikethrough = true },
		BlinkCmpLabelDetail = { fg = palette.fg_muted or palette.comment },
		BlinkCmpLabelDescription = { fg = palette.fg_muted or palette.comment },
		BlinkCmpDoc = { fg = palette.fg, bg = float_bg },
		BlinkCmpDocBorder = { fg = palette.border_highlight or palette.border, bg = float_bg },
		BlinkCmpDocSeparator = { fg = palette.fg_gutter, bg = float_bg },
		BlinkCmpDocCursorLine = { bg = palette.bg_highlight },
		BlinkCmpSignatureHelp = { fg = palette.fg, bg = float_bg },
		BlinkCmpSignatureHelpBorder = { fg = palette.border_highlight or palette.border, bg = float_bg },
		BlinkCmpSignatureHelpActiveParameter = { fg = primary_bright, bg = palette.bg_highlight, bold = true },
		BlinkCmpGhostText = { fg = palette.fg_gutter or palette.comment, italic = true },
		BlinkCmpScrollBarThumb = { bg = palette.fg_gutter },
		BlinkCmpScrollBarGutter = { bg = float_bg },
		BlinkCmpKindCodeium = { fg = palette.teal or palette.cyan },
		BlinkCmpKindCopilot = { fg = palette.teal or palette.cyan },
		BlinkCmpKindSupermaven = { fg = palette.teal or palette.cyan },
		BlinkCmpKindTabNine = { fg = palette.teal or palette.cyan },
		BlinkCmpKindDefault = { fg = palette.fg_muted or palette.comment },
	}

	if package.loaded["theme.kinds"] or pcall(require, "theme.kinds") then
		require("theme.kinds").kinds(ret, "BlinkCmpKind%s")
	end

	return ret
end

return M
