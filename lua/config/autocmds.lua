vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc" }, -- 匹配 JSON 和 JSONC 文件类型
  group = vim.api.nvim_create_augroup("show_text", { clear = true }),
  callback = function()
    vim.wo.conceallevel = 0 -- 禁用文本隐藏（显示所有字符）
  end,
})

-- 处理所有特殊缓冲区类型
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "", -- [No Name] 空缓冲区
    "qf", -- quick fix窗口
    "nofile", -- 无文件缓冲区
    "nowrite", -- 只读缓冲区
    "acwrite", -- 总是可写缓冲区
    "quickfix", -- 快速修复列表
    "help", -- 帮助文档
    "man", -- 手册页
    "fugitive", -- Git 相关
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "grug-far",
    "gitgraph",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "nvim-pack",
    "notify",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "fugitiveblame", -- Git blame
    "git", -- Git 相关
    "gitcommit", -- Git 提交信息
    "gitrebase", -- Git rebase
    "gitsigns-blame",
    "gitconfig", -- Git 配置
    "terminal", -- 终端
    "prompt", -- 提示窗口
    "popup", -- 弹出窗口
    "netrw", -- 文件浏览器
    "dirvish", -- 目录浏览
    "oil", -- Oil 文件浏览器
    "toggleterm", -- ToggleTerm
    "startuptime", -- 启动时间分析
    "checkhealth", -- 健康检查
    "lspinfo", -- LSP 信息
    "mason", -- Mason 包管理�
    "notify", -- 通知窗口
    "copilot", -- Copilot
    "dap-repl", -- DAP REPL
    "dapui_console", -- DAP UI 控制台
    "dapui_scopes", -- DAP UI 作用域
    "dapui_watches", -- DAP UI 监视
    "dapui_breakpoints", -- DAP UI 断点
    "dapui_stacks", -- DAP UI 堆栈
    "dapui_console", -- DAP UI 控制台
    "PlenaryTestPopup", -- Plenary 测试弹窗
    "tsplayground", -- Treesitter 游乐场
    "diff", -- 差异比较
    "DiffviewFiles", -- Diffview 文件
    "DiffviewFileHistory", -- Diffview 文件历史
    "DiffviewDiffPanel", -- Diffview 差异面板
  },
  group = vim.api.nvim_create_augroup("quit_window", { clear = true }),
  callback = function(event)
    -- 设置不列入缓冲区列表
    vim.bo[event.buf].buflisted = false

    -- 添加关闭快捷键
    vim.keymap.set("n", "q", ":close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "关闭特殊窗口",
    })

    -- ESC 键也关闭
    vim.keymap.set("n", "<ESC>", ":close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "关闭特殊窗口",
    })
  end,
})

-- 终端窗口自动进入插入模式
-- vim.api.nvim_create_autocmd("TermOpen", {
--   desc = "终端窗口自动进入插入模式",
--   group = vim.api.nvim_create_augroup("auto_console_insert_mode", { clear = true }),
--   callback = function()
--     vim.cmd("startinsert")
--     vim.wo.number = false
--     vim.wo.relativenumber = false
--     vim.wo.signcolumn = "no"
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("env_filetype", { clear = true }),
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- Set filetype for .ejs files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("ejs_filetype", { clear = true }),
  pattern = { "*.ejs", "*.ejs.t" },
  callback = function()
    vim.opt_local.filetype = "embedded_template"
  end,
})

-- Set filetype for .code-snippets files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("code_snippets_filetype", { clear = true }),
  pattern = { "*.code-snippets" },
  callback = function()
    vim.opt_local.filetype = "json"
  end,
})
