---@type LangDefinition
return {
	filetypes = {
		"bash",
		"sh",
	},
	formatters = {
		"shfmt",
	},
	linters = {
		"shellcheck",
	},
	lsp = {
		"bash-language-server",
	},
	treesitter = {
		"bash",
	},
}
