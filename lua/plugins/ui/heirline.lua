-- Statusline, Winbar and Tabline
---@type LazyPluginSpec
return {
	"rebelot/heirline.nvim",
	event = "UIEnter",
	opts = function()
		local tabline = require("heirline.layouts.tabline")
		local statusline = require("heirline.layouts.statusline")

		return {
			statusline = statusline,
			tabline = tabline,
		}
	end,
}
