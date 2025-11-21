local wk = require("which-key")

require("grug-far").setup({})

local keys = {
  {
    "<leader>sr",
    function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end,
    mode = { "n", "x" },
    desc = "Search and Replace",
  },
}

wk.add(keys)
