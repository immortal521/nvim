vim.pack.add({
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
}, { confirm = false })

local luasnip = require("luasnip")
luasnip.setup({
	history = true,
	delete_check_events = "TextChanged",
	update_events = { "TextChanged", "TextChangedI" },
	enable_autosnippets = true,
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})
