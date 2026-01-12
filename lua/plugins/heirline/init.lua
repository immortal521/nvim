vim.pack.add({
  { src = "https://github.com/rebelot/heirline.nvim" },
})

require("heirline").setup({
  statusline = require("plugins.heirline.statusline"),
  tabline = require("plugins.heirline.tabline"),
})
