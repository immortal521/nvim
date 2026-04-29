-- Diagnostics list
---@type zpack.Spec
return {
	"folke/trouble.nvim",

	---@type trouble.Config
	opts = {
		focus = true,
		lsp = {
			win = { position = "right" },
		},
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", mode = "n", desc = "Diagnostics (Trouble)" },
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			mode = "n",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", mode = "n", desc = "Location List (Trouble)" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", mode = "n", desc = "Quickfix List (Trouble)" },

		{
			"[q",
			function()
				if require("trouble").is_open() then
					require("trouble").prev({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cprev)
					if not ok then
						Utils.log.error(err)
					end
				end
			end,
			mode = "n",
			desc = "Previous Trouble/Quickfix Item",
		},

		{
			"]q",
			function()
				if require("trouble").is_open() then
					require("trouble").next({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cnext)
					if not ok then
						Utils.log.error(err)
					end
				end
			end,
			mode = "n",
			desc = "Next Trouble/Quickfix Item",
		},
	},
}
