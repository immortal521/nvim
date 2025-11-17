local wk = require("which-key")

require("flash").setup({})

local keys = {
  {
    "s",
    function()
      require("flash").jump()
    end,
    mode = { "n", "x", "o" },
    desc = "Flash",
  },
  {
    "S",
    function()
      require("flash").treesitter()
    end,
    mode = { "n", "x", "o" },
    desc = "Flash Treesitter",
  },
  {
    "r",
    function()
      require("flash").remote()
    end,
    mode = "o",
    desc = "Remote Flash",
  },
  {
    "R",
    function()
      require("flash").treesitter_search()
    end,
    mode = { "x", "o" },
    desc = "Treesitter Search",
  },
  {
    "<c-s>",
    function()
      require("flash").toggle()
    end,
    mode = "c",
    desc = "Toggle Flash",
  },
  {
    "<c-space>",
    function()
      require("flash").treesitter({
        actions = {
          ["<c-space>"] = "next",
          ["<BS>"] = "prev",
        },
      })
    end,
    mode = { "n", "x", "o" },
    desc = "Treesitter Incremental Selection",
  },
}

wk.add(keys)
