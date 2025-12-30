local colors = Utils.colors()

return {
	{
		provider = function()
			return require("noice").api.status.command.get()
		end,
		hl = { fg = colors.fg_gutter },
	},
	{ provider = " " },
}
