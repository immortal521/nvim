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
			return { fg = self.colors.blue.fg, bg = self.colors.normal.bg, bold = true }
		else
			return { fg = self.colors.comment.fg, bold = true }
		end
	end,
}
