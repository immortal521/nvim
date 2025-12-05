vim.pack.add({
  { src = "https://github.com/stevearc/overseer.nvim", version = vim.version.range(">=2.0.0") },
})

local overseer = require("overseer")

local opts = {
  template_dirs = {
    vim.fn.stdpath("config") .. "/lua/plugins/overseer/template",
  },
  template_timeout = 8000,
  templates = {
    "builtin",
  },
  task_list = {
    direction = "bottom",
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
