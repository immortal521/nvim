local loaded = false

local function load()
	if loaded then
		return
	end

	loaded = true

	vim.pack.add({
		"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	}, {
		confirm = false,
		load = true,
	})

	local opts = {
		disabled_ft = { "lazy" },
		options = {
			throttle = 20,
			show_source = {
				enabled = true,
			},
		},
	}

	vim.diagnostic.config({ virtual_text = false })

	require("tiny-inline-diagnostic").setup(opts)
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	once = true,
	callback = load,
})
