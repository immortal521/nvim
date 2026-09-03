local icons = require("config.icons")

return {
	static = {
		icon = (icons.bufferline and icons.bufferline.indicator or "▎") .. " ",
	},
	provider = function(self)
		return self.icon
	end,
	hl = function(self)
		if self.is_active then
			return { fg = self.palette.primary, bg = self.palette.bg, bold = true }
		else
			return { fg = self.palette.comment, bg = self.palette.bg_dim, bold = false }
		end
	end,
}
