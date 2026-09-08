local term_normal = {
	"jk",
	function()
		vim.cmd("stopinsert")
	end,
	mode = "t",
	expr = false,
	desc = "Single escape to normal mode",
}

local win = {
	position = "float",
	border = "rounded",
	keys = {
		term_normal = term_normal,
	},
}

local self_keys = {
	{
		"<leader>pu",
		function()
			vim.pack.update()
		end,
		desc = "Update Plugins",
	},
	{
		"<leader>gg",
		function()
			Builtin.lazygit()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>tf",
		function()
			Builtin.terminal(nil, { win = win })
		end,

		desc = "Terminal Float",
	},
	{
		"<leader>tm",
		function()
			Builtin.terminal("rmpc", { win = win })
		end,
		desc = "Music Player",
		silent = true,
		noremap = true,
	},
}

Utils.keymap.add(self_keys)
