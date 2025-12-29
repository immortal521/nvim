vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/hiphish/rainbow-delimiters.nvim" },
  { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
})

require("plugins.highlight.treesitter")
require("plugins.highlight.rainbow-delimiters")
require("plugins.highlight.colorful-menu")
