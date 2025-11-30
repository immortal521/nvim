vim.pack.add({
  { src = "https://github.com/rcarriga/nvim-notify" },
})

local colors = Utils.colors()

local highlights = {
  { "NotifyERRORBorder", colors.red },
  { "NotifyWARNBorder", colors.yellow },
  { "NotifyINFOBorder", colors.blue },
  { "NotifyDEBUGBorder", colors.magenta },
  { "NotifyTRACEBorder", colors.cyan },

  { "NotifyERRORIcon", colors.red },
  { "NotifyWARNIcon", colors.yellow },
  { "NotifyINFOIcon", colors.blue },
  { "NotifyDEBUGIcon", colors.magenta },
  { "NotifyTRACEIcon", colors.cyan },

  { "NotifyERRORTitle", colors.red },
  { "NotifyWARNTitle", colors.yellow },
  { "NotifyINFOTitle", colors.blue },
  { "NotifyDEBUGTitle", colors.magenta },
  { "NotifyTRACETitle", colors.cyan },
}

for _, hl in ipairs(highlights) do
  vim.api.nvim_set_hl(0, hl[1], { fg = hl[2] })
end

local body_highlights = { "NotifyERRORBody", "NotifyWARNBody", "NotifyINFOBody", "NotifyDEBUGBody", "NotifyTRACEBody" }

for _, hl in ipairs(body_highlights) do
  vim.api.nvim_set_hl(0, hl, { link = "Normal" })
end

require("notify").setup({
  fps = 60,
  max_width = 80,
  max_height = 30,
  stages = "fade_in_slide_out",
  timeout = 3000,
  top_down = true,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

vim.notify = require("notify")
