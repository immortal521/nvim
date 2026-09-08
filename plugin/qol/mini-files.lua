local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ "https://github.com/nvim-mini/mini.files" }, { confirm = false })

	local opts = {
		options = {
			use_as_default_explorer = false,
		},
		windows = {
			-- Maximum number of windows to show side by side
			max_number = 3,
			-- Whether to show preview of file/directory under cursor
			preview = true,
			-- Width of focused window
			width_focus = 20,
			-- Width of non-focused window
			width_nofocus = 15,
			-- Width of preview window
			width_preview = 50,
		},
	}

	require("mini.files").setup(opts)
end

vim.keymap.set("n", "<leader>e", function()
	load()
	MiniFiles.open(vim.api.nvim_buf_get_name(0))
end)
