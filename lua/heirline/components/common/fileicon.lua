return {
	init = function(self)
		self.icon, self.icon_hl = require("mini.icons").get("file", self.filepath)
		local bt = vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) or nil
		if bt and bt == "terminal" then
			self.icon = ""
		end
		self.icon = self.icon
		local hl = vim.api.nvim_get_hl(0, { name = self.icon_hl, link = false })
		self.icon_color = hl.fg and string.format("#%06x", hl.fg) or nil
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}
