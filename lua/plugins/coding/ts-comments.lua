---@type LazyPluginSpec
return {
	"folke/ts-comments.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {},
}
