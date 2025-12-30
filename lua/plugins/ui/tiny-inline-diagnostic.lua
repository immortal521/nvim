-- Inline diagnostic messages
---@type LazyPluginSpec
return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	opts = {
		disabled_ft = { "lazy" },
		options = {
			throttle = 20,
			show_source = {
				enabled = true,
			},
		},
	},
}
