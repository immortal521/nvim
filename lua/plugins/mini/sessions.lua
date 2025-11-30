local MiniSessions = require("mini.sessions")

MiniSessions.setup({
  -- Directory where sessions are saved
  directory = vim.fn.stdpath("data") .. "/sessions/",
})
