local M = {}

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local border_fg = palette.border_highlight or palette.border or palette.fg_gutter
	return {
		ActiveBorder = { fg = border_fg, bg = float_bg },
		ExtraBlue = { fg = palette.blue },
		ExtraBlueBg = { bg = palette.blue },

		ExtraCyan = { fg = palette.cyan },
		ExtraCyanBg = { bg = palette.cyan },

		ExtraGreen = { fg = palette.green },
		ExtraGreenBg = { bg = palette.green },

		ExtraYellow = { fg = palette.yellow },
		ExtraYellowBg = { bg = palette.yellow },

		ExtraOrange = { fg = palette.orange },
		ExtraOrangeBg = { bg = palette.orange },

		ExtraRed = { fg = palette.red },
		ExtraRedBg = { bg = palette.red },

		ExtraPurple = { fg = palette.purple },
		ExtraPurpleBg = { bg = palette.purple },

		ExtraPink = { fg = palette.pink },
		ExtraPinkBg = { bg = palette.pink },
	}
end

return M
