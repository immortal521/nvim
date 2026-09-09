return {
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = self.palette.bg_highlight }
		end,
	},
	{
		provider = function()
			return " " .. os.date("%H:%M") .. " "
		end,
		hl = function(self)
			return { fg = self.palette.bg, bg = self.mode_colors[self.mode_key], bold = true }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = "NONE" }
		end,
	},
}
