return {
	{
		provider = function()
			return require("noice").api.status.command.get()
		end,
		hl = function(self)
			return { fg = self.palette.pink }
		end,
	},
	{ provider = " " },
}
