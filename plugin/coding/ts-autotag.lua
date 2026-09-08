local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/windwp/nvim-ts-autotag" }, { confirm = false })
	require("nvim-ts-autotag").setup({
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	})
end
vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}, {
	once = true,
	callback = load,
})
