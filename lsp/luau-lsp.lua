---@type vim.lsp.Config
return {
	cmd = { "luau-lsp", "lsp" },

	filetypes = {
		"luau",
	},

	root_markers = {
		".git",
	},

	settings = {
		["luau-lsp"] = {
			platform = {
				type = "standard",
			},

			sourcemap = {
				enabled = false,
			},

			types = {
				definitionFiles = {
					noctalia = vim.fn.expand("~/Projects/external/mirror/official-plugins/noctalia.d.luau"),
				},
			},

			ignoreGlobs = {
				"**/*.d.luau",
			},
		},
	},
}
