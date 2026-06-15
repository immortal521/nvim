local keys = {
	-- resize window
	{
		"<leader>+",
		function()
			vim.cmd(("resize +%d"):format(vim.v.count1 * 2))
		end,
		desc = "Increase Window Height",
	},
	{
		"<leader>_",
		function()
			vim.cmd(("resize -%d"):format(vim.v.count1 * 2))
		end,
		desc = "Decrease Window Height",
	},
	{
		"<leader>>",
		function()
			vim.cmd(("vertical resize +%d"):format(vim.v.count1 * 2))
		end,
		desc = "Increase Window Width",
	},
	{
		"<leader><",
		function()
			vim.cmd(("vertical resize -%d"):format(vim.v.count1 * 2))
		end,
		desc = "Decrease Window Width",
	},

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
