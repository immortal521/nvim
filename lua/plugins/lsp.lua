vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-lint" },
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
    "json-lsp",
    "js-debug-adapter",
    "lua-language-server",
    "prettier",
    "rustfmt",
    "rust-analyzer",
    "bacon-ls",
    "stylua",
    "vtsls",
    "vue-language-server",
    "gomodifytags",
    "impl",
    "goimports",
    "delve",
  },
})

local keys = {
  { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  {
    "gd",
    "<cmd>lua Snacks.picker.lsp_definitions()<cr>",
    desc = "Goto Definition",
  },
  {
    "gR",
    "<cmd>lua Snacks.picker.lsp_references()<cr>",
    desc = "References",
  },
  { "gI", "<cmd>lua Snacks.picker.lsp_implementations()<cr>", desc = "Goto Implementation" },
  { "gy", "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>", desc = "Goto T[y]pe Definition" },
  { "gD", "<cmd>lua Snacks.picker.lsp_declarations()<cr>", desc = "Goto Declaration" },
  {
    "K",
    function()
      return vim.lsp.buf.hover()
    end,
    desc = "Hover",
  },
  {
    "gK",
    function()
      return vim.lsp.buf.signature_help()
    end,
    desc = "Signature Help",
  },
  {
    "<c-k>",
    function()
      return vim.lsp.buf.signature_help()
    end,
    mode = "i",
    desc = "Signature Help",
  },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
  { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" } },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>cR", "<cmd>lua Snacks.rename.rename_file()", desc = "Rename File" },
  {
    "<leader>ld",
    "<cmd>lua Snacks.picker.diagnostics()<cr>",
    desc = "LSP Open Diagnostic",
  },
  {
    "<leader>co",
    function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      })
    end,
    desc = "Organize Imports",
  },
  { "gai", "<cmd>lua Snacks.picker.lsp_incoming_calls()<cr>", desc = "C[a]lls Incoming" },
  { "gao", "<cmd>lua Snacks.picker.lsp_outgoing_calls()<cr>", desc = "C[a]lls Outgoing" },
  { "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols()<cr>", desc = "LSP Symbols" },
  { "<leader>sS", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>", desc = "LSP Workspace Symbols" },
}

Utils.keymap.add(keys)
