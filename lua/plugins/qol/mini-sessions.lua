-- Session Management
local filename = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".session.vim"

---@type LazyPluginSpec
return {
	"nvim-mini/mini.sessions",
	event = "BufReadPre",
  enabled = false,
  opts = {},
	config = function()
		local opts = {
			autoread = false,
			autowrite = true,
			directory = vim.fn.stdpath("state") .. "/sessions",
			file = "",
			force = { read = false, write = true, delete = false },
			hooks = {
				pre = { read = nil, write = nil, delete = nil },
				post = { read = nil, write = nil, delete = nil },
			},
			verbose = { read = false, write = true, delete = true },
		}
		require("mini.sessions").setup(opts)
	end,
	keys = {
		{
			"<leader>qs",
			function()
				require("mini.sessions").select()
			end,
			mode = "n",
			desc = "Select Session",
		},
		{
			"<leader>qw",
			function()
				require("mini.sessions").write(filename, { force = true })
			end,
			mode = "n",
			desc = "Save Current Session",
		},
	},
}
