local root_markers = {
	".emmyrc.json",
	".emmyrc.lua",
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
}

---@type vim.lsp.config
return {
	cmd = { "emmylua_ls" },
	filetypes = { "lua" },
	root_markers = root_markers,
	settings = {
		codeLens = { enable = true },
		hint = { enable = true },
		lua = {
			runtime = {
				version = "luajit",
				extensions = { ".lua" },
				requirepattern = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				library = {
					"$vimruntime",
					vim.fn.stdpath("data") .. "/lazy/",
				},
			},
		},
	},
	workspace_required = false,
}
