-- Rainbow Brackets
---@type LazyPluginSpec
return {
	"HiPhish/rainbow-delimiters.nvim",
	event = "BufEdit",
  enabled = false,
	main = "rainbow-delimiters.setup",

	---@type rainbow_delimiters.config
	opts = {
		strategy = {
			[""] = "rainbow-delimiters.strategy.global",
			vim = "rainbow-delimiters.strategy.local",
		},
		query = {
			[""] = "rainbow-delimiters",
			lua = "rainbow-blocks",
		},
		priority = {
			[""] = 110,
			lua = 210,
		},
		highlight = {
			"RainbowDelimiterYellow",
			"RainbowDelimiterBlue",
			"RainbowDelimiterOrange",
			"RainbowDelimiterGreen",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
		},
	},
}
