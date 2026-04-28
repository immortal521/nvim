local common = require("heirline.components.common")

return {
	common.FileIcon,
	{
		provider = function(self)
			return self.filename
		end,
		hl = function(self)
			return {
				fg = self.has_errors and self.colors.error.fg
					or self.has_warnings and self.colors.yellow.fg
					or self.is_active and self.colors.blue.fg
					or self.colors.comment.fg,
				bold = self.is_active,
				italic = true,
			}
		end,
	},
}
