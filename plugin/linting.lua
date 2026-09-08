local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { confirm = false })
	local lint = require("lint")
	local function configured(ctx, names)
		for _, name in ipairs(names) do
			if vim.fs.find(name, { path = ctx.dirname, upward = true })[1] then
				return true
			end
		end
		return false
	end
	lint.linters_by_ft = {
		go = { "golangcilint" },
		vue = { "eslint", "oxlint" },
		javascript = { "eslint", "oxlint" },
		typescript = { "eslint", "oxlint" },
	}
	for name, files in pairs({
		eslint = {
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
		},
		oxlint = { ".oxlintrc.json" },
	}) do
		if lint.linters[name] then
			lint.linters[name].condition = function(ctx)
				return configured(ctx, files)
			end
		end
	end
	local timer
	local function run()
		local names = vim.deepcopy(lint._resolve_linter_by_ft(vim.bo.filetype) or {})
		local ctx = { filename = vim.api.nvim_buf_get_name(0), dirname = vim.fn.expand("%:p:h") }
		names = vim.tbl_filter(function(name)
			return lint.linters[name] and not (lint.linters[name].condition and not lint.linters[name].condition(ctx))
		end, names)
		if #names > 0 then
			lint.try_lint(names)
		end
	end
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
		callback = function()
			if timer then
				timer:stop()
			end
			timer = vim.defer_fn(run, 100)
		end,
	})
end
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, { once = true, callback = load })
