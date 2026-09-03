local common = require("heirline.components.common")

return {
	common.FileIcon,
	{
		provider = function(self)
			return self.filename
		end,
		hl = function(self)
			return {
				fg = self.has_errors and self.palette.error
					or self.has_warnings and self.palette.yellow
					or self.is_active and self.palette.blue
					or self.palette.comment,
				bold = self.is_active,
				italic = true,
			}
		end,
	},
}
