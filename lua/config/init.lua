-- leader key
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

_G.Utils = require("utils")
_G.Config = {}

local colorschemes = "tokyonight"

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lsp")
require("config.bootstrap")
require("config.events").setup()
require('config.pack').setup()
require("config.colorschemes").setup(colorschemes)
