---@type vim.lsp.Config
return {
	cmd = { "emmylua_ls" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".emmyrc.json",
		".luacheckrc",
		".git",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				extensions = { ".lua" },
				requirePattern = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				library = {
					"$VIMRUNTIME",
					vim.fn.stdpath("data") .. "/lazy/",
				},
			},
		},
	},
	workspace_required = false,
}
