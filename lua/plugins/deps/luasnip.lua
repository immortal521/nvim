---@type LazyPluginSpec
return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	sem_version = "v2.*",
	opts = {
		history = true,
		delete_check_events = "TextChanged",
		update_events = { "TextChanged", "TextChangedI" },
		enable_autosnippets = true,
	},
}
