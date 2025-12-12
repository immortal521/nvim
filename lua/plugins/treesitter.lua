vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/folke/ts-comments.nvim" },
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("SetupTreesitter", { clear = true }),
  once = true,
  callback = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "graphql",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
        "regex",
        "rust",
        "ron",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      ignore_install = {
        "latex",
        "yaml",
        "xml",
      },
      disable = function(lang, bufnr)
        return lang == "yaml" and vim.api.nvim_buf_line_count(bufnr) > 5000
      end,
    })
  end,
})
