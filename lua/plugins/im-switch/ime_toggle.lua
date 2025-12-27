vim.pack.add({
  { src = "https://github.com/immortal521/ime_toggle" },
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("ime_toggle").setup()
  end,
})
