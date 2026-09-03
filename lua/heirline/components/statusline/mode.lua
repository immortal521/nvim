local has_branch = function()
	return vim.b.minigit_summary ~= nil
end

return {
	init = function(self)
		self.mode = vim.fn.mode(1)
		self.mode_key = self.mode:sub(1, 1)
	end,
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
	-- 左半圆分隔符
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = "NONE" }
		end,
	},
	-- Mode 文本
	{
		provider = function(self)
			return "%1(" .. self.mode_names[self.mode] .. "%)"
		end,
		hl = function(self)
			return { fg = self.palette.bg, bg = self.mode_colors[self.mode_key], bold = true }
		end,
	},
	-- 情况 A: 有 Branch 时，连接到 Branch 背景色
	{
		condition = has_branch,
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = self.palette.bg_highlight }
		end,
	},
	-- 情况 B: 无 Branch 时，直接收尾过渡到透明背景
	{
		condition = function()
			return not has_branch()
		end,
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = "NONE" }
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
