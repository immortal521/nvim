local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")

return {
  prompt = prompts.DocString,
  handler = tools.action_handler,
  opts = {
    fetch_key = vim.env.GITHUB_TOKEN,
    url = "https://models.inference.ai.azure.com/chat/completions",
    model = "gpt-4o-mini",
    api_type = "openai",
    only_display_diff = true,
    templates = {
      lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".]],
      python = [[- For the python language, you should use the numpy style.]],
    },
  },
}
