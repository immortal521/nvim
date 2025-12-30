---@type LazyPluginSpec
return {
	"xiyaowong/transparent.nvim",
	cond = not vim.g.neovide,
	event = "VimEnter",
	config = function()
		local opts = {
			extra_groups = {
				"LspInlayHint",
				"TinyInlineDiagnosticVirtualTextArrow",
				"TinyInlineInvDiagnosticVirtualTextHint",
				"TinyInlineInvDiagnosticVirtualTextInfo",
				"TinyInlineInvDiagnosticVirtualTextWarn",
				"TinyInlineInvDiagnosticVirtualTextError",
			},
		}
		require("transparent").setup(opts)
		vim.cmd([[TransparentEnable]])
	end,
}
