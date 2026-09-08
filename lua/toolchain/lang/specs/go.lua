---@type LanguageSpec
return {
	filetypes = {
		"go",
	},
	formatters = { "goimports", "gofumpt" },
	linters = { "golangcilint" },
	lsp = { "gopls" },
	treesitter = { "go" },
}
