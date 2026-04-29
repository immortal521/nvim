-- Linter
---@type zpack.Spec
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {
		events = {
			"BufReadPost",
			"BufWritePost",
			"InsertLeave",
		},

		linters_by_ft = {
			go = { "golangcilint" },
			vue = { "eslint", "oxlint" },
			javascript = { "eslint", "oxlint" },
			typescript = { "eslint", "oxlint" },
		},

		---@class LintLinter
		---@field condition? fun(ctx: { filename: string, dirname: string }): boolean

		---@type table<string, LintLinter>
		linters = {
			eslint = {
				condition = function(ctx)
					local eslint_config_files = {
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.json",
						".eslintrc.yaml",
						".eslintrc.yml",
						"eslint.config.js",
						"eslint.config.mjs",
						"eslint.config.cjs",
					}

					for _, name in ipairs(eslint_config_files) do
						if vim.fs.find(name, { path = ctx.dirname, upward = true })[1] then
							return true
						end
					end

					return false
				end,
			},
			oxlint = {
				condition = function(ctx)
					local oxlint_config_files = { ".oxlintrc.json" }

					for _, name in ipairs(oxlint_config_files) do
						if vim.fs.find(name, { path = ctx.dirname, upward = true })[1] then
							return true
						end
					end

					return false
				end,
			},
		},
	},
	config = function(_, opts)
		local M = {}

		local lint = require("lint")

		local function merge_linter(origin, override)
			local merged = vim.tbl_deep_extend("force", origin, override)

			if type(override.prepend_args) == "table" then
				merged.args = merged.args or {}
				vim.list_extend(merged.args, override.prepend_args)
			end

			return merged
		end

		for name, linter in pairs(opts.linters) do
			local origin = lint.linters[name]

			if type(linter) == "table" and type(origin) == "table" then
				lint.linters[name] = merge_linter(origin, linter)
			else
				lint.linters[name] = linter
			end
		end

		lint.linters_by_ft = opts.linters_by_ft

		function M.debounce(ms, fn)
			local timer = vim.uv.new_timer()

			if not timer then
				return function(...)
					local argv = { ... }
					vim.schedule(function()
						fn(unpack(argv))
					end)
				end
			end

			return function(...)
				local argv = { ... }
				timer:stop()
				timer:start(ms, 0, function()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		function M.lint()
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)

			names = vim.list_extend({}, names)

			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["*"] or {})
			end

			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				if not linter then
					Utils.log("Linter not found: " .. name, { title = "linter" })
				end
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			if #names > 0 then
				lint.try_lint(names)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = M.debounce(100, M.lint),
		})
	end,
}
