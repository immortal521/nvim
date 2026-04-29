---@type zpack.Spec
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
				"TabLineFill",
			},
		}
		require("transparent").setup(opts)
	end,
}
