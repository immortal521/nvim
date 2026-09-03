return {
	init = function(self)
		self.enc = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
		self.bomb = vim.bo.bomb and "[BOM]" or ""
	end,
	{
		condition = function(self)
			return self.enc:upper() ~= "UTF-8"
		end,
		provider = function(self)
			return " " .. self.enc:upper() .. self.bomb .. " "
		end,
		hl = function(self)
			return { fg = self.palette.fg_gutter }
		end,
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.palette.fg_gutter }
		end,
	},
}
