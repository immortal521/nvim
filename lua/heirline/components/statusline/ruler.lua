return {
	{
		provider = "%P %(%l:%c%) ",
		hl = function(self)
			return { bg = self.colors.gutter.bg, fg = self.mode_colors[self.mode_key].fg }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key].fg, bg = self.colors.gutter.bg }
		end,
	},
}
