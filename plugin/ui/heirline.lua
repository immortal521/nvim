local loaded = false

local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({
		"https://github.com/rebelot/heirline.nvim",
	}, {
		confirm = false,
	})

	local tabline = require("heirline.layouts.tabline")
	local statusline = require("heirline.layouts.statusline")

	local opts = {
		statusline = statusline,
		tabline = tabline,
	}

	require("heirline").setup(opts)
end

vim.api.nvim_create_autocmd({ "UIEnter" }, {
	once = true,
	callback = load,
})
