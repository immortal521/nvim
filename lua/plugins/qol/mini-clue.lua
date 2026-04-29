local leader_group_clues = {
	{ keys = "<leader>a", mode = { "n", "x" }, desc = "+ai" },
	{ keys = "<leader>b", mode = "n", desc = "+buffer" },
	{ keys = "<leader>c", mode = { "n", "x" }, desc = "+code" },
	{ keys = "<leader>cp", mode = { "n", "x" }, desc = "+code preview" },
	{ keys = "<leader>d", mode = { "n", "x" }, desc = "+debug" },
	{ keys = "<leader>f", mode = "n", desc = "+find" },
	{ keys = "<leader>g", mode = "n", desc = "+git" },
	{ keys = "<leader>l", mode = "n", desc = "+lsp" },
	{ keys = "<leader>o", mode = "n", desc = "+overseer" },
	{ keys = "<leader>q", mode = "n", desc = "+session" },
	{ keys = "<leader>s", mode = { "n", "x" }, desc = "+search" },
	{ keys = "<leader>t", mode = "n", desc = "+terminal" },
	{ keys = "<leader>u", mode = "n", desc = "+ui" },
	{ keys = "<leader>w", mode = "n", desc = "+window" },
	{ keys = "<leader>x", mode = "n", desc = "+other" },
	{ keys = "<leader>e", mode = "n", desc = "files" },
	{ keys = "<leader>p", mode = "n", desc = "+pack" },
	{ keys = "<leader><tab>", mode = "n", desc = "+tabs" },
}

---@type zpack.Spec
return {
	"nvim-mini/mini.clue",
	event = "VeryLazy",
	enabled = false,
	opts = function()
		local clue = require("mini.clue")
		return {
			triggers = {
				-- Leader triggers
				{ mode = { "n", "x" }, keys = "<Leader>" },

				{ mode = { "n", "x" }, keys = "[" },

				{ mode = { "n", "x" }, keys = "]" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = { "n", "x" }, keys = "g" },

				-- Marks
				{ mode = { "n", "x" }, keys = "'" },
				{ mode = { "n", "x" }, keys = "`" },

				-- Registers
				{ mode = { "n", "x" }, keys = '"' },
				{ mode = { "i", "c" }, keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = { "n", "x" }, keys = "z" },
			},

			clues = {
				leader_group_clues,

				-- Enhance this by adding descriptions for <Leader> mapping groups
				clue.gen_clues.builtin_completion(),
				clue.gen_clues.g(),
				clue.gen_clues.square_brackets(),
				clue.gen_clues.marks(),
				clue.gen_clues.registers(),
				clue.gen_clues.windows(),
				clue.gen_clues.z(),
			},

			window = {
				config = {
					border = "rounded",
				},
				delay = 300,
			},
		}
	end,
}
