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
				for _, tool in ipairs(require("toolchain").get_mason_packages()) do
					if mr.has_package(tool) then
						local p = mr.get_package(tool)
						if not p:is_installed() then
							p:install()
						end
					else
						vim.notify(("Mason package not found: %s"):format(tool), vim.log.levels.WARN)
					end
				end
			end)
		end,
	},
}
