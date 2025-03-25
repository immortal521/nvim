local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")

return {
  prompt = prompts.DocString,
  handler = tools.action_handler,
  opts = {
    only_display_diff = true,
    templates = {
      lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".
]],
    },
  },
}
