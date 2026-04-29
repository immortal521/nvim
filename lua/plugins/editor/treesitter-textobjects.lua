---@type zpack.Spec
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	dependencies = { "neovim-treesitter/nvim-treesitter" },
	opts = {},
}
