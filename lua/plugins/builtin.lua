---@type LazyPluginSpec
return {
	name = "builtin",
	dir = vim.fn.stdpath("config"),
	lazy = false,
	priority = 1000,
	main = "builtin",
	config = function()
		require("builtin").setup({
			scroll = { enabled = true },
		})
	end,
}
