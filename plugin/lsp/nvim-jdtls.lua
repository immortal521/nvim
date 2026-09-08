vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/mfussenegger/nvim-jdtls" }, { confirm = false })
	end,
})
