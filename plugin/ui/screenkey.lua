local loaded = false

local function load()
	if loaded then
		return
	end

	loaded = true

	vim.pack.add({
		"https://github.com/NStefan002/screenkey.nvim",
	}, {
		confirm = false,
		load = true,
	})

	require("screenkey").setup({
		win_opts = {
			relative = "editor",
			row = vim.o.lines - 1,
			col = vim.o.columns - 32,
			height = 3,
			width = 20,
			border = "rounded",
			title = "",
		},
	})
end

vim.keymap.set("n", "<leader>uk", function()
	load()
	require("screenkey").toggle()
end, {
	silent = true,
	desc = "Toggle Screenkey",
})
