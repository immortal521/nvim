return {
	{
		provider = "%P %(%l:%c%) ",
		hl = function(self)
			return { bg = self.palette.fg_gutter, fg = self.mode_colors[self.mode_key] }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = self.palette.fg_gutter }
		end,
	},
}
