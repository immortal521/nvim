local icons = require("config.icons")

local function truncate_tail(str, max)
	if #str <= max then
		return str
	end
	return str:sub(1, max - 3) .. "..."
end

local has_branch = function()
	return vim.b.minigit_summary ~= nil
end

return {
	condition = has_branch,
	{
		provider = function()
			local summary = vim.b.minigit_summary or {}
			local head = summary.head_name or ""
			return " " .. icons.branch .. " " .. truncate_tail(head, 10) .. " "
		end,
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key], bg = self.palette.bg_highlight, bold = true }
		end,
	},
	-- Branch 结尾的右半圆
	{
		provider = "",
		hl = function(self)
			return { fg = self.palette.bg_highlight, bg = "NONE" }
		end,
	},
}
