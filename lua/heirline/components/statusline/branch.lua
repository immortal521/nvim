local icons = require("config.icons")

-- local function truncate_middle(str, max)
-- 	if #str <= max then
-- 		return str
-- 	end
--
-- 	local ellipsis = "..."
-- 	local keep = max - #ellipsis
-- 	local left = math.ceil(keep / 2)
-- 	local right = math.floor(keep / 2)
--
-- 	return str:sub(1, left) .. ellipsis .. str:sub(-right)
-- end

local function truncate_tail(str, max)
	if #str <= max then
		return str
	end
	return str:sub(1, max - 3) .. "..."
end

return {
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key].fg, bg = self.has_branch and self.colors.gutter.fg or nil }
		end,
	},
	{
		condition = function(self)
			return self.has_branch
		end,
		provider = function()
			local summary = vim.b.minigit_summary or {}
			local head = summary.head_name or ""
			return " " .. icons.branch .. " " .. truncate_tail(head, 10)
		end,
		hl = function(self)
			return { fg = self.mode_colors[self.mode_key].fg, bg = self.colors.gutter.bg, bold = true }
		end,
	},
}
