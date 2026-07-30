---@type LazyPluginSpec
return {
	"immortal521/toggleterm.nvim",
	enabled = false,
	lazy = false,
	---@module "toggleterm"
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
		on_open = function()
			vim.cmd("startinsert")
		end,
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
			function()
				local count = vim.v.count1
				require("toggleterm").toggle(count, 0, Utils.project.get_project_root(), "float")
			end,
			mode = "n",
			desc = "Toggle floating terminal",
		},
		{
			"<leader>ts",
			"<cmd>TermSelect<cr>",
			mode = "n",
			desc = "Select terminal",
		},
		{
			"<leader>th",
			function()
				local count = vim.v.count1
				require("toggleterm").toggle(count, 15, Utils.project.get_project_root(), "horizontal")
			end,
			desc = "ToggleTerm (horizontal root_dir)",
		},
		{
			"<leader>tv",
			function()
				local count = vim.v.count1
				require("toggleterm").toggle(count, vim.o.columns * 0.4, Utils.project.get_project_root(), "vertical")
			end,
			desc = "ToggleTerm (vertical root_dir)",
		},
		{
			"<leader>tn",
			"<cmd>ToggleTermSetName<cr>",
			desc = "Set term name",
		},
		{
			"<leader>tt",
			function()
				require("toggleterm").toggle(1, 100, Utils.project.get_project_root(), "tab")
			end,
			desc = "ToggleTerm (tab root_dir)",
		},
		{
			"<leader>tT",
			function()
				require("toggleterm").toggle(1, 100, vim.uv.cwd(), "tab")
			end,
			desc = "ToggleTerm (tab cwd_dir)",
		},
	},
}
