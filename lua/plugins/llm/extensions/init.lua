return {
  app_handler = {
    Ask = require("plugins.llm.extensions.ask"),
    AttachToChat = require("plugins.llm.extensions.attach_to_chat"),
    BashRunner = require("plugins.llm.extensions.bash_runner"),
    CodeExplain = require("plugins.llm.extensions.code_explain"),
    CommitMsg = require("plugins.llm.extensions.commit_msg"),
    Completion = require("plugins.llm.extensions.completion"),
    DocString = require("plugins.llm.extensions.docstring"),
    FormulaRecognition = require("plugins.llm.extensions.formula_recognition"),
    OptimCompare = require("plugins.llm.extensions.optim_compare"),
    OptimizeCode = require("plugins.llm.extensions.optimize_code"),
    TestCode = require("plugins.llm.extensions.test_code"),
    Translate = require("plugins.llm.extensions.translate"),
    UserInfo = require("plugins.llm.extensions.user_info"),
    WordTranslate = require("plugins.llm.extensions.word_translate"),
  },
}
