vim.pack.add({
  { src = "https://github.com/folke/persistence.nvim" },
})

require("persistence").setup({})

-- 加载 session 前同样删除 Oil buffer，避免恢复
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceLoadPost",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local ft = vim.bo[buf].filetype
      local name = vim.api.nvim_buf_get_name(buf)
      if ft == "oil" or name:match("oil") then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})

local keys = {
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

Utils.keymap.add(keys)
