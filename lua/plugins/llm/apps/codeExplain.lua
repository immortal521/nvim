local tools = require("llm.tools")
local prompts = require("plugins.llm.prompts")

return {
  handler = tools.flexi_handler,
  prompt = prompts.CodeExplain,
  opts = {
    enter_flexible_window = true,
  },
}
