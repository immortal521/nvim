local models = require("plugins.llm.models")
local keymaps = require("plugins.llm.keymaps")
local ui = require("plugins.llm.ui")

return {
  "Kurama622/llm.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
  config = function()
    local apps = require("plugins.llm.apps.handler")

    local opts = {
      prompt = "You are a helpful chinese assistant.",
      temperature = 0.3,
      top_p = 0.7,

      spinner = {
        text = { "󰧞󰧞", "󰧞󰧞", "󰧞󰧞", "󰧞󰧞" },
        hl = "Title",
      },

      prefix = {
        user = { text = " ", hl = "Title" },
        assistant = { text = " ", hl = "Added" },
      },

      display = {
        diff = {
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },

      save_session = true,
      max_history = 15,
      max_history_name_length = 20,
      history_path = vim.fn.stdpath("cache") .. "/llm-history",

      models = {
        models.Ollama,
      },
    }

    for _, conf in pairs({ ui, apps, keymaps }) do
      opts = vim.tbl_deep_extend("force", opts, conf)
    end

    require("llm").setup(opts)
  end,
  keys = {
    { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = "Start Chat" },

    { "<leader>ac", mode = "v", "<cmd>LLMAppHandler Ask<cr>", desc = "Start Chat" },
    { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>", desc = "Code Explain" },
    { "<leader>at", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>", desc = "Translate" },
    { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>", desc = "Translation Window" },
    { "<leader>aT", mode = "x", "<cmd>LLMAppHandler TestCode<cr>", desc = "Generate Test Code" },
    { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimCompare<cr>", desc = "Optimize Code" },
    { "<leader>ag", mode = "n", "<cmd>LLMAppHandler CommitMsg<cr>", desc = "Generate Git Message" },
    { "<leader>ad", mode = "v", "<cmd>LLMAppHandler DocString<cr>", desc = "Generate Document" },
    -- { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>", desc = "Code Explain" },
    -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>", desc = "Optimize" },
    -- { "<leader>at", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>", desc = "Translate" },
  },
}
