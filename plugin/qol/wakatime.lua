vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
	once = true,
	callback = function()
		vim.pack.add({
			"https://github.com/wakatime/vim-wakatime",
		}, { confirm = false })
	end,
})
