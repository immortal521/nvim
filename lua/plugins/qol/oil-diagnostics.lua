---@type LazyPluginSpec
return {
	"JezerM/oil-lsp-diagnostics.nvim",
	dependencies = { "stevearc/oil.nvim" },
	ft = "oil",
	opts = {
		count = false,
		parent_dirs = true,
		diagnostic_colors = {
			error = "DiagnosticError",
			warn = "DiagnosticWarn",
			info = "DiagnosticInfo",
			hint = "DiagnosticHint",
		},
		diagnostic_symbols = { error = "", warn = "", info = "", hint = "󰌶" },
	},
}
