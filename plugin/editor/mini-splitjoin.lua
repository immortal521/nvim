local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/nvim-mini/mini.splitjoin" }, { confirm = false })
	require("mini.splitjoin").setup({})
end

vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}, {
	once = true,
	callback = load,
})
