local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/nvim-mini/mini.surround" }, { confirm = false })
	require("mini.surround").setup({
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",
		},
		n_lines = 20,
		respect_selection_type = false,
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
