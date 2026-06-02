---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = "vscode-json-language-server"
		local local_cmd = config.root_dir and config.root_dir .. "/node_modules/.bin/" .. cmd
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = { "json", "jsonc" },
	init_options = {
		provideFormatter = true,
	},
	root_markers = { ".git" },
	settings = {
		json = {
			format = {
				enable = true,
			},
			validate = { enable = true },
		},
	},
}
