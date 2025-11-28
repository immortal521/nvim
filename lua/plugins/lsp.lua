local wk = require("which-key")

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
  {
    "<leader>cl",
    function()
      Snacks.picker.lsp_config()
    end,
    desc = "Lsp Info",
  },
  { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "Goto Definition",
  },
  {
    "gr",
    function()
      Snacks.picker.lsp_references()
    end,
    desc = "References",
  },
  { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
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
  {
    "<leader>cR",
    function()
      Snacks.rename.rename_file()
    end,
    desc = "Rename File",
    mode = { "n" },
  },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },

  {
    "]]",
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    desc = "Next Reference",
  },
  {
    "[[",
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = "Prev Reference",
  },
  {
    "<a-n>",
    function()
      Snacks.words.jump(vim.v.count1, true)
    end,
    desc = "Next Reference",
  },
  {
    "<a-p>",
    function()
      Snacks.words.jump(-vim.v.count1, true)
    end,
    desc = "Prev Reference",
  },
  { "<leader>l", group = "lsp" },
  {
    "<leader>ld",
    function()
      vim.diagnostic.open_float({ source = true })
    end,
    desc = "LSP Open Diagnostic",
  },
}

wk.add(keys)
