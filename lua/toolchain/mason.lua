local M = {}

-- 规格中的名称是 Neovim/Conform/nvim-lint 名称，Mason 使用自己的包名。
local packages = {
	-- LSP
	["bash-language-server"] = "bash-language-server",
	["clangd"] = "clangd",
	["css-lsp"] = "css-lsp",
	["css-variables-language-server"] = "css-variables-language-server",
	["cssmodules-language-server"] = "cssmodules-language-server",
	["emmet-language-server"] = "emmet-language-server",
	["emmylua"] = "emmylua_ls",
	["gopls"] = "gopls",
	["html"] = "html-lsp",
	["jdtls"] = "jdtls",
	["jsonls"] = "json-lsp",
	["kotlin-lsp"] = "kotlin-language-server",
	["lua_ls"] = "lua-language-server",
	["pyright"] = "pyright",
	["rnix"] = "rnix-lsp",
	["ruff"] = "ruff",
	["rust_analyzer"] = "rust-analyzer",
	["stylelint-language-server"] = "stylelint-language-server",
	["tailwindcss"] = "tailwindcss-language-server",
	["tombi"] = "tombi",
	["vtsls"] = "vtsls",
	["vue_ls"] = "vue-language-server",
	["luau-lsp"] = "luau-lsp",
	["nushell"] = "nushell",
	["qmlls"] = "qmlls",

	-- Formatter and lint
	["biome"] = "biome",
	["clang_format"] = "clang-format",
	["gofumpt"] = "gofumpt",
	["goimports"] = "goimports",
	["isort"] = "isort",
	["nixfmt"] = "nixfmt",
	["oxfmt"] = "oxfmt",
	["oxlint"] = "oxlint",
	["prettier"] = "prettier",
	["ruff_format"] = "ruff",
	["selene"] = "selene",
	["shellcheck"] = "shellcheck",
	["shfmt"] = "shfmt",
	["sqruff"] = "sqruff",
	["stylua"] = "stylua",
	["taplo"] = "taplo",
	["xmlformatter"] = "xmlformatter",
	["yapf"] = "yapf",
	["golangcilint"] = "golangci-lint",
}

local extra_packages = {
	"codelldb",
	"delve",
	"java-debug-adapter",
	"js-debug-adapter",
	"bacon-ls",
	"gomodifytags",
	"impl",
	"java-test",
	"tree-sitter-cli",
	"ktlint",
	"sqlfluff",
	"codespell",
}

local function add(result, seen, name)
	local package = packages[name]
	if package and not seen[package] then
		seen[package] = true
		result[#result + 1] = package
	end
end

---@param name string
---@return boolean
function M.is_installed(name)
	local package = packages[name]
	if not package then
		return true
	end
	local ok, registry = pcall(require, "mason-registry")
	return ok and registry.has_package(package) and registry.get_package(package):is_installed()
end

---@return string[]
function M.get_packages()
	local result = {}
	local seen = {}
	local toolchain = require("toolchain")

	for _, definition in pairs(toolchain.lang.get()) do
		for _, name in ipairs(definition.lsp or {}) do
			add(result, seen, name)
		end
	end

	for _, formatters in pairs(toolchain.get_formatters()) do
		for _, name in ipairs(formatters) do
			add(result, seen, name)
		end
	end
	for _, linters in pairs(toolchain.get_linters()) do
		for _, name in ipairs(linters) do
			add(result, seen, name)
		end
	end
	for _, package in ipairs(extra_packages) do
		if not seen[package] then
			seen[package] = true
			result[#result + 1] = package
		end
	end

	table.sort(result)
	return result
end

return M
