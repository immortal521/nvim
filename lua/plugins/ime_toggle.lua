local utils = require("utils")

if not utils.is_win() then
  return
end

vim.pack.add({
  { src = "https://github.com/immortal521/ime_toggle" },
})

require("ime_toggle").setup()
