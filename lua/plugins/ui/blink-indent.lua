---@type LazyPluginSpec
return {
	"saghen/blink.indent",
	event = "BufEdit",
	--- @module 'blink.indent'
	--- @type blink.indent.Config
	opts = {
		static = {
			enabled = true,
			char = "│",
		},
		scope = {
			enabled = true,
			char = "│",
			highlights = {
				"BlinkIndentOrange",
				"BlinkIndentViolet",
				"BlinkIndentBlue",
				"BlinkIndentRed",
				"BlinkIndentCyan",
				"BlinkIndentYellow",
				"BlinkIndentGreen",
			},
		},
	},
}
