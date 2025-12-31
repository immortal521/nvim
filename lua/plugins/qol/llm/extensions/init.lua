return {
	app_handler = {
		Ask = require("plugins.qol.llm.extensions.ask"),
		AttachToChat = require("plugins.qol.llm.extensions.attach_to_chat"),
		BashRunner = require("plugins.qol.llm.extensions.bash_runner"),
		CodeExplain = require("plugins.qol.llm.extensions.code_explain"),
		CommitMsg = require("plugins.qol.llm.extensions.commit_msg"),
		-- Completion = require("plugins..qol.llm.extensions.completion"),
		DocString = require("plugins.qol.llm.extensions.docstring"),
		FormulaRecognition = require("plugins.qol.llm.extensions.formula_recognition"),
		OptimCompare = require("plugins.qol.llm.extensions.optim_compare"),
		OptimizeCode = require("plugins.qol.llm.extensions.optimize_code"),
		TestCode = require("plugins.qol.llm.extensions.test_code"),
		Translate = require("plugins.qol.llm.extensions.translate"),
		UserInfo = require("plugins.qol.llm.extensions.user_info"),
		WordTranslate = require("plugins.qol.llm.extensions.word_translate"),
	},
}
