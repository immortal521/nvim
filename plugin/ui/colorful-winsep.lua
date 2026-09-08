local loaded = false

local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ "https://github.com/nvim-zh/colorful-winsep.nvim" }, { confirm = false })

	local opts = {}

	require("colorful-winsep").setup(opts)
end

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	once = true,
	callback = load,
})
