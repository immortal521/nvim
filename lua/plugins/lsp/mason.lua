local ensure_install = {

	-- ==================== LSP ====================
	-- 语言服务（补全 / 跳转 / 诊断）
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
	"rust-analyzer",
	"tailwindcss-language-server",
	"vtsls",
	"vue-language-server",
	"yaml-language-server",

	-- ==================== LINT ====================
	-- 静态检查 / 代码规范
	"golangci-lint",
	"ktlint",
	"oxlint",
	"ruff",
	"shellcheck",
	"sqlfluff",
	"stylelint-lsp", -- LSP形式的lint
	"codespell",

	-- ==================== FORMATTER ====================
	-- 代码格式化
	"biome",
	"clang-format",
	"gofumpt",
	"goimports",
	"google-java-format",
	"oxfmt",
	"prettier",
	"rustfmt",
	"shfmt",
	"stylua",
	"taplo",
	"xmlformatter",

	-- ==================== DEBUG ====================
	-- 调试工具 / Debug Adapter
	"codelldb",
	"delve",
	"java-debug-adapter",
	"js-debug-adapter",

	-- ==================== 其他工具 ====================
	-- 非纯 LSP/Lint/Formatter/Debug
	"bacon-ls", -- Rust 辅助工具（类似检查器）
	"gomodifytags", -- Go struct tag 修改
	"impl", -- Go interface 实现生成
	"java-test", -- Java 测试支持
	"tree-sitter-cli", -- 语法树工具
}

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
		config = function()
			local mr = require("mason-registry")
			mr.refresh(function()
				for _, tool in ipairs(ensure_install) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
}
