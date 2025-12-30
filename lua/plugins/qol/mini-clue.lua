---@type LazyPluginSpec
return {
	"nvim-mini/mini.clue",
	event = "VeryLazy",
	opts = function()
		local clue = require("mini.clue")
		return {
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				{ mode = "n", keys = "[" },
				{ mode = "x", keys = "[" },

				{ mode = "n", keys = "]" },
				{ mode = "x", keys = "]" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Registers
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
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
