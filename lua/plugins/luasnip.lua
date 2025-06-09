return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  build = "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp",
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "./snippets" } })
      end,
    },
  },
  opts = function()
    local opts = {
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
    }
    return opts
  end,
}
