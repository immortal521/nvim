---@type LazyPluginSpec
return {
	"nvim-mini/mini.files",
	lazy = true,
	opts = {
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
	},
	keys = {
		{ "<leader>e", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>" },
	},
}
