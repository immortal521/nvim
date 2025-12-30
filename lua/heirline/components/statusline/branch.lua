local icons = require("config.icons")
local colors = Utils.colors()

return {
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode], bg = self.has_branch and colors.fg_gutter or nil }
		end,
	},
	{
		condition = function(self)
			return self.has_branch
		end,
		provider = function()
			local summary = vim.b.minigit_summary or {}
			return " " .. icons.branch .. (summary.head_name or "") .. " "
		end,
		hl = function(self)
			return { fg = self.mode_colors[self.mode], bg = colors.fg_gutter, bold = true }
		end,
	},
}
