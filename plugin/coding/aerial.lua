local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		"https://github.com/stevearc/aerial.nvim",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-mini/mini.icons",
	}, { confirm = false })
	require("aerial").setup({ autojump = true })
end

vim.keymap.set("n", "<leader>cs", function()
	load()
	vim.cmd("AerialToggle")
end, { desc = "Aerial Toggle" })
