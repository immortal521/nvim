local handlers_path = "plugins.llm.apps"

local handlers = {
  Ask = "ask",
  AttachToChat = "attachToChat",
  CodeExplain = "codeExplain",
  CommitMsg = "commitMsg",
  DocString = "docString",
  OptimCompare = "optimCompare",
  OptimizeCode = "optimize",
  TestCode = "testCode",
  Translate = "translate",
  WordTranslate = "wordTranslate",
}

local app_handler = {}

for key, file in pairs(handlers) do
  local ok, handler = pcall(require, handlers_path .. "." .. file)
  if ok then
    app_handler[key] = handler
  else
    vim.notify("Failed to load handler" .. file, vim.log.levels.ERROR)
  end
end

return {
  app_handler = app_handler,
}
