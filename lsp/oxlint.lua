---@brief oxlint LSP config (correct + luaLS-safe)

local function oxlint_conf_mentions_typescript(root_dir)
	local fn = vim.fs.joinpath(root_dir, ".oxlintrc.json")

	local ok, lines = pcall(io.lines, fn)
	if not ok or not lines then
		return false
	end

	for line in lines do
		if line:find("typescript") then
			return true
		end
	end

	return false
end

local function resolve_cmd(root_dir)
	local local_cmd = root_dir and vim.fs.joinpath(root_dir, "node_modules", ".bin", "oxlint")

	if local_cmd and vim.fn.executable(local_cmd) == 1 then
		return { local_cmd, "--lsp" }
	end

	return { "oxlint", "--lsp" }
end

---@type vim.lsp.Config
return {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},

	root_markers = { ".oxlintrc.json", "oxlint.config.ts" },
	workspace_required = true,

	cmd = function(dispatchers, config)
		local cmd = resolve_cmd(config.root_dir)

		return vim.lsp.rpc.start(cmd, dispatchers)
	end,

	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
			client:exec_cmd({
				title = "Apply Oxlint automatic fixes",
				command = "oxc.fixAll",
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			})
		end, {})
	end,

	settings = {
		typeAware = false,
	},

	before_init = function(_, config)
		local settings = config.settings or {}

		if settings.typeAware == nil and vim.fn.executable("tsgolint") == 1 then
			local ok, res = pcall(oxlint_conf_mentions_typescript, config.root_dir)
			if ok and res then
				settings.typeAware = true
			end
		end

		config.settings = settings
	end,
}
