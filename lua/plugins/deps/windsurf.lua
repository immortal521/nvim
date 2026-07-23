-- windsurf
---@type LazyPluginSpec
return {
	"immortal521/windsurf.nvim",
	event = "InsertEnter",
	enabled = false,
	config = function()
		local opts = {
			enable_cmp_source = false,
		}
		require("codeium").setup(opts)
	end,
}
