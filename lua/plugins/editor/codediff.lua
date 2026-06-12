---@type LazyPluginSpec
return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	opts = {},
	keys = {
		{ "<leader>cD", "<cmd>CodeDiff<cr>", desc = "Code Diff" },
	},
}
