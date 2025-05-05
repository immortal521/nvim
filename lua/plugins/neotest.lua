return {
  "nvim-neotest/neotest",
  keys = function()
    return {

      { "<leader>T", "", desc = "+test" },
      {
        "<leader>Tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File (eotest)",
      },
      {
        "<leader>TT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files (Neotest)",
      },
      {
        "<leader>Tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest (Neotest)",
      },
      {
        "<leader>Tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last (Neotest)",
      },
      {
        "<leader>Ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary (Neotest)",
      },
      {
        "<leader>To",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output (Neotest)",
      },
      {
        "<leader>TO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel (Neotest)",
      },
      {
        "<leader>TS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop (Neotest)",
      },
      {
        "<leader>Tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch (Neotest)",
      },
    }
  end,
}
