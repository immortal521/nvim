local colors = Utils.colors()

return {
	{
		provider = "",
		condition = function(self)
			return self.has_branch
		end,
		hl = { fg = colors.fg_gutter },
	},
	{
		init = function(self)
			local filename = vim.fn.expand("%:t")
			local extension = vim.fn.fnamemodify(filename, ":e")
			local icon, hl, _ = require("mini.icons").get("file", "file." .. extension)
			if vim.bo.buftype == "terminal" then
				icon = ""
			end
			self.icon = icon
			self.icon_color = string.format("#%06x", vim.api.nvim_get_hl(0, { name = hl })["fg"])
			self.filename = filename
		end,
		{ provider = " " },
		{
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return {
					fg = self.icon_color,
				}
			end,
		},
		{
			provider = function(self)
				return self.filename
			end,
			hl = { italic = true },
		},
	},
}
