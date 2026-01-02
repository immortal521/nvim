---@type LazyPluginSpec
return {
	"rafamadriz/friendly-snippets",
	lazy = true,
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets" },
		})
	end,
}
