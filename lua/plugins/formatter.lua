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

		formatters_by_ft = require("toolchain").get_formatters(),

		formatters = vim.tbl_extend("force", require("toolchain").get_formatter_configs(), {
			injected = { options = { ignore_errors = true } },
		}),
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
