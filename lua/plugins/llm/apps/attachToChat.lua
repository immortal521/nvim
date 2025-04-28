local tools = require("llm.tools")

return {
  handler = tools.attach_to_chat_handler,
  opts = {
    is_codeblock = true,
    inline_assistant = true,
    language = "Chinese",
  },
}
