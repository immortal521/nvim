---@type LazyPluginSpec
return {
	"wakatime/vim-wakatime",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
}
