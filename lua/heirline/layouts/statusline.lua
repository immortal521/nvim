local common = require("heirline.components.common")
local statusline = require("heirline.components.statusline")

local has_branch = function()
	return vim.b.minigit_summary ~= nil
end

return {
	init = function(self)
		self.palette = require("theme").get_palette()
		self.colors = Utils.color.get_colors()
		self.mode_colors = {
			n = self.palette.blue,
			i = self.palette.green,
			v = self.palette.pink,
			V = self.palette.pink,
			["\22"] = self.palette.pink,
			c = self.palette.red,
			s = self.palette.yellow,
			S = self.palette.yellow,
			["\19"] = self.palette.yellow,
			R = self.palette.purple,
			r = self.palette.purple,
			["!"] = self.palette.red,
			t = self.palette.green,
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
