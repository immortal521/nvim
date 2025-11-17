require("mini.icons").setup({
  style = "glyph",
  file = {
    README = { glyph = "󰆈", hl = "MiniIconsYellow" },
    ["README.md"] = { glyph = "󰆈", hl = "MiniIconsYellow" },
    [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
    [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
    [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
    [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
    ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
    ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
    ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
    ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
    ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
    [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
  },
  filetype = {
    dotenv = { glyph = "", hl = "MiniIconsYellow" },
    bash = { glyph = "󱆃", hl = "MiniIconsGreen" },
    sh = { glyph = "󱆃", hl = "MiniIconsGrey" },
    toml = { glyph = "󱄽", hl = "MiniIconsOrange" },
    gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
  },
})

require("mini.ai").setup({
  mappings = {
    goto_left = "[",
    got_right = "]",
  },
})

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = {
      add = "▎",
      change = "▎",
      delete = "",
    },
  },
})

require("mini.surround").setup({
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

require("mini.move").setup({})

require("mini.pairs").setup({})

require("mini.git").setup({})
