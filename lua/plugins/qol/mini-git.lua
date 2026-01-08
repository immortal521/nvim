---@type LazyPluginSpec
return {
	"nvim-mini/mini-git",
	event = "BufEdit",
	config = function()
		require("mini.git").setup({})
	end,
}
