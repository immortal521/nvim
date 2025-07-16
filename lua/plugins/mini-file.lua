return {
  "echasnovski/mini.files",
  opts = {
    options = {
      use_as_default_explorer = true,
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("mini.files").open(LazyVim.root(), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>fM",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
  },
}
