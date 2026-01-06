-- Linter
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-lint",
	event = "BufEdit",
	opts = {},
	config = function()
		require("lint").linters_by_ft = {
			go = { "golangcilint" },
			vue = { "eslint" },
			javascript = { "eslint" },
			typescript = { "eslint" },
		}

		local events = {
			"BufReadPost",
			"BufWritePost",
			"InsertLeave",
			"TextChanged",
		}

		-- local oxlint_config_files = { ".oxlintrc.json" }
		-- local eslint_config_files =
		-- 	{ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml" }

		local function debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function()
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)()
				end)
			end
		end

		vim.api.nvim_create_autocmd(events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, function()
				require("lint").try_lint()
			end),
		})
	end,
}
