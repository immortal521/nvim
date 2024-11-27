return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "npm i && cd app && npm i",
  lazy = true,
  ft = { "markdown", "md" },
  keys = {
    {
      "<leader>cp",
      "<cmd>MarkdownPreview<cr>",
      desc = "Markdown Preview",
    },
  },
  init = function()
    vim.g.mkdp_auto_start = true
    vim.g.mkdp_auto_close = false
    vim.g.mkdp_open_to_the_world = false
    vim.g.mkdp_open_ip = "localhost"
    vim.g.mkdp_port = "60000"
    vim.g.mkdp_browser = ""
    vim.g.mkdp_echo_preview_url = false
    vim.g.mkdp_page_title = "${name}"
    vim.g.mkdp_combine_preview = true
  end,
}
