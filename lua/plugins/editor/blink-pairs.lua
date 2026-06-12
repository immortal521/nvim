---@type LazyPluginSpec
return {
	"saghen/blink.pairs",
	event = "BufEdit",
	version = "*",
	dependencies = "saghen/blink.lib",
	build = function()
		require("blink.pairs").download():pwait(60000)
	end,

	---@type blink.pairs.Config
	opts = {
		mappings = {
			enabled = true,
			cmdline = true,
			disabled_filetypes = {},
			pairs = {},
		},
		highlights = {
			enabled = true,
			cmdline = true,
			groups = {
				"BlinkPairsRed",
				"BlinkPairsYellow",
				"BlinkPairsBlue",
				"BlinkPairsOrange",
				"BlinkPairsGreen",
				"BlinkPairsPurple",
				"BlinkPairsCyan",
			},
			unmatched_group = "BlinkPairsUnmatched",

			matchparen = {
				enabled = true,
				cmdline = false,
				include_surrounding = false,
				group = "BlinkPairsMatchParen",
				priority = 250,
			},
		},
		debug = false,
	},
}
