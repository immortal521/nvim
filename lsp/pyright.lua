---@brief pyright LSP config

local function set_python_path(command)
	local path = command.args

	local clients = vim.lsp.get_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pyright",
	})

	for _, client in ipairs(clients) do
		local cfg = client.config.settings or {}

		cfg = vim.tbl_deep_extend("force", cfg, {
			python = {
				pythonPath = path,
			},
		})

		client.config.settings = cfg

		client:notify("workspace/didChangeConfiguration", {
			settings = cfg,
		})
	end
end

---@type vim.lsp.Config
return {
	cmd = { "pyright-langserver", "--stdio" },

	filetypes = { "python" },

	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},

	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},

	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
			client:request("workspace/executeCommand", {
				command = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			}, nil, bufnr)
		end, {
			desc = "Organize Imports",
		})

		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
			desc = "Set Python Path",
			nargs = 1,
			complete = "file",
		})
	end,
}
