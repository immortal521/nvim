---@type LanguageSpec
return {
	filetypes = { "markdown", "markdown.mdx" },
	formatters = { "prettier", "biome", "oxfmt" },
	lsp = { "tailwindcss", "oxfmt" },
	treesitter = { "markdown", "markdown_inline" },
}
