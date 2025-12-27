vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local TS = require("nvim-treesitter")

local langs = {
  "bash",
  "c",
  "diff",
  "graphql",
  "html",
  "http",
  "java",
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
  "vue",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    TS.install(langs)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
  end,
})
