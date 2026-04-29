-- Move any selection in any direction
---@type LazyPluginSpec
return {
	"nvim-mini/mini.move",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {},
}
