-- Buffer like Filesystem
---@type LazyPluginSpec
return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	lazy = false,
	opts = function()
		---@type oil.SetupOpts
		return {
			default_file_explorer = true,
			columns = {
				"icon",
			},
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			delete_to_trash = false,
			skip_confirm_for_simple_edits = true,
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
				autosave_changes = false,
			},
			constrain_cursor = "editable",
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["\\"] = { "actions.select", opts = { horizontal = true } },
				["|"] = { "actions.select", opts = { vertical = true } },
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-r>"] = "actions.refresh",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = { "actions.close", mode = "n" },
				["zh"] = { "actions.toggle_hidden", mode = "n" },
				["-"] = { "actions.close", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["<BS>"] = "actions.parent",
			},
			use_default_keymaps = false,
			view_options = {
				-- show_hidden = true,
			},
		}
	end,
	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
	},
}
