vim.pack.add({
  { src = "https://github.com/folke/todo-comments.nvim" },
})

require("todo-comments").setup({})

local keys = {
  {
    "]t",
    function()
      require("todo-comments").jump_next()
    end,
    mode = "n",
    desc = "Next Todo Comment",
  },

  {
    "[t",
    function()
      require("todo-comments").jump_prev()
    end,
    mode = "n",
    desc = "Previous Todo Comment",
  },

  { "<leader>xt", "<cmd>Trouble todo toggle<cr>", mode = "n", desc = "Todo (Trouble)" },
  {
    "<leader>xT",
    "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
    mode = "n",
    desc = "Todo/Fix/Fixme (Trouble)",
  },
  { "<leader>st", "<cmd>TodoTelescope<cr>", mode = "n", desc = "Todo" },
  { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", mode = "n", desc = "Todo/Fix/Fixme" },
}

Utils.keymap.add(keys)
