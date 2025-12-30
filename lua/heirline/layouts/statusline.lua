local common = require("heirline.components.common")
local statusline = require("heirline.components.statusline")
local colors = Utils.colors()

local has_branch = function()
	return vim.b.minigit_summary ~= nil
end

return {
	static = {
		mode_colors = {
			n = colors.blue,
			i = colors.green,
			v = colors.magenta,
			V = colors.magenta,
			["\22"] = colors.magenta,
			c = colors.red,
			s = colors.yellow,
			S = colors.yellow,
			["\19"] = colors.yellow,
			R = colors.teal,
			r = colors.teal,
			["!"] = colors.red,
			t = colors.green,
		},
	},
	init = function(self)
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
