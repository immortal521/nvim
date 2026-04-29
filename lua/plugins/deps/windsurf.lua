-- windsurf
---@type zpack.Spec
return {
	"immortal521/windsurf.nvim",
	event = "InsertEnter",
	config = function()
		local opts = {
			enable_cmp_source = false,
		}
		require("codeium").setup(opts)
	end,
}
