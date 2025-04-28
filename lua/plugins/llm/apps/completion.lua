local tools = require("llm.tools")

if true then
  return {}
end

return {
  handler = tools.completion_handler,
  opts = {
    -------------------------------------------------
    ---                  ollama
    -------------------------------------------------
    -- url = "http://localhost:11434/api/generate",
    url = "http://localhost:11434/v1/completions",
    model = "qwen2.5-coder",
    api_type = "ollama",

    -------------------------------------------------
    ---                 deepseek
    -------------------------------------------------
    -- url = "https://api.deepseek.com/beta/completions",
    -- model = "deepseek-chat",
    -- api_type = "deepseek",
    -- fetch_key = function()
    --   return vim.env.DEEPSEEK_TOKEN
    -- end,

    -------------------------------------------------
    ---                 codeium
    -------------------------------------------------
    -- api_type = "codeium",

    n_completions = 1,
    context_window = 512,
    max_tokens = 256,
    filetypes = {
      sh = false,
      zsh = false,
    },
    default_filetype_enabled = true,
    auto_trigger = true,
    only_trigger_by_keywords = true,
    style = "blink.cmp",
    -- style = "nvim-cmp",
    -- style = "virtual_text",
    keymap = {
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
        toggle = {
          mode = "n",
          keys = "<leader>cp",
        },
      },
    },
  },
}
