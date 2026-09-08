---@type LanguageSpec
return {
	filetypes = { "json", "jsonc" },
	formatters = { "prettier", "biome", "oxfmt" },
	lsp = { "jsonls", "biome", "oxfmt" },
	treesitter = { "json" },
}
