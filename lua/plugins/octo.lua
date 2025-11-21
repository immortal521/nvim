local wk = require("which-key")

vim.treesitter.language.register("markdown", "octo")

require("octo").setup({
  enable_builtin = true,
  default_to_projects_v2 = true,
  default_merge_method = "squash",
  picker = "snacks",
})

local keys = {
  { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
  { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
  { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
  { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
  { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
  { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
}

-- 使用 create_autocmd 注册局部函数回调
vim.api.nvim_create_autocmd("FileType", {
  pattern = "octo", -- 对所有文件类型生效
  callback = function()
    wk.register({
      ["@"] = { "@<C-x><C-o>" },
      ["#"] = { "#<C-x><C-o>" },
    }, { mode = "i", silent = true })
    wk.register({
      a = { "", "assignee (Octo)" },
      c = { "", "comment/code (Octo)" },
      l = { "", "label (Octo)" },
      i = { "", "issue (Octo)" },
      r = { "", "react (Octo)" },
      p = { "", "pr (Octo)" },
      pr = { "", "rebase (Octo)" },
      ps = { "", "squash (Octo)" },
      v = { "", "review (Octo)" },
      g = { "", "goto_issue (Octo)" },
    }, {
      prefix = "<localleader>",
      buffer = 0,
    })
  end,
})
wk.add(keys)

vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
  callback = function()
    local keep = { "octo" }
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.tbl_contains(keep, vim.bo[buf].filetype) then
        vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
      end
    end
  end,
})
