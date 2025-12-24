vim.pack.add({
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})

require("tiny-inline-diagnostic").setup({
  options = {
    show_source = {
      enabled = true,
    },
  },
})
vim.diagnostic.config({ virtual_text = false })
