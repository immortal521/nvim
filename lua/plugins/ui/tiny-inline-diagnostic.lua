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
	config = function(_, opts)
		vim.diagnostic.config({ virtual_text = false })
		require("tiny-inline-diagnostic").setup(opts)
	end,
}
