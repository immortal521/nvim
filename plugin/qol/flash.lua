local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/folke/flash.nvim" }, { confirm = false })
	require("flash").setup({ jump = { autojump = true } })
end
local keys = {
	{ "s", "jump", { "n", "x", "o" }, "Flash" },
	{ "S", "treesitter", { "n", "x", "o" }, "Flash Treesitter" },
	{ "r", "remote", "o", "Remote Flash" },
	{ "R", "treesitter_search", { "o", "x" }, "Treesitter Search" },
	{ "<C-s>", "toggle", "c", "Toggle Flash Search" },
}
for _, item in ipairs(keys) do
	vim.keymap.set(item[3], item[1], function()
		load()
		return require("flash")[item[2]]()
	end, { desc = item[4] })
end
vim.keymap.set({ "n", "x", "o" }, "gl", function()
	load()
	return require("flash").jump({
		search = { mode = "search", max_length = 0 },
		label = { after = { 0, 0 } },
		pattern = "^",
	})
end, { desc = "Flash to Line Start" })
vim.keymap.set({ "n", "o", "x" }, "<C-Space>", function()
	load()
	return require("flash").treesitter({ actions = { ["<C-Space>"] = "next", ["<BS>"] = "prev" } })
end, { desc = "Flash Treesitter Incremental Selection" })
