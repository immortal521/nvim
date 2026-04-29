-- jump
---@type LazyPluginSpec
return {
	"nvim-mini/mini.jump",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {},
}
