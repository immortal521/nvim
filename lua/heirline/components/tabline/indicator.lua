local icons = require("config.icons")

return {
	static = {
		icon = icons.bufferline.indicator .. " ",
	},
	provider = function(self)
		return self.icon
	end,
	hl = function(self)
		if self.is_active then
			return { fg = self.palette.blue, bg = self.palette.bg, bold = true }
		else
			return { fg = self.palette.comment, bold = true }
		end
	end,
}
