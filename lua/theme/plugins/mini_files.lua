local M = {}

M.url = "https://github.com/echasnovski/mini.files"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local float_fg = palette.float and palette.float.fg or palette.fg
	local primary = palette.primary or palette.blue
	local border_fg = palette.border or palette.fg_gutter
	local border_active = palette.border_highlight or primary

	return {
		-- 级联窗口背景与基本文本
		MiniFilesNormal = { fg = float_fg, bg = float_bg },
		MiniFilesDirectory = { fg = primary, bold = true },
		MiniFilesFile = { fg = float_fg },
		MiniFilesCursorLine = { bg = palette.bg_highlight, bold = true },

		MiniFilesBorder = { fg = border_fg, bg = float_bg },
		MiniFilesBorderModified = { fg = palette.yellow or palette.orange, bg = float_bg },
		MiniFilesTitle = { fg = palette.fg_muted or palette.comment, bg = float_bg },
		MiniFilesTitleFocused = { fg = border_active, bg = float_bg, bold = true },

		MiniFilesTitlePrefix = { fg = primary, bg = float_bg, bold = true },
	}
end

return M
