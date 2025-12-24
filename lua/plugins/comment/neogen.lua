local Neogen = require("neogen")

Neogen.setup({
  snippet_engine = "luasnip",
})

local keys = {
  {
    "<leader>cn",
    function()
      require("neogen").generate()
    end,
    desc = "Generate Annotations (Neogen)",
  },
}

Utils.keymap.add(keys)
