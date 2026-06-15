---@type LazyPluginSpec
return {
	"nvim-mini/mini.hues",
	version = false,
	enabled = false,
	opts = {
		background = "#1a1b26",
		foreground = "#c0caf5",
		saturation = "mediumhigh",
		plugins = {
			default = false,
			["nvim-mini/mini.nvim"] = true,
		},
	},
}
