require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

local keys = {
  { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
}

Utils.keymap.add(keys)
