return {
	{
		provider = "",
		condition = function(self)
			return self.has_branch
		end,
	},
	hl = function(self)
		return { fg = self.palette.bg_highlight }
	end,
	{
		init = function(self)
			local filename = vim.fn.expand("%:t")
			local extension = vim.fn.fnamemodify(filename, ":e")
			local icon, hl, _ = require("mini.icons").get("file", "file." .. extension)
			if vim.bo.buftype == "terminal" then
				icon = ""
			end
			self.icon = icon
			local hl_val = vim.api.nvim_get_hl(0, { name = hl, link = false })
			self.icon_color = hl_val.fg and string.format("#%06x", hl_val.fg) or nil
			self.filename = filename
		end,
		{ provider = " " },
		{
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			condition = function(self)
				return self.filename ~= ""
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
			hl = function(self)
				return { italic = true, fg = self.palette.comment }
			end,
		},
	},
}
