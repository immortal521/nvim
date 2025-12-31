local colors = Utils.colors()

return {
	{
		provider = "%P %(%l:%c%) ",
		hl = function(self)
			return { bg = colors.fg_gutter, fg = self.mode_colors[self.mode] }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode], bg = colors.fg_gutter }
		end,
	},
}
