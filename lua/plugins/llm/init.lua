local wk = require("which-key")
local models = require("plugins.llm.models")
local keymaps = require("plugins.llm.keymaps")
local ui = require("plugins.llm.ui")
local api, tbl_deep_extend, env = vim.api, vim.tbl_deep_extend, vim.env

vim.pack.add({
  { src = "https://github.com/Kurama622/llm.nvim" },
})

api.nvim_set_hl(0, "LlmCmds", { link = "String" })
local extensions = require("plugins.llm.extensions")
local opts = {
  prompt = "You are a helpful chinese assistant.",
  enable_trace = false,

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

  web_search = {
    url = "https://api.tavily.com/search",
    fetch_key = env.TAVILY_TOKEN,
    params = {
      auto_parameters = false,
      topic = "general",
      search_depth = "basic",
      chunks_per_source = 3,
      max_results = 3,
      include_answer = true,
      include_raw_content = true,
      include_images = false,
      include_image_descriptions = false,
      include_favicon = false,
    },
  },

  save_session = true,
  max_history = 15,
  max_history_name_length = 20,
  history_path = vim.fn.stdpath("cache") .. "/llm-history",

  models = {
    models.GithubModels,
    models.Chatanywhere,
    models.SiliconFlow,
    models.GLM,
    models.DeepSeek,
    models.Ollama,
    models.Kimi,
    models.Cloudflare,
  },
}
for _, conf in pairs({ ui, extensions, keymaps }) do
  opts = tbl_deep_extend("force", opts, conf)
end

require("llm").setup(opts)

-- stylua: ignore
local keys = {
  { "<leader>a", group="ai" },
  { "<leader>ac", "<cmd>LLMSessionToggle<cr>", mode = "n", desc = "Toggle LLM Chat" },
  { "<leader>aa", "<cmd>LLMAppHandler AttachToChat<cr>", mode = { "v", "n" }, desc = "Ask LLM (multi-turn)" },
  { "<leader>ak", "<cmd>LLMAppHandler Ask<cr>", mode = { "v", "n" }, desc = "Ask LLM" },
  { "<leader>ae", "<cmd>LLMAppHandler CodeExplain<cr>", mode = { "n", "v" }, desc = "Explain the Code" },
  { "<leader>aw", "<cmd>LLMAppHandler WordTranslate<cr>", mode = { "x", "n" }, desc = "Word Translate" },
  { "<leader>at", "<cmd>LLMAppHandler Translate<cr>", mode = "n", desc = "AI Translator" },
  { "<leader>aT", "<cmd>LLMAppHandler TestCode<cr>", mode = "x", desc = "Generate Test Cases" },
  { "<leader>ao", "<cmd>LLMAppHandler OptimCompare<cr>", mode = "x", desc = "Optimize the Code" },
  { "<leader>ag", "<cmd>LLMAppHandler CommitMsg<cr>", mode = "n", desc = "Generate AI Commit Message" },
  { "<leader>ad", "<cmd>LLMAppHandler DocString<cr>", mode = "v", desc = "Generate a Docstring" },
  { "<leader>au", "<cmd>LLMAppHandler UserInfo<cr>", mode = "n", desc = "Check Account Information" },
  { "<leader>ab", "<cmd>LLMAppHandler BashRunner<cr>", mode = { "v", "n" }, desc = "bash runner" },
  { "<leader>ai", "<cmd>LLMAppHandler FormulaRecognition<cr>", mode = { "v", "n" }, desc = "formula recognition" },

  -- 未启用快捷键
  -- { "<leader>ae", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>", mode = "v", desc = "Code Explain" },
  -- { "<leader>ao", "<cmd>LLMAppHandler OptimizeCode<cr>", mode = "x", desc = "Optimize" },
  -- { "<leader>at", "<cmd>LLMSelectedTextHandler 英译汉<cr>", mode = "x", desc = "Translate" },
}

wk.add(keys)
