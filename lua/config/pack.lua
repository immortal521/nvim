local M = {}

function M.setup(extra_plugins)
	local plugin_spec = {
		{ import = "plugins" },
		{ import = "plugins.coding" },
		{ import = "plugins.colorschemes" },
		{ import = "plugins.deps" },
		{ import = "plugins.editor" },
		{ import = "plugins.highlight" },
		{ import = "plugins.lsp" },
		{ import = "plugins.qol" },
		{ import = "plugins.ui" },
	}

	local opts = {
		spec = vim.list_extend(plugin_spec, extra_plugins or {}),
		defaults = {
			confirm = false,
		},
	}

	require("zpack").setup(opts)
	Utils.keymap.add({
		{
			"<leader>pc",
			"<cmd>ZClean<cr>",
			desc = "Clean Unused Plugins",
		},
		{
			"<leader>pu",
			"<cmd>ZUpdate<cr>",
			desc = "Update Plugins",
		},
		{
			"<leader>pb",
			"<cmd>ZBuild!<cr>",
			desc = "Build Plugins",
		},
	})
end

return M
