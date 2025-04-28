local tools = require("llm.tools")

return {
  handler = tools.side_by_side_handler,
  opts = {
    left = {
      focusable = false,
    },
  },
}
