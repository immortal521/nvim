return {
  "iamcco/markdown-preview.nvim",
  -- build = "cd app && pnpm install",
  init = function()
    vim.g.mkdp_auto_start = false
    vim.g.mkdp_auto_close = false
    vim.g.mkdp_open_to_the_world = false
    vim.g.mkdp_open_ip = "localhost"
    vim.g.mkdp_port = "60000"
    -- vim.g.mkdp_browser = "D:\\Zen Browser\\zen.exe"
    vim.g.mkdp_echo_preview_url = false
    vim.g.mkdp_page_title = "${name}"
    vim.g.mkdp_combine_preview = true
    vim.g.mkdp_filetypes = { "markdown", "md" }
  end,
  ft = { "markdown", "md" },
}
