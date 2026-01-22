---@type LazyPluginSpec
return {
	"stevearc/aerial.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "mini-nvim/mini.icons" },
	lazy = true,
	opts = {
		autojump = true,
	},
	keys = {
		{
			"<leader>cs",
			"<cmd>AerialToggle<cr>",
			desc = "Aerial Toggle",
		},
	},
}
