return {
  "mason-org/mason.nvim",
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    ensure_installed = {
      "clang-format",
      "codespell",
      "css-lsp",
      "cssmodules-language-server",
      "css-variables-language-server",
      "goimports",
      "google-java-format",
      "prettier",
      "rustfmt",
      "ruff",
      "stylua",
      "xmlformatter",
    },
  },
}
