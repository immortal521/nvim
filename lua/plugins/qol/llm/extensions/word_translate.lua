local prompts = require("plugins.qol.llm.prompts")
local tools = require("llm.tools")

return {
	handler = tools.flexi_handler,
	prompt = prompts.WordTranslate,
	opts = {
		win_opts = {
			zindex = 120,
		},
		exit_on_move = false,
		enter_flexible_window = true,
		enable_cword_context = true,
	},
}
