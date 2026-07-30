local keys = {
	{ "<S-h>", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
	{ "<S-l>", "<cmd>bnext<cr>", desc = "Next Buffer" },
	{ "[b", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
	{ "]b", "<cmd>bnext<cr>", desc = "Next Buffer" },
	{ "<leader>bb", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },
	{ "<leader>`", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },
	{ "<leader>bD", "<cmd>:bd<cr>", desc = "Delete Buffer and Window" },

	{
		"<leader>bd",
		function()
			Core.buf.delete()
		end,
		desc = "Delete Buffer",
	},
	{
		"<leader>bo",
		function()
			Core.buf.other()
		end,
		desc = "Delete Other Buffers",
	},
}

Utils.keymap.add(keys)
