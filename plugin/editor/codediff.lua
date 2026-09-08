local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/esmuellert/codediff.nvim" }, { confirm = false })
	require("codediff").setup({})
end

vim.api.nvim_create_autocmd("CmdUndefined", { pattern = "CodeDiff", once = true, callback = load })

vim.keymap.set("n", "<leader>cD", function()
	load()
	vim.cmd("CodeDiff")
end, {
	desc = "Code Diff",
})
