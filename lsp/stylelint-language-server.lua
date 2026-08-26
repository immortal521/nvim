---@brief
---
--- https://github.com/stylelint/vscode-stylelint/tree/main/packages/language-server
---
--- `stylelint-language-server` can be installed via npm `npm install -g @stylelint/language-server`.
--- ```

local stylelint_config_files = {
	".stylelintrc",
	".stylelintrc.mjs",
	".stylelintrc.cjs",
	".stylelintrc.js",
	".stylelintrc.json",
	".stylelintrc.yaml",
	".stylelintrc.yml",
	"stylelint.config.mjs",
	"stylelint.config.cjs",
	"stylelint.config.js",
}

local root_markers = {
	"package-lock.json",
	"yarn.lock",
	"pnpm-lock.yaml",
	"bun.lockb",
	"bun.lock",
	".git",
}

---@type vim.lsp.Config
return {
	cmd = { "stylelint-language-server", "--stdio" },

	filetypes = {
		"astro",
		"css",
		"html",
		"less",
		"scss",
		"vue",
	},

	root_dir = function(bufnr, on_dir)
		if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
			return
		end

		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		local filename = vim.api.nvim_buf_get_name(bufnr)

		local config_files = Utils.lsp.insert_package_json(stylelint_config_files, "stylelintConfig", filename)

		local found = vim.fs.find(config_files, {
			path = filename,
			type = "file",
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]

		if not found then
			return
		end

		on_dir(project_root)
	end,

	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspStylelintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "stylelint.applyAutoFix",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = vim.lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, {})
	end,

	settings = {
		stylelint = {
			validate = {
				"css",
				"scss",
				"less",
				"postcss",
				"vue",
			},
			snippet = {
				"css",
				"scss",
				"less",
				"postcss",
				"vue",
			},
		},
	},
}
