---@type LazyPluginSpec
return {
	"danymat/neogen",
	cmd = "Neogen",
	opts = {
		snippet_engine = "luasnip",
	},
	keys = {
		{
			"<leader>cn",
			function()
				require("neogen").generate()
			end,
			desc = "Generate Annotations (Neogen)",
		},
	},
}
