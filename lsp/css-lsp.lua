local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.completion = capabilities.textDocument.completion or {}
capabilities.textDocument.completion.completionItem = capabilities.textDocument.completion.completionItem or {}

capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("cssls", {
	capabilities = capabilities,
})

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = "vscode-css-language-server"
		local local_cmd = config.root_dir and config.root_dir .. "/node_modules/.bin/" .. cmd
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	root_markers = { "package.json", ".git" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}
