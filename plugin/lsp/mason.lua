local tools = {
	"bash-language-server",
	"clangd",
	"css-lsp",
	"css-variables-language-server",
	"cssmodules-language-server",
	"emmet-language-server",
	"emmylua_ls",
	"gopls",
	"html-lsp",
	"jdtls",
	"json-lsp",
	"kotlin-language-server",
	"pyright",
	"rnix-lsp",
	"rust-analyzer",
	"tailwindcss-language-server",
	"vtsls",
	"vue-language-server",
	"yaml-language-server",
	"golangci-lint",
	"ktlint",
	"oxlint",
	"ruff",
	"shellcheck",
	"sqlfluff",
	"stylelint-language-server",
	"codespell",
	"biome",
	"clang-format",
	"gofumpt",
	"goimports",
	"google-java-format",
	"oxfmt",
	"prettier",
	"shfmt",
	"stylua",
	"tombi",
	"xmlformatter",
	"codelldb",
	"delve",
	"java-debug-adapter",
	"js-debug-adapter",
	"bacon-ls",
	"gomodifytags",
	"impl",
	"java-test",
	"tree-sitter-cli",
}
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/mason-org/mason-lspconfig.nvim",
	}, {
		confirm = false,
	})
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		keymaps = {
			toggle_package_expand = "l",
			toggle_package_install_log = "l",
		},
	})
	require("mason-lspconfig").setup({
		automatic_enable = false,
	})

	local registry = require("mason-registry")
	registry.refresh(function()
		for _, name in ipairs(tools) do
			local package = registry.get_package(name)
			if not package:is_installed() then
				package:install()
			end
		end
	end)
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.schedule(load)
	end,
})

vim.keymap.set("n", "<leader>cm", function()
	load()
	vim.cmd("Mason")
end, {
	desc = "Mason",
})

vim.api.nvim_create_autocmd("CmdUndefined", { pattern = "Mason", once = true, callback = load })
