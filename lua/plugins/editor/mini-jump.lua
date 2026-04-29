-- jump
---@type zpack.Spec
return {
	"nvim-mini/mini.jump",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {},
}
