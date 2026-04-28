local common = require("heirline.components.common")
local statusline = require("heirline.components.statusline")

local has_branch = function()
	return vim.b.minigit_summary ~= nil
end

return {
	init = function(self)
		self.colors = Utils.color.get_colors()
		self.mode_colors = {
			n = self.colors.blue,
			i = self.colors.green,
			v = self.colors.magenta,
			V = self.colors.magenta,
			["\22"] = self.colors.magenta,
			c = self.colors.red,
			s = self.colors.yellow,
			S = self.colors.yellow,
			["\19"] = self.colors.yellow,
			R = self.colors.teal,
			r = self.colors.teal,
			["!"] = self.colors.red,
			t = self.colors.green,
		}
		-- Mode
		self.mode = vim.fn.mode(1)
		self.mode_key = self.mode:sub(1, 1)

		-- File
		self.filepath = vim.api.nvim_buf_get_name(0)
		self.line = vim.fn.line(".")
		self.charcol = vim.fn.charcol(".")
		self.total = vim.fn.line("$")
		self.has_branch = has_branch()
	end,
	statusline.Mode,
	statusline.Branch,
	statusline.Filename,
	common.Align,
	statusline.MacroRecording,
	common.Align,
	statusline.Profile,
	statusline.Encoding,
	statusline.Ruler,
	statusline.Time,
}
