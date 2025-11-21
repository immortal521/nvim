vim.pack.add({
  -- ======================================
  -- 自动保存 / 编辑体验增强
  -- ======================================
  { src = "https://github.com/immortal521/auto-save.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },

  -- ======================================
  -- 大模型
  -- ======================================
  { src = "https://github.com/Kurama622/llm.nvim" },

  -- ======================================
  -- mini.nvim 系列（编辑增强 / 基础工具）
  -- ======================================
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/nvim-mini/mini.diff" },
  { src = "https://github.com/nvim-mini/mini-git" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/nvim-mini/mini.move" },
  { src = "https://github.com/nvim-mini/mini.pairs" },

  -- ======================================
  -- 键位提示 / 动作导航
  -- ======================================
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/folke/flash.nvim" },

  -- ======================================
  -- 补全
  -- ======================================
  { src = "https://github.com/Exafunction/windsurf.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range(">=1.0.0 <2.0.0") },
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range(">=2.0.0 <3.0.0") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- ======================================
  -- LSP
  -- ======================================
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },

  -- ======================================
  -- 格式化
  -- ======================================
  { src = "https://github.com/stevearc/conform.nvim" },

  -- ======================================
  -- UI / 交互体验增强
  -- ======================================
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/xiyaowong/transparent.nvim" },
  { src = "https://github.com/b0o/incline.nvim" },
  { src = "https://github.com/oribarilan/lensline.nvim" },
  { src = "https://github.com/rebelot/heirline.nvim" },

  -- ======================================
  -- 文件管理 / 会话管理
  -- ======================================
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/folke/persistence.nvim" },

  -- ======================================
  -- Treesitter / 语法增强
  -- ======================================
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/folke/ts-comments.nvim" },

  -- ======================================
  -- 代码工具 / 辅助
  -- ======================================
  { src = "https://github.com/ThePrimeagen/refactoring.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/gbprod/yanky.nvim" },
  { src = "https://github.com/wakatime/vim-wakatime" },
  { src = "https://github.com/mistweaverco/kulala.nvim" },
  { src = "https://github.com/monaqa/dial.nvim" },

  -- ======================================
  -- 全局搜索替换
  -- ======================================
  { src = "https://github.com/MagicDuck/grug-far.nvim" },

  -- ======================================
  -- 输入法相关
  -- ======================================
  { src = "https://github.com/keaising/im-select.nvim" },
  { src = "https://github.com/immortal521/ime_toggle" },

  -- ======================================
  -- 颜色显示增强
  -- ======================================
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },

  -- ======================================
  -- rust
  -- ======================================
  { src = "https://github.com/saecki/crates.nvim", version = "stable" },
  -- { src = "https://github.com/mrcjkb/rustaceanvim" },

  -- ======================================
  -- github
  -- ======================================
  -- { src = "https://github.com/pwntester/octo.nvim" },
})
