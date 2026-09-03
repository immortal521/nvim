return {
	condition = function()
		return package.loaded["noice"] and require("noice").api.status.command.has()
	end,
	{
		provider = function()
			return require("noice").api.status.command.get()
		end,
		hl = function(self)
			return { fg = self.palette.primary_bright or self.palette.pink }
		end,
	},
	{ provider = " " },
}
