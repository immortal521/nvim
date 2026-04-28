return {
	{
		provider = function()
			return " " .. os.date("%H:%M") .. " "
		end,
		hl = function(self)
			return { fg = self.colors.gutter.fg, bg = self.mode_colors[self.mode_key].bg, bold = true, italic = true }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key].fg }
		end,
	},
}
