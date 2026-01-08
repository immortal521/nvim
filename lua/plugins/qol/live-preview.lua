---@type LazyPluginSpec
return {
	"brianhuster/live-preview.nvim",
	lazy = true,
	config = function()
		require("livepreview.config").set()
	end,
	keys = {
		{ "<leader>cps", "<cmd>LivePreview start<cr>", desc = "Live Preview Start" },
		{ "<leader>cpc", "<cmd>LivePreview close<cr>", desc = "Live Preview Stop" },
		{ "<leader>cpp", "<cmd>LivePreview pick<cr>", desc = "Live Preview Select" },
	},
}
