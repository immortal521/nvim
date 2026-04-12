---@type LazyPluginSpec
return {
	"akinsho/toggleterm.nvim",
	enabled = false,
	lazy = false,
	---@module "toggleterm"
	---@type ToggleTermConfig
	opts = {
		float_opts = {
			border = "rounded",
			width = function()
				return math.floor(vim.o.columns * 0.85)
			end,
			height = function()
				return math.floor(vim.o.lines * 0.85)
			end,
		},
		highlights = {
			FloatBorder = { link = "@type.builtin" },
		},
		start_in_insert = true,
		insert_mappings = true,
		terminal_mappings = true,
		persist_mode = false,
		direction = "float",
		-- on_open = function()
		-- 	vim.cmd("startinsert")
		-- end,
	},
	keys = {
		{
			"jk",
			[[<C-\><C-n>]],
			mode = "t",
			desc = "Exit terminal mode",
		},
		{
			"<leader>tf",
			"<cmd>ToggleTerm<cr>",
			mode = "n",
			desc = "Toggle floating terminal",
		},
		{
			"<leader>ts",
			"<cmd>TermSelect<cr>",
			mode = "n",
			desc = "Select terminal",
		},
	},
}
