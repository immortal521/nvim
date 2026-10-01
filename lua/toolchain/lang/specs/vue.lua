---@type LanguageSpec
return {
	filetypes = { "vue" },
	formatters = {
		"prettier",
		"biome",
		"oxfmt",
	},
	linters = {
		"eslint",
		"oxlint",
	},
	lsp = {
		"vue_ls",
		"vtsls",
		"stylelint-language-server",
		"tailwindcss",
		"biome",
		"oxfmt",
	},
	treesitter = {
		"vue",
		"css",
		"scss",
	},
}
