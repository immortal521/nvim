---@type LanguageSpec
return {
	filetypes = { "typescript", "typescriptreact" },
	formatters = { "prettier", "biome", "oxfmt" },
	linters = { "eslint", "oxlint" },
	lint_filetypes = { "typescript" },
	lsp = { "vtsls", "biome", "oxlint", "oxfmt" },
	treesitter = { "typescript", "tsx" },
}
