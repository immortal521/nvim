---@type LazyPluginSpec
return {
	"saghen/blink.indent",
	--- @module 'blink.indent'
	--- @type blink.indent.Config
	-- enabled = false,
	event = "BufEdit",
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
