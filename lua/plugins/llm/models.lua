local utils = require("plugins.llm.utils")
return {
  Ollama = {
    name = "Ollama",
    url = "http://localhost:11434/api/chat",
    model = "qwen2.5-coder",
    api_type = "ollama",
    fetch_key = function()
      return ""
    end,
    temperature = 0.3,
    enable_thinking = true,
    top_p = 0.7,
    streaming_handler = utils.local_llm_streaming_handler,
    parse_handler = utils.local_llm_parse_handler,
  },
  Cloudflare = {
    -- model = "@cf/qwen/qwen1.5-14b-chat-awq",
    name = "Cloudflare",
    model = "@cf/google/gemma-7b-it-lora",
    api_type = "workers-ai",
    fetch_key = function()
      return vim.env.WORKERS_AI_KEY
    end,
    max_tokens = 1024,
    temperature = 0.3,
    top_p = 0.7,
  },
  OpenRouter = {
    name = "OpenRouter",
    url = "https://openrouter.ai/api/v1/chat/completions",
    -- model = "openai/gpt-oss-120b:free",
    model = "moonshotai/kimi-dev-72b:free",
    max_tokens = 8000,
    api_type = "openai",
    fetch_key = function()
      return vim.env.OpenRouter
    end,
    temperature = 0.3,
    top_p = 0.7,
  },
  GLM = {
    name = "GLM",
    url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model = "glm-4-flash",
    max_tokens = 8000,
    fetch_key = function()
      return vim.env.GLM_KEY
    end,
    temperature = 0.3,
    top_p = 0.7,
  },
  Kimi = {
    name = "Kimi",
    url = "https://api.moonshot.cn/v1/chat/completions",
    model = "moonshot-v1-8k", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
    api_type = "openai",
    max_tokens = 4096,
    fetch_key = function()
      return vim.env.KIMI_KEY
    end,
    temperature = 0.3,
    top_p = 0.7,
  },
  LocalLLM = {
    name = "LocalLLM",
    url = "http://localhost:11434/api/chat",
    model = "qwen:0.5b",
    api_type = "ollama",
    fetch_key = function()
      return vim.env.LOCAL_LLM_KEY
    end,
    streaming_handler = utils.local_llm_streaming_handler,
    parse_handler = utils.local_llm_parse_handler,
    temperature = 0.3,
    top_p = 0.7,
  },
  GithubModels = {
    name = "GithubModels",
    url = "https://models.inference.ai.azure.com/chat/completions",
    -- model = "gpt-4o",
    model = "gpt-4o-mini",
    api_type = "openai",
    -- max_tokens = 4096,
    max_tokens = 8000,
    -- model = "gpt-4o-mini",
    fetch_key = function()
      return vim.env.GITHUB_TOKEN
    end,
    temperature = 0.3,
    top_p = 0.7,
  },
  DeepSeek = {
    name = "DeepSeek",
    url = "https://api.deepseek.com/chat/completions",
    model = "deepseek-chat",
    api_type = "openai",
    max_tokens = 8000,
    fetch_key = function()
      return vim.env.DEEPSEEK_TOKEN
    end,
    temperature = 0.3,
    top_p = 0.7,
  },
  SiliconFlow = {
    name = "SiliconFlow",
    url = "https://api.siliconflow.cn/v1/chat/completions",
    -- model = "THUDM/glm-4-9b-chat",
    api_type = "openai",
    max_tokens = 4096,
    -- model = "01-ai/Yi-1.5-9B-Chat-16K",
    -- model = "google/gemma-2-9b-it",
    -- model = "meta-llama/Meta-Llama-3.1-8B-Instruct",
    model = "Qwen/Qwen2.5-7B-Instruct",
    -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
    -- model = "internlm/internlm2_5-7b-chat",
    fetch_key = function()
      return vim.env.SILICONFLOW_TOKEN
    end,
    temperature = 0.3,
    top_p = 0.7,
  },
  Chatanywhere = {
    name = "Chatanywhere",
    fetch_key = function()
      return vim.env.CHAT_ANYWHERE_KEY
    end,
    url = "https://api.chatanywhere.tech/v1/chat/completions",
    model = "gpt-4o-mini",
    -- model = "gpt-4o",
    api_type = "openai",
    -- max_tokens = 4096,
    -- temperature = 0.3,
    -- top_p = 0.7,
  },
}
