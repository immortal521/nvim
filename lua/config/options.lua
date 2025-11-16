local utils = require("utils")
local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = "\\"

if utils.is_win() then
  utils.terminal("nu")
else
  utils.terminal("zsh")
end

opt.autowrite = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = false
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "stack"
opt.textwidth = 80
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 10
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.virtualedit = "onemore"
opt.linebreak = true
opt.breakindent = true
opt.numberwidth = 4

g.have_nerd_font = true

vim.o.winborder = "single"

-- Neovide 基础设置
g.neovide_fullscreen = false
g.neovide_hide_mouse_when_typing = true
vim.o.guifont = "Maple Mono NF CN:h14"

-- 性能和显示设置
g.neovide_refresh_rate = 165
g.neovide_refresh_rate_idle = 5

g.neovide_opacity = 0.90

-- 光标动画和特效设置
g.neovide_cursor_animation_length = 0.10
g.neovide_cursor_short_animation_length = 0.02
g.neovide_cursor_trail_size = 0.5
g.neovide_cursor_vfx_mode = "pixiedust"
g.neovide_cursor_antialiasing = true
