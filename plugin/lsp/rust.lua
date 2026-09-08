vim.api.nvim_create_autocmd("FileType", {
	pattern = { "rust", "cargo.toml" },
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/saecki/crates.nvim" }, { confirm = false })
		require("crates").setup({
			completion = { crates = { enabled = true } },
			lsp = { enabled = true, actions = true, completion = true, hover = true },
		})
	end,
})
