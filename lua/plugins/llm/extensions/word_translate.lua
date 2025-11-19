local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")

return {
  handler = tools.flexi_handler,
  prompt = prompts.WordTranslate,
  -- prompt = "Translate the following text to English, please only return the translation",
  opts = {
    win_opts = {
      zindex = 120,
    },
    exit_on_move = false,
    enter_flexible_window = true,
    enable_cword_context = true,
  },
}
