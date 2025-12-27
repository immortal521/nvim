vim.api.nvim_create_autocmd(Utils.autocmd.BufEdit, {
  once = true,
  callback = function()
    require("nvim-highlight-colors").setup({
      render = "background",
    })
  end,
})
