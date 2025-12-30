-- Auto close tags
---@type LazyPluginSpec
return {
  "windwp/nvim-ts-autotag",
  event = "BufEdit",
  opts = {
    ---@type nvim-ts-autotag.Opts
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  },
}

