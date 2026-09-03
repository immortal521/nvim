---@type vim.lsp.Config
return {
	cmd = {
		"luau-lsp",
		"lsp",
		"--definitions:@noctalia=noctalia.d.luau",
	},

	filetypes = { "luau" },

	root_markers = { ".git" },
}
