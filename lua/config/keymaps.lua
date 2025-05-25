-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

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
  -- vim.api.nvim_feedkeys("9" .. vim.api.nvim_replace_termcodes("<leader>tm", true, false, true), "n", false)
  Snacks.terminal("music-player", { win = win })
end, { desc = "Music Player", silent = true, noremap = true })

map("n", "<leader>ts", function()
  Snacks.picker.buffers({
    hidden = true,
    filter = {
      filter = function(item, filter)
        if filter(item) and item.file:sub(1, 4) == "term" then
          return true
        end
        return false
      end,
    },
  })
end, { desc = "terminal find" })

require("which-key").add({
  { "<leader>a", mode = "nxv", group = "ai", icon = "" },
  { "<leader>t", mode = "n", group = "terminal", icon = "" },
  { "<leader>o", mode = "n", group = "overseer", icon = "" },
})
