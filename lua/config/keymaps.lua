-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

local term_normal = {
  "jk",
  function()
    vim.cmd("stopinsert")
  end,
  mode = "t",
  expr = false,
  desc = "Single escape to normal mode",
}

local win = {
  position = "float",
  border = "rounded",
  keys = {
    term_normal = term_normal,
  },
}

map("n", "<leader>tf", function()
  Snacks.terminal(nil, { win = win })
end, { desc = "Terminal Float" })

map("n", "<leader>tm", function()
  Snacks.terminal("music-player", { win = win })
end, { desc = "Music Player" })

require("which-key").add({
  { "<leader>a", mode = "nxv", group = "ai", icon = "" },
  { "<leader>t", mode = "n", group = "terminal", icon = "" },
  { "<leader>o", mode = "n", group = "overseer", icon = "" },
})
