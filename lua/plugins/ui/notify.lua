vim.api.nvim_set_hl(0, "NotifyBackground", {
	bg = "NONE",
})
---@type LazyPluginSpec
return {
	"rcarriga/nvim-notify",
	---@type notify.Config
	opts = {
		max_width = 50,
		background_colour = "#000000",
		stages = "slide",
		timeout = 1500,
	},
}
