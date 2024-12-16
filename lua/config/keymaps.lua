-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Terminal = require("toggleterm.terminal").Terminal
local musicPlayer = Terminal:new({ cmd = "music-player", hidden = false, id = 9 })

local function _music_player_toggle()
  musicPlayer:toggle(0, "float")
end

vim.keymap.set("n", "<leader>Tm", _music_player_toggle, { noremap = true, silent = true, desc = "Open music-player" })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

require("which-key").add({
  { "<leader>a", mode = "nxv", group = "ai", icon = "" },
  { "<leader>t", mode = "x", group = "test" },
})
