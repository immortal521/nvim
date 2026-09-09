return {
	{
		provider = "",
		hl = function(self)
			return { fg = self.palette.bg_highlight, bg = "NONE" }
		end,
	},
	{
		provider = "%P %(%l:%c%) ",
		hl = function(self)
			return { bg = self.palette.bg_highlight, fg = self.mode_colors[self.mode_key], bold = true }
		end,
	},
}
