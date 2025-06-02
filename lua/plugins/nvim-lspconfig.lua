return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      cssls = {
        filetypes = { "css", "less", "scss" },
      },
    },
  },
}
