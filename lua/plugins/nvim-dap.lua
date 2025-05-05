return {
  "mfussenegger/nvim-dap",
  keys = function()
    return {
      -- stylua: ignore
      {
        "<leader>Td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
      },
    }
  end,
}
