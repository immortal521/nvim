local icons = require("config.icons")
local colors = Utils.colors()

return {
	static = {
		icon = icons.bufferline.indicator .. " ",
	},
	provider = function(self)
		return self.icon
	end,
	hl = function(self)
		if self.is_active then
			return { fg = colors.blue, bg = colors.bg, bold = true }
		else
			return { fg = colors.comment, bold = true }
		end
	end,
}
