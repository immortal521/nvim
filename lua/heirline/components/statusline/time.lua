local colors = Utils.colors()

return {
	{
		provider = function()
			return " " .. os.date("%H:%M") .. " "
		end,
		hl = function(self)
			return { fg = colors.fg_gutter, bg = self.mode_colors[self.mode], bold = true, italic = true }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode] }
		end,
	},
}
