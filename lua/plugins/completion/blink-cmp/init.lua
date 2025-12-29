local configs = require("plugins.completion.blink-cmp.configs")

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true }),
  once = true,
  callback = function()
    require("blink.cmp").setup({
      appearance = configs.appearance,
      keymap = configs.keymap,
      cmdline = configs.cmdline,
      signature = configs.signature,
      completion = configs.completion,
      snippets = { preset = "luasnip" },
      sources = configs.sources,
    })
  end,
})
