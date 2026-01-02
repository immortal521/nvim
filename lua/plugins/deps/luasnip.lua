---@type LazyPluginSpec
return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		delete_check_events = "TextChanged",
		update_events = { "TextChanged", "TextChangedI" },
		enable_autosnippets = true,
	},
}
