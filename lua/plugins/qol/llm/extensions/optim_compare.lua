local tools = require("llm.tools")

return {
  handler = tools.action_handler,
  opts = {
    fetch_key = vim.env.GITHUB_TOKEN,
    url = "https://models.inference.ai.azure.com/chat/completions",
    model = "gpt-4o-mini",
    api_type = "openai",
    language = "Chinese",
  },
}
