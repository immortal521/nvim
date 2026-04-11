-- Normal / Visual
if vim.fn.has("nvim-0.12") == 1 then
	vim.keymap.del({ "n", "v" }, "gra")
	vim.keymap.del("n", "gri")
	vim.keymap.del("n", "grn")
	vim.keymap.del("n", "grr")
	vim.keymap.del("n", "grt")
	vim.keymap.del("n", "grx")
	vim.keymap.del("n", "gO")

	-- Insert
	vim.keymap.del("i", "<C-s>")

	-- Visual / Operator-pending（文本对象）
	vim.keymap.del({ "x", "o" }, "an")
	vim.keymap.del({ "x", "o" }, "in")
end

local keys = {
	-- better up/down
	{ "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Down", expr = true, silent = true },
	{ "<Down>", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Down", expr = true, silent = true },
	{ "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Up", expr = true, silent = true },
	{ "<Up>", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Up", expr = true, silent = true },

	-- Command-line mode
	{ "<A-h>", "<Left>", mode = "c", desc = "Left" },
	{ "<A-l>", "<Right>", mode = "c", desc = "Right" },

	-- Insert mode
	{ "<A-h>", "<Left>", mode = "i", noremap = false, desc = "Left" },
	{ "<A-j>", "<Down>", mode = "i", noremap = false, desc = "Down" },
	{ "<A-k>", "<Up>", mode = "i", noremap = false, desc = "Up" },
	{ "<A-l>", "<Right>", mode = "i", noremap = false, desc = "Right" },

	-- Terminal mode
	{ "<A-h>", "<Left>", mode = "t", desc = "Left" },
	{ "<A-j>", "<Down>", mode = "t", desc = "Down" },
	{ "<A-k>", "<Up>", mode = "t", desc = "Up" },
	{ "<A-l>", "<Right>", mode = "t", desc = "Right" },

	-- move lines
	{ "<C-j>", "<cmd>execute 'move .+' . v:count1<cr>==", desc = "Move Down" },
	{ "<C-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", desc = "Move Up" },
	{ "<C-j>", "<esc><cmd>m .+1<cr>==gi", mode = "i", desc = "Move Down" },
	{ "<C-k>", "<esc><cmd>m .-2<cr>==gi", mode = "i", desc = "Move Up" },
	{ "<C-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", mode = "v", desc = "Move Down" },
	{ "<C-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", mode = "v", desc = "Move Up" },

	-- Reselect latest changed, put, or yanked text
	{
		"gV",
		'"`[" . strpart(getregtype(), 0, 1) . "`]"',
		expr = true,
		replace_keycodes = false,
		desc = "Visually select changed text",
	},

	{
		"g/",
		"<esc>/\\%V",
		mode = "x",
		silent = false,
		desc = "Search inside visual selection",
	},

	-- esc clear highlight
	{
		"<esc>",
		function()
			vim.cmd("noh")
			return "<esc>"
		end,
		mode = { "i", "n", "s" },
		expr = true,
		desc = "Escape and Clear hlsearch",
	},

	-- clear search / diff / redraw
	{
		"<leader>ur",
		"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
		desc = "Redraw / Clear hlsearch / Diff Update",
	},

	-- saner n/N
	{ "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search Result" },
	{ "n", "'Nn'[v:searchforward]", mode = "x", expr = true, desc = "Next Search Result" },
	{ "n", "'Nn'[v:searchforward]", mode = "o", expr = true, desc = "Next Search Result" },
	{ "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Prev Search Result" },
	{ "N", "'nN'[v:searchforward]", mode = "x", expr = true, desc = "Prev Search Result" },
	{ "N", "'nN'[v:searchforward]", mode = "o", expr = true, desc = "Prev Search Result" },

	-- undo breakpoints
	{ ",", ",<c-g>u", mode = "i" },
	{ ".", ".<c-g>u", mode = "i" },
	{ ";", ";<c-g>u", mode = "i" },

	-- save file
	{ "<C-s>", "<cmd>w<cr><esc>", mode = { "i", "x", "n", "s" }, desc = "Save File" },

	-- keywordprg
	{ "<leader>K", "<cmd>norm! K<cr>", desc = "Keywordprg" },

	-- indenting
	{ "<", "<gv", mode = "x" },
	{ ">", ">gv", mode = "x" },

	-- commenting
	{ "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Below" },
	{ "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Above" },

	-- location list
	{
		"<leader>xl",
		function()
			local success, err =
				pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
			if not success and err then
				Utils.log.error(tostring(err))
			end
		end,
		desc = "Location List",
	},

	-- quickfix list
	{
		"<leader>xq",
		function()
			local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
			if not success and err then
				Utils.log.error(tostring(err))
			end
		end,

		desc = "Quickfix List",
	},

	{ "[q", vim.cmd.cprev, desc = "Previous Quickfix" },
	{ "]q", vim.cmd.cnext, desc = "Next Quickfix" },

	-- quit
	{ "<leader>qq", "<cmd>qa<cr>", desc = "Quit All" },

	-- inspect
	{ "<leader>ui", vim.show_pos, desc = "Inspect Pos" },
	{
		"<leader>uI",
		function()
			vim.treesitter.inspect_tree()
			vim.api.nvim_input("I")
		end,
		desc = "Inspect Tree",
	},
}

Utils.keymap.add(keys)
