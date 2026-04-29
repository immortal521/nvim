---@type LazyPluginSpec
return {
	"nvim-mini/mini.splitjoin",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {},
}
