return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    spec = {
      { "<leader>o", mode = "n", group = "overseer", icon = "" },
      { "<leader>K", mode = "n", desc = "Keywordprg", icon = "" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
