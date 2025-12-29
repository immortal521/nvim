require("luasnip.config").setup({
  delete_check_events = "TextChanged",
  update_events = { "TextChanged", "TextChangedI" },
  enable_autosnippets = true,
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
