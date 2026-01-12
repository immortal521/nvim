---@type vim.lsp.Config
return {
	cmd = { "css-variables-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },

	-- Taken from lsp/ts_ls.lua to handle simple projects and monorepos.
	root_dir = function(bufnr, on_dir)
		local file_markers = {
			"package-lock.json",
			"yarn.lock",
			"pnpm-lock.yaml",
			"bun.lockb",
			"bun.lock",
		}

		local markers
		if vim.fn.has("nvim-0.11.3") == 1 then
			-- 0.11+：marker groups
			markers = { file_markers, { ".git" } }
		else
			-- 老版本：平铺列表
			markers = vim.list_extend(vim.deepcopy(file_markers), { ".git" })
		end

		local project_root = vim.fs.root(bufnr, markers) or vim.fn.getcwd()
		on_dir(project_root)
	end,

	-- Same as inlined defaults that don't seem to work without hardcoding them in the lua config
	-- https://github.com/vunguyentuan/vscode-css-variables/blob/763a564df763f17aceb5f3d6070e0b444a2f47ff/packages/css-variables-language-server/src/CSSVariableManager.ts#L31-L50
	settings = {
		cssVariables = {
			lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
			blacklistFolders = {
				"**/.cache",
				"**/.DS_Store",
				"**/.git",
				"**/.hg",
				"**/.next",
				"**/.svn",
				"**/bower_components",
				"**/CVS",
				"**/dist",
				"**/node_modules",
				"**/tests",
				"**/tmp",
			},
		},
	},
}
