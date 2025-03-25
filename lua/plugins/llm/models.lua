local utils = require("plugins.llm.utils")
return {
  Ollama = {
    url = "http://localhost:11434/api/chat",
    model = "qwen2.5-coder",
    api_type = "ollama",
    fetch_key = function()
      return ""
    end,
    streaming_handler = utils.local_llm_streaming_handler,
    parse_handler = utils.local_llm_parse_handler,
  },
  -- LocalLLM = {
  --   url = "http://localhost:11434/api/chat",
  --   model = "qwen:0.5b",
  --   api_type = "ollama",
  --   fetch_key = function()
  --     return vim.env.LOCAL_LLM_KEY
  --   end,
  --   streaming_handler = utils.local_llm_streaming_handler,
  --   parse_handler = utils.local_llm_parse_handler,
  -- },
  -- GithubModels = {
  --   url = "https://models.inference.ai.azure.com/chat/completions",
  --   model = "gpt-4o",
  --   api_type = "openai",
  --   -- max_tokens = 4096,
  --   max_tokens = 8000,
  --   -- model = "gpt-4o-mini",
  --   fetch_key = function()
  --     return vim.env.GITHUB_TOKEN
  --   end,
  -- },
  -- DeepSeek = {
  --   url = "https://api.deepseek.com/chat/completions",
  --   model = "deepseek-chat",
  --   api_type = "openai",
  --   max_tokens = 8000,
  --   fetch_key = function()
  --     return vim.env.DEEPSEEK_TOKEN
  --   end,
  -- },
  -- SiliconFlow = {
  --   url = "https://api.siliconflow.cn/v1/chat/completions",
  --   -- model = "THUDM/glm-4-9b-chat",
  --   api_type = "openai",
  --   max_tokens = 4096,
  --   -- model = "01-ai/Yi-1.5-9B-Chat-16K",
  --   -- model = "google/gemma-2-9b-it",
  --   -- model = "meta-llama/Meta-Llama-3.1-8B-Instruct",
  --   model = "Qwen/Qwen2.5-7B-Instruct",
  --   -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
  --   -- model = "internlm/internlm2_5-7b-chat",
  --   fetch_key = function()
  --     return vim.env.SILICONFLOW_TOKEN
  --   end,
  -- },
  -- Chatanywhere = {
  --   fetch_key = function()
  --     return vim.env.CHAT_ANYWHERE_KEY
  --   end,
  --   url = "https://api.chatanywhere.tech/v1/chat/completions",
  --   model = "gpt-4o-mini",
  --   api_type = "openai",
  -- },
  -- Cloudflare = {
  --   -- model = "@cf/qwen/qwen1.5-14b-chat-awq",
  --   model = "@cf/google/gemma-7b-it-lora",
  --   api_type = "workers-ai",
  --   max_tokens = 1024,
  --   fetch_key = function()
  --     return vim.env.WORKERS_AI_KEY
  --   end,
  -- },
  -- OpenRouter = {
  --   url = "https://openrouter.ai/api/v1/chat/completions",
  --   model = "google/gemini-2.0-flash-exp:free",
  --   max_tokens = 8000,
  --   api_type = "openai",
  --   fetch_key = function()
  --     return vim.env.OPENROUTER_KEY
  --   end,
  -- },
  -- GLM = {
  --   url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
  --   model = "glm-4-flash",
  --   max_tokens = 8000,
  --   fetch_key = function()
  --     return vim.env.GLM_KEY
  --   end,
  -- },
  -- Kimi = {
  --   url = "https://api.moonshot.cn/v1/chat/completions",
  --   model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
  --   api_type = "openai",
  --   max_tokens = 4096,
  --   fetch_key = function()
  --     return vim.env.KIMI_KEY
  --   end,
  -- },
}
