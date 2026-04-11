---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = "BufEdit",
	dependencies = { "neovim-treesitter/nvim-treesitter" },
	opts = {},
}
