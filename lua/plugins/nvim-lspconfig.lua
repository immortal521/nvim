return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      cssls = {
        filetypes = { "css", "less", "scss" },
      },
      css_variables = {
        filetypes = { "css", "less", "scss" },
      },
    },
  },
}
