local utils = require("utils")

if not utils.is_win() then
  return
end

require("ime_toggle").setup()
