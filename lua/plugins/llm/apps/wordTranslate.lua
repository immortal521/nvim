local tools = require("llm.tools")
local prompts = require("plugins.llm.prompts")

return {
  handler = tools.flexi_handler,
  prompt = prompts.WordTranslate,
  -- prompt = "Translate the following text to English, please only return the translation",
  opts = {
    win_opts = {
      zindex = 120,
    },
    -- args = [=[return string.format([[curl %s -N -X POST -H "Content-Type: application/json" -H "Authorization: Bearer %s" -d '%s']], url, LLM_KEY, vim.fn.json_encode(body))]=],
    -- args = [[return {url, "-N", "-X", "POST", "-H", "Content-Type: application/json", "-H", authorization, "-d", vim.fn.json_encode(body)}]],
    exit_on_move = true,
    enter_flexible_window = false,
  },
}
