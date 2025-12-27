if vim.g.neovide then
  return
end

vim.pack.add({
  { src = "https://github.com/xiyaowong/transparent.nvim" },
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    require("transparent").setup({
      extra_groups = {
        "TinyInlineDiagnosticVirtualTextArrow",
        "TinyInlineInvDiagnosticVirtualTextHint",
        "TinyInlineInvDiagnosticVirtualTextInfo",
        "TinyInlineInvDiagnosticVirtualTextWarn",
        "TinyInlineInvDiagnosticVirtualTextError",
      },
    })
  end,
})
