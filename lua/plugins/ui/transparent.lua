---@type LazyPluginSpec
return {
	"xiyaowong/transparent.nvim",
	enabled = false,
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
				"NotifyWARNBorder",
				"NotifyINFOBorder",
				"NotifyERRORBorder",
				"NotifyDEBUGBorder",
				"NotifyTRACEBorder",
				"NotifyWARNBody",
				"NotifyINFOBody",
				"NotifyERRORBody",
				"NotifyDEBUGBody",
				"NotifyTRACEBody",
			},
			exclude_groups = {
				-- "CursorLine",
			},
		}
		require("transparent").setup(opts)
	end,
}
