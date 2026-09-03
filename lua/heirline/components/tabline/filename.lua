local common = require("heirline.components.common")

return {
	common.FileIcon,
	{
		provider = function(self)
			return self.filename
		end,
		hl = function(self)
			local diag = self.palette.diag or {}
			return {
				fg = self.has_errors and (diag.error or self.palette.red)
					or self.has_warnings and (diag.warn or self.palette.yellow)
					or self.is_active and self.palette.primary
					or self.palette.comment,
				bold = self.is_active,
				italic = true,
			}
		end,
	},
}
