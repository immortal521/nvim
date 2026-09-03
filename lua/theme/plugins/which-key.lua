local M = {}

M.url = "https://github.com/folke/which-key.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local primary = palette.primary or palette.blue
	local border_fg = palette.border_highlight or palette.fg_gutter
	return {
		-- 弹窗背景与边框
		WhichKeyNormal = { fg = palette.fg, bg = float_bg },
		WhichKeyBorder = { fg = border_fg, bg = float_bg },
		WhichKeyTitle = { fg = primary, bg = float_bg, bold = true },

		-- 核心按键与分组
		WhichKey = { fg = palette.cyan or primary, bold = true },
		WhichKeyGroup = { fg = palette.blue or primary, bold = true },
		WhichKeyDesc = { fg = palette.purple or palette.fg },
		WhichKeySeparator = { fg = palette.comment or palette.fg_muted },
		WhichKeyValue = { fg = palette.fg_muted or palette.comment },

		-- 图标与边栏
		WhichKeyIcon = { fg = palette.green or palette.teal },
		WhichKeyIconAzure = { fg = palette.teal or palette.cyan },
		WhichKeyIconBlue = { fg = palette.blue },
		WhichKeyIconCyan = { fg = palette.cyan },
		WhichKeyIconGreen = { fg = palette.green },
		WhichKeyIconGrey = { fg = palette.fg_muted or palette.comment },
		WhichKeyIconOrange = { fg = palette.orange },
		WhichKeyIconPurple = { fg = palette.purple },
		WhichKeyIconRed = { fg = palette.red },
		WhichKeyIconYellow = { fg = palette.yellow },
	}
end

return M
