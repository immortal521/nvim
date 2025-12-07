-- Mini.nvim 插件集合
-- 提供了一系列轻量级、功能强大的 Neovim 插件

vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/nvim-mini/mini.animate" },
  { src = "https://github.com/nvim-mini/mini.bufremove" },
  { src = "https://github.com/nvim-mini/mini.clue" },
  { src = "https://github.com/nvim-mini/mini.diff" },
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/nvim-mini/mini-git" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.indentscope" },
  { src = "https://github.com/nvim-mini/mini.move" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/nvim-mini/mini.sessions" },
  { src = "https://github.com/nvim-mini/mini.surround" },
})

-- 设置各个 mini 插件
require("plugins.mini.icons")
require("plugins.mini.files")
require("plugins.mini.diff")
require("plugins.mini.clue")
require("plugins.mini.sessions")
require("plugins.mini.ai")
require("plugins.mini.surround")
require("mini.git").setup({})
require("mini.move").setup({})
require("mini.pairs").setup({})
