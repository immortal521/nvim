-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- UI & 导航增强
vim.opt.winbar = "%=%m %f" -- 窗口栏显示修改状态和文件名
vim.opt.scrolloff = 10 -- 光标上下滚动时保持 10 行的偏移量
vim.opt.jumpoptions = "stack" -- 跳转列表行为像栈一样

-- 编辑行为调整
vim.opt.virtualedit = "onemore" -- 允许光标在行尾之外再移动一个字符
vim.opt.wrap = true -- 启用软换行，长行自动折叠显示

-- 功能开关 (全局变量，通常由插件或自定义逻辑使用)
vim.g.autoformat = false -- 禁用全局自动格式化功能
