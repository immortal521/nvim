---@type LazyPluginSpec
return {
	"stevearc/aerial.nvim",
	dependencies = { "neovim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
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
