local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/folke/ts-comments.nvim" }, { confirm = false })
	require("ts-comments").setup({})
end

vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}, {
	once = true,
	callback = load,
})
