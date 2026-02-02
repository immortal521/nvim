---@type LazyPluginSpec
return {
	"hedyhli/outline.nvim",
	lazy = true,
	opts = {
		outline_window = {
			auto_jump = true,
			wrap = true,
		},
	},
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{
			"<leader>o",
			"<cmd>Outline<cr>",
			desc = "Toggle Outline",
		},
	},
}
