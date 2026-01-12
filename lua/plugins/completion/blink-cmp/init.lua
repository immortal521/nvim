local configs = require("plugins.completion.blink-cmp.configs")

require("blink.cmp").setup({
  appearance = configs.appearance,
  keymap = configs.keymap,
  cmdline = configs.cmdline,
  signature = configs.signature,
  completion = configs.completion,
  snippets = { preset = "luasnip" },
  sources = configs.sources,
})
