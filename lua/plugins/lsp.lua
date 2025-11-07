local map = require("utils").map

vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  ensure_installed = {
    "css-lsp",
    "css-variables-language-server",
    "cssmodules-language-server",
    "gofumpt",
    "golangci-lint",
    "gopls",
    "js-debug-adapter",
    "lua-language-server",
    "prettier",
    "rustfmt",
    "stylua",
    "vtsls",
    "vue-language-server",
  },
})

map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
