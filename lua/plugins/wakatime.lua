---@type LazyPluginSpec
return {
	"wakatime/vim-wakatime",
	event = "BufEdit",
	build = function()
		vim.cmd([[WakaTimeApiKey]])
	end,
}
