local common = require("heirline.components.common")
local colors = Utils.colors()

return {
	common.FileIcon,
	{
		provider = function(self)
			return self.filename
		end,
		hl = function(self)
			return {
				fg = self.has_errors and colors.error
					or self.has_warnings and colors.warning
					or self.is_active and colors.blue
					or colors.comment,
				bold = self.is_active,
				italic = true,
			}
		end,
	},
}
