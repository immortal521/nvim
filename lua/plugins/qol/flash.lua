-- Search and Navigation
---@type LazyPluginSpec
return {
	"folke/flash.nvim",
	event = "VeryLazy",

	---@type Flash.Config
	opts = {
		jump = {
			autojump = true,
		},
	},
	keys = {
		{
			"s",
			function()
				require("flash").jump()
			end,
			desc = "Flash",
			mode = { "n", "x", "o" },
		},
		{
			"S",
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
			mode = { "n", "x", "o" },
		},
		{
			"r",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
			mode = "o",
		},
		{
			"R",
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
			mode = { "o", "x" },
		},
		{
			"<C-s>",
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
			mode = { "c" },
		},
		{
			"gl",
			function()
				require("flash").jump({
					search = { mode = "search", max_length = 0 },
					label = { after = { 0, 0 } },
					pattern = "^",
				})
			end,
			desc = "Flash to Line Start",
			mode = { "n", "x", "o" },
		},
		{
			"<C-Space>",
			mode = { "n", "o", "x" },
			function()
				require("flash").treesitter({
					actions = {
						["<C-Space>"] = "next",
						["<BS>"] = "prev",
					},
				})
			end,
			desc = "Treesitter Incremental Selection",
		},
	},
}
