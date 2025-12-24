-- Mini.nvim 插件集合
-- 提供了一系列轻量级、功能强大的 Neovim 插件

vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/nvim-mini/mini.clue" },
  { src = "https://github.com/nvim-mini/mini.diff" },
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/nvim-mini/mini-git" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.move" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/nvim-mini/mini.splitjoin" },
  { src = "https://github.com/nvim-mini/mini.jump" },
})

-- 设置各个 mini 插件
require("plugins.mini.icons")
require("plugins.mini.files")
require("plugins.mini.diff")
require("plugins.mini.clue")
require("plugins.mini.ai")
require("plugins.mini.surround")
require("plugins.mini.git")
require("plugins.mini.move")
require("plugins.mini.pairs")
require("plugins.mini.splitjoin")
require("plugins.mini.jump")
