---@type LazyPluginSpec
return {
	"nvim-mini/mini.clue",
	event = "VeryLazy",
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
				Config.leader_group_clues,

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
