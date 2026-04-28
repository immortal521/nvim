-- Formatter

local function assign(map, fts, formatters)
	for _, ft in ipairs(fts) do
		map[ft] = formatters
	end
end

local function config_find_up(ctx, names)
	local dir = vim.fs.dirname(ctx.filename)
	local found = vim.fs.find(names, {
		path = dir,
		upward = true,
		stop = vim.uv.os_homedir(),
	})
	return found and #found > 0
end

local function has_any_config(ctx, names)
	return config_find_up(ctx, names)
end

local function has_any_of(ctx, groups)
	for _, names in ipairs(groups) do
		if has_any_config(ctx, names) then
			return true
		end
	end
	return false
end

local function with_config(names, extra)
	return function(_, ctx)
		if not has_any_config(ctx, names) then
			return false
		end
		if extra then
			return extra(ctx)
		end
		return true
	end
end

local function has_prettier_config_cli(ctx)
	vim.fn.system({ "prettier", "--find-config-path", ctx.filename })
	return vim.v.shell_error == 0
end

local PRETTIER_CONFIGS = {
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

local BIOME_CONFIGS = {
	"biome.json",
	"biome.jsonc",
}

local OXFMT_CONFIGS = {
	".oxfmtrc.json",
	".oxfmtrc.jsonc",
	"oxfmt.json",
	"oxfmt.jsonc",
}

---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = "BufEdit",

	---@type conform.setupOpts
	opts = {
		-- log_level = vim.log.levels.DEBUG,
		default_format_opts = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
			lsp_format = "fallback",
		},
		notify_on_error = true,

		formatters_by_ft = (function()
			local ft = {}

			assign(ft, {
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

			assign(ft, {
				"xml",
				"svg",
			}, { "xmlformatter" })

			ft.python = { "ruff_format", "isort", "yapf" }
			ft.sh = { "shfmt" }
			ft.toml = { "taplo" }
			ft.rust = { "rustfmt" }
			ft.cpp = { "clang_format" }
			ft.c = { "clang_format" }
			ft.go = { "goimports", "gofumpt" }
			ft.lua = { "stylua" }
			ft.sql = { "sqruff" }

			return ft
		end)(),

		formatters = {
			prettier = {
				condition = function(_, ctx)
					return has_any_config(ctx, PRETTIER_CONFIGS)
				end,

				-- condition = function(_, ctx)
				-- 	return has_prettier_config_cli(ctx)
				-- end,
			},

			biome = {
				condition = function(_, ctx)
					return has_any_config(ctx, BIOME_CONFIGS)
					-- and not has_any_config(ctx, PRETTIER_CONFIGS)
				end,
			},

			oxfmt = {
				condition = function(_, ctx)
					if has_any_config(ctx, OXFMT_CONFIGS) then
						return true
					end
					return not has_any_of(ctx, { PRETTIER_CONFIGS, BIOME_CONFIGS, OXFMT_CONFIGS })
				end,
			},

			injected = { options = { ignore_errors = true } },
		},
	},

	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = true,
				})
			end,
			desc = "Format",
		},
	},
}
