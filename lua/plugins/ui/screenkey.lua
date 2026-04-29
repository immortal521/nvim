---@type LazyPluginSpec
return {
	"NStefan002/screenkey.nvim",
	lazy = true,
  sem_version = "*",
	opts = {
		win_opts = {
			relative = "editor",
			row = vim.o.lines - 1,
			col = vim.o.columns - 32,
			height = 3,
			width = 20,
			border = "rounded",
			title = "",
		},
	},
	keys = {
		{ "<leader>uk", "<cmd>lua require('screenkey').toggle()<cr>", desc = "Toggle Screenkey" },
	},
}
