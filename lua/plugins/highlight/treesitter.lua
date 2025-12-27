local TS = require("nvim-treesitter")

local langs = {
  "bash",
  "c",
  "css",
  "diff",
  "graphql",
  "html",
  "http",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "jsx",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "nu",
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
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vue",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

vim.api.nvim_create_autocmd(Utils.autocmd.BufEdit, {
  once = true,
  callback = function()
    for _, lang in ipairs(langs) do
      TS.install(lang)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
  end,
})
