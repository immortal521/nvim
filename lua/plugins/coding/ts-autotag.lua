-- Auto close tags
---@type zpack.Spec
return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    ---@type nvim-ts-autotag.Opts
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  },
}

