require("luasnip").setup({
  history = true,
  delete_check_events = "TextChanged",
  update_events = { "TextChanged", "TextChangedI" },
  enable_autosnippets = true,
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { " <- Choice ", "NonTest" } },
      },
    },
  },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
