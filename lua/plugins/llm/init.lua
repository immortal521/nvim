local map = require("utils").map
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

-- 设置快捷键映射
map("n", "<leader>ac", "<cmd>LLMSessionToggle<cr>", { desc = "Toggle LLM Chat" })
map({ "v", "n" }, "<leader>aa", "<cmd>LLMAppHandler AttachToChat<cr>", { desc = "Ask LLM (multi-turn)" })
map({ "v", "n" }, "<leader>ak", "<cmd>LLMAppHandler Ask<cr>", { desc = "Ask LLM" })
map({ "n", "v" }, "<leader>ae", "<cmd>LLMAppHandler CodeExplain<cr>", { desc = "Explain the Code" })
map({ "x", "n" }, "<leader>aw", "<cmd>LLMAppHandler WordTranslate<cr>", { desc = "Word Translate" })
map("n", "<leader>at", "<cmd>LLMAppHandler Translate<cr>", { desc = "AI Translator" })
map("x", "<leader>aT", "<cmd>LLMAppHandler TestCode<cr>", { desc = "Generate Test Cases" })
map("x", "<leader>ao", "<cmd>LLMAppHandler OptimCompare<cr>", { desc = "Optimize the Code" })
map("n", "<leader>ag", "<cmd>LLMAppHandler CommitMsg<cr>", { desc = "Generate AI Commit Message" })
map("v", "<leader>ad", "<cmd>LLMAppHandler DocString<cr>", { desc = "Generate a Docstring" })
map("n", "<leader>au", "<cmd>LLMAppHandler UserInfo<cr>", { desc = "Check Account Information" })
map({ "v", "n" }, "<leader>ab", "<cmd>LLMAppHandler BashRunner<cr>", { desc = "bash runner" })
map({ "v", "n" }, "<leader>ai", "<cmd>LLMAppHandler FormulaRecognition<cr>", { desc = "formula recognition" })

-- 未启用快捷键
-- map("v", "<leader>ae", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>", { desc = "Code Explain" })
-- map("x", "<leader>ao", "<cmd>LLMAppHandler OptimizeCode<cr>", { desc = "Optimize" })
-- map("x", "<leader>at", "<cmd>LLMSelectedTextHandler 英译汉<cr>", { desc = "Translate" })
