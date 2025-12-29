vim.pack.add({
  { src = "https://github.com/immortal521/windsurf.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range(">=1.0.0 <2.0.0") },
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range(">=2.0.0 <3.0.0") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/niuiic/blink-cmp-rg.nvim" },
})

require("plugins.completion.blink-cmp")
require("plugins.completion.luasnip")
require("plugins.completion.windsurf")
