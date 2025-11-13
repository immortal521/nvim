-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- UI & 导航增强
-- vim.opt.winbar = "%=%m %f" -- 窗口栏显示修改状态和文件名
vim.opt.scrolloff = 10 -- 光标上下滚动时保持 10 行的偏移量
vim.opt.jumpoptions = "stack" -- 跳转列表行为像栈一样
vim.opt.textwidth = 80

-- 编辑行为调整
vim.opt.virtualedit = "onemore" -- 允许光标在行尾之外再移动一个字符
vim.opt.wrap = true -- 启用软换行，长行自动折叠显示

-- 功能开关 (全局变量，通常由插件或自定义逻辑使用)
vim.g.autoformat = false -- 禁用全局自动格式化功能

LazyVim.terminal.setup("zsh")
vim.o.shellcmdflag = "-c"
vim.o.shellredir = ">%s 2>&1"
vim.o.shellpipe = "2>&1 | tee %s"
vim.o.shellquote = ""
vim.o.shellxquote = ""

-- Neovide 基础设置
vim.g.neovide_fullscreen = false
vim.g.neovide_hide_mouse_when_typing = true
vim.o.guifont = "Maple Mono NF CN:h14"

-- 性能和显示设置
vim.g.neovide_refresh_rate = 165
vim.g.neovide_refresh_rate_idle = 5

vim.g.neovide_opacity = 0.90

-- 窗口标题栏颜色设置 (与 Neovim 主题保持一致)
-- local normal_hl = vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") })
-- local normal_bg_color = string.format("%x", normal_hl.bg)
-- local normal_fg_color = string.format("%x", normal_hl.fg) -- 获取Normal组的前景色
--
-- vim.g.neovide_title_background_color = normal_bg_color
-- vim.g.neovide_title_text_color = normal_fg_color -- **修改为动态获取Normal组的前景色**

-- 光标动画和特效设置
vim.g.neovide_cursor_animation_length = 0.10
vim.g.neovide_cursor_short_animation_length = 0.02
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_antialiasing = true
