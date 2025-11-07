local wk = require("which-key")

vim.pack.add({
  { src = "https://github.com/folke/persistence.nvim" },
})

require("persistence").setup({})

keys = {
  {
    "<leader>qs",
    function()
      require("persistence").load()
    end,
    mode = "n",
    desc = "Restore Session",
  },

  {
    "<leader>qS",
    function()
      require("persistence").select()
    end,
    mode = "n",
    desc = "Select Session",
  },

  {
    "<leader>ql",
    function()
      require("persistence").load({ last = true })
    end,
    mode = "n",
    desc = "Restore Last Session",
  },

  {
    "<leader>qd",
    function()
      require("persistence").stop()
    end,
    mode = "n",
    desc = "Don't Save Current Session",
  },
}

wk.add(keys)
