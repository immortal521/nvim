local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/danymat/neogen" }, { confirm = false })
	require("neogen").setup({ snippet_engine = "luasnip" })
end
vim.keymap.set("n", "<leader>cn", function()
	load()
	require("neogen").generate()
end, {
	desc = "Generate Annotations (Neogen)",
})
