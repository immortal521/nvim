-- Statusline, Winbar and Tabline
---@type LazyPluginSpec
return {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	opts = function()
    vim.o.laststatus = 3
		local tabline = require("heirline.layouts.tabline")
		local statusline = require("heirline.layouts.statusline")

		return {
			statusline = statusline,
			tabline = tabline,
		}
	end,
}
