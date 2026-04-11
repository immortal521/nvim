local keys = {
	-- new file
	{ "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
	{ "<leader>fs", "<cmd>e<cr>", desc = "Reload File" },
	{
		"<leader>fe",
		function()
			Utils.project.change_cwd()
		end,
		desc = "Change Current Working Directory",
	},
}

Utils.keymap.add(keys)
