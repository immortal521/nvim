if vim.g.neovide == true then
  return {}
end

return {
  "xiyaowong/transparent.nvim",
  opts = {
    extra_groups = {
      "LspInlayHint",
    },
  },
}
