vim.pack.add({
  { src = "https://github.com/windwp/nvim-ts-autotag" },
})

---@type nvim-ts-autotag.Opts
local opts = {
  enable_close = true,
  enable_rename = true,
  enable_close_on_slash = true,
}

require("nvim-ts-autotag").setup({
  opts = opts,
})
