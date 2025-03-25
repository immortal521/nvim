local tools = require("llm.tools")
local prompts = require("plugins.llm.prompts")

return {
  handler = tools.side_by_side_handler,
  prompt = prompts.TestCode,
  opts = {
    right = {
      title = " Test Cases ",
    },
  },
}
