vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/hiphish/rainbow-delimiters.nvim" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
})

require("plugins.highlight.treesitter")
require("plugins.highlight.rainbow-delimiters")
require("plugins.highlight.highlight-colors")
