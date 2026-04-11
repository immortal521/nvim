local keys = {
	-- tabs
	{ "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last Tab" },
	{ "<leader><tab>o", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
	{ "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First Tab" },
	{ "<leader><tab><tab>", "<cmd>tabnew<cr>", desc = "New Tab" },
	{ "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next Tab" },
	{ "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close Tab" },
	{ "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Previous Tab" },
}

Utils.keymap.add(keys)
