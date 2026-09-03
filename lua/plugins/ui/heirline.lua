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
	config = function(_, opts)
		require("heirline").setup(opts)

		-- vim.api.nvim_create_autocmd("ColorScheme", {
		-- 	callback = function()
		-- 		vim.schedule(function()
		-- 			require("heirline.utils").on_colorscheme()
		-- 		end)
		-- 	end,
		-- })
	end,
}
