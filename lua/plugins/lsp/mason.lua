---@type LazyPluginSpec[]
return {
	-- Mason
	{
		"mason-org/mason.nvim",
		cmd = "Mason",

		---@type MasonSettings
		opts = {
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
		},
		config = function(_, opts)
			require("mason").setup(opts)

			-- vim.defer_fn(function()
			-- 	local packages = require("helpers.toolchain").get_mason_packages()
			-- 	require("helpers.mason").ensure_packages_installed(packages)
			-- end, 100)
		end,
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
	},

	-- Mason-lspconfig
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		event = "VeryLazy",

		---@type MasonLspconfigSettings
		opts = {
			automatic_enable = false,
		},
		config = function(self, opts)
			local mr = require("mason-registry")
			local ensure_installed = {
				"bacon-ls",
				"bash-language-server",
				"biome",
				"clang-format",
				"clangd",
				"codelldb",
				"codespell",
				"css-lsp",
				"css-variables-language-server",
				"cssmodules-language-server",
				"delve",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"gomodifytags",
				"google-java-format",
				"gopls",
				"html-lsp",
				"impl",
				"java-debug-adapter",
				"java-test",
				"jdtls",
				"js-debug-adapter",
				"json-lsp",
				"kotlin-language-server",
				"ktlint",
				"lua-language-server",
				"prettier",
				"pyright",
				"ruff",
				"rust-analyzer",
				"rustfmt",
				"shellcheck",
				"sqlfluff",
				"stylua",
				"stylelint-lsp",
				"tailwindcss-language-server",
				"tree-sitter-cli",
				"vtsls",
				"vue-language-server",
				"xmlformatter",
				"yaml-language-server",
			}
			mr.refresh(function()
				for _, tool in ipairs(ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
}
