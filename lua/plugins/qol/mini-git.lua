---@type LazyPluginSpec
return {
	"nvim-mini/mini-git",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	config = function()
		require("mini.git").setup({})
	end,
}
