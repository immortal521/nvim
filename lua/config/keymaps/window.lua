local keys = {
	-- resize window
	{ "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase Window Height" },
	{ "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease Window Height" },
	{ "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease Window Width" },
	{ "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase Window Width" },

	-- window move
	{ "<leader>wh", "<C-w>h", desc = "Go to Left Window", remap = true },
	{ "<leader>wj", "<C-w>j", desc = "Go to Lower Window", remap = true },
	{ "<leader>wk", "<C-w>k", desc = "Go to Upper Window", remap = true },
	{ "<leader>wl", "<C-w>l", desc = "Go to Right Window", remap = true },

	{ "<leader>-", "<C-W>s", desc = "Split Window Below", remap = true },
	{ "<leader>|", "<C-W>v", desc = "Split Window Right", remap = true },
	{ "<leader>wd", "<C-W>c", desc = "Delete Window", remap = true },
}

Utils.keymap.add(keys)

