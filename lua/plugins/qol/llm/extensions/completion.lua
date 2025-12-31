local tools = require("llm.tools")

return {
  handler = tools.completion_handler,
  opts = {
    -------------------------------------------------
    ---                  ollama
    -------------------------------------------------
    -- url = "http://localhost:11434/api/generate",
    -- url = "http://localhost:11434/v1/completions",
    -- model = "qwen2.5-coder:1.5b",
    -- api_type = "ollama",

    -------------------------------------------------
    ---                 deepseek
    -------------------------------------------------
    -- url = "https://api.deepseek.com/beta/completions",
    -- model = "deepseek-chat",
    -- api_type = "deepseek",
    -- fetch_key = vim.env.DEEPSEEK_TOKEN,

    -------------------------------------------------
    ---   openrouter
    -------------------------------------------------
    -- url = "https://openrouter.ai/api/v1/completions",
    -- model = "deepseek/deepseek-chat-v3-0324",
    -- api_type = "deepseek",
    -- fetch_key = vim.env.OPENROUTER_KEY,

    -------------------------------------------------
    ---                 siliconflow
    -------------------------------------------------
    -- url = "https://api.siliconflow.cn/v1/completions",
    -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
    -- api_type = "openai",
    -- fetch_key = vim.env.SILICONFLOW_TOKEN,

    -------------------------------------------------
    ---                 lmstudio
    -------------------------------------------------
    -- url = "http://localhost:1234/api/v0/completions",
    -- model = "santacoder-1b",
    -- api_type = "lmstudio",
    -- fetch_key = vim.env.SILICONFLOW_TOKEN,
    -------------------------------------------------
    ---                 codeium
    -------------------------------------------------
    api_type = "codeium",

    n_completions = 2,
    context_window = 16000,
    max_tokens = 4096,
    keep_alive = -1,
    filetypes = {
      sh = false,
      zsh = false,
      llm = false,
    },
    timeout = 10,
    default_filetype_enabled = true,
    auto_trigger = true,
    only_trigger_by_keywords = true,
    style = "blink.cmp",
    -- style = "nvim-cmp",
    -- style = "virtual_text",

    keymap = {
      toggle = {
        mode = "n",
        keys = "<leader>cp",
      },
      virtual_text = {
        accept = {
          mode = "i",
          keys = "<A-a>",
        },
        next = {
          mode = "i",
          keys = "<A-n>",
        },
        prev = {
          mode = "i",
          keys = "<A-p>",
        },
      },
    },
  },
}
