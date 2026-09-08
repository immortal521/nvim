---@type LangDefinition
return {
	filetypes = {
		"go",
	},
	formatters = { "goimports", "gofumpt" },
	linters = { "golangcilint" },
	lsp = { "gopls" },
	treesitter = { "go" },
}
