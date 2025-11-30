vim.pack.add({
  { src = "https://github.com/stevearc/overseer.nvim" },
})

local overseer = require("overseer")

local opts = {
  template_timeout = 8000,
  templates = { -- Templated defined inside ~/.config/nvim/lua/overseer/template
    "builtin",
    "condor",
    "python",
    "grun_option",
    "run_script",
  },
  component_aliases = {
    default = {
      { "display_duration", detail_level = 1 },
      "on_output_summarize",
      "on_exit_set_status",
      "on_complete_notify",
    },
    default_vscode = {
      "default",
      "display_duration",
      "task_list_on_start",
      "on_output_quickfix",
      "unique",
    },
  },
  task_list = {
    direction = "right",
    bindings = {
      ["o"] = false,
      ["+"] = "IncreaseDetail",
      ["_"] = "DecreaseDetail",
      ["="] = "IncreaseAllDetail",
      ["-"] = "DecreaseAllDetail",
      ["k"] = "PrevTask",
      ["j"] = "NextTask",
      ["t"] = "<CMD>OverseerQuickAction open tab<CR>",
      ["<C-u>"] = false,
      ["<C-d>"] = false,
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
    },
  },
}

-- stylua: ignore
local keys = {
  { "<leader>ow", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
  { "<leader>oo", "<cmd>OverseerRun<cr>",         desc = "Run task" },
  { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
  { "<leader>oi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
  { "<leader>ob", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
  { "<leader>ot", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
  { "<leader>oc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
}

overseer.setup(opts)
Utils.keymap.add(keys)
