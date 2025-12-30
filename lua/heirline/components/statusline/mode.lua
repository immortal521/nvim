local colors = Utils.colors()

return {
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode] }
		end,
	},
	{
		static = {
			mode_names = {
				n = "NORMAL",
				no = "O-PENDING",
				nov = "O-PENDING",
				noV = "O-PENDING",
				["no\22"] = "O-PENDING",
				niI = "NORMAL",
				niR = "NORMAL",
				niV = "NORMAL",
				nt = "NORMAL",
				v = "VISUAL",
				vs = "VISUAL",
				V = "V-LINE",
				Vs = "V-LINE",
				["\22"] = "V-BLOCK",
				["\22s"] = "V-BLOCK",
				s = "SELECT",
				S = "S-LINE",
				["\19"] = "S-BLOCK",
				i = "INSERT",
				ic = "INSERT",
				ix = "INSERT",
				R = "REPLACE",
				Rc = "REPLACE",
				Rx = "REPLACE",
				Rv = "V-REPLACE",
				Rvc = "V-REPLACE",
				Rvx = "V-REPLACE",
				c = "COMMAND",
				cv = "EX",
				ce = "EX",
				r = "REPLACE",
				rm = "MORE",
				["r?"] = "CONFIRM",
				["!"] = "SHELL",
				t = "TERMINAL",
			},
		},
		provider = function(self)
			return "%1(" .. self.mode_names[self.mode] .. "%)"
		end,
		hl = function(self)
			return { fg = colors.fg_gutter, bg = self.mode_colors[self.mode_key], bold = true }
		end,
	},

	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}
