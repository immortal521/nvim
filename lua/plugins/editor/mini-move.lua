-- Move any selection in any direction
---@type zpack.Spec
return {
	"nvim-mini/mini.move",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {},
}
