local loaded = false

local function has_config(ctx, names)
	return #vim.fs.find(names, { path = vim.fs.dirname(ctx.filename), upward = true, stop = vim.uv.os_homedir() }) > 0
end

local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })
	local function assign(map, fts, formatters)
		for _, ft in ipairs(fts) do
			map[ft] = formatters
		end
	end
	local prettier = {
		".prettierrc",
		".prettierrc.json",
		".prettierrc.js",
		".prettierrc.yaml",
		".prettierrc.yml",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
		"prettier.config.mjs",
	}
	local biome = { "biome.json", "biome.jsonc" }
	local oxfmt = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.json", "oxfmt.jsonc" }
	local by_ft = {}
	assign(by_ft, {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"json",
		"jsonc",
		"css",
		"scss",
		"less",
		"html",
		"vue",
		"yaml",
		"graphql",
		"markdown",
		"markdown.mdx",
		"handlebars",
	}, { "prettier", "biome", "oxfmt" })
	assign(by_ft, { "xml", "svg" }, { "xmlformatter" })
	by_ft.python, by_ft.sh, by_ft.toml, by_ft.rust =
		{ "ruff_format", "isort", "yapf" }, { "shfmt" }, { "taplo" }, { "rustfmt" }
	by_ft.cpp, by_ft.c, by_ft.go, by_ft.lua, by_ft.sql, by_ft.luau, by_ft.nix =
		{ "clang_format" },
		{ "clang_format" },
		{ "goimports", "gofumpt" },
		{ "stylua" },
		{ "sqruff" },
		{ "stylua" },
		{ "nixfmt" }
	require("conform").setup({
		default_format_opts = { timeout_ms = 3000, async = false, quiet = false, lsp_format = "fallback" },
		notify_on_error = true,
		formatters_by_ft = by_ft,
		formatters = {
			prettier = {
				condition = function(_, ctx)
					return has_config(ctx, prettier)
				end,
			},
			biome = {
				condition = function(_, ctx)
					return has_config(ctx, biome)
				end,
			},
			oxfmt = {
				condition = function(_, ctx)
					return has_config(ctx, oxfmt) or not (has_config(ctx, prettier) or has_config(ctx, biome))
				end,
			},
			injected = { options = { ignore_errors = true } },
		},
	})
end

vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}, {
	once = true,
	callback = load,
})

vim.keymap.set("n", "<leader>cf", function()
	load()
	require("conform").format({
		async = true,
		lsp_fallback = true,
	})
end, {
	desc = "Format",
})
