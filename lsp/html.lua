---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = "vscode-html-language-server"
		local local_cmd = config.root_dir and config.root_dir .. "/node_modules/.bin/" .. cmd
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
	settings = {},
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
}
