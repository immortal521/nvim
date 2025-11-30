if vim.g.neovide then
  return
end

vim.pack.add({
  { src = "https://github.com/xiyaowong/transparent.nvim" },
})

require("transparent").setup({})
