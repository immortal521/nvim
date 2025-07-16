return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      vue = { "eslint" },
      javascript = { "eslint" },
      jsx = { "eslint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
      markdown = { "eslint" },
    },
    linters = {
      eslint = {
        condition = function(ctx)
          local config_files = {
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.mjs",
            ".eslintrc.json",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            "eslint.config.js", -- 支持扁平化配置 .js
            "eslint.config.mjs", -- 支持扁平化配置 .mjs
            "eslint.config.cjs", -- 支持扁平化配置 .cjs
            "eslint.config.ts", -- 支持扁平化配置 .ts
          }
          -- 查找这些文件是否存在于当前文件路径的任何上级目录
          for _, file_name in ipairs(config_files) do
            -- 尝试查找当前文件
            local found_path = vim.fs.find(file_name, { path = ctx.filename, upward = true })[1]
            -- 如果找到了，就立即返回该路径
            if found_path then
              return found_path
            end
          end
          -- 如果遍历完所有配置文件都没有找到，则返回 nil
          return nil
        end,
      },
    },
  },
}
