local M = {}

function M.setup()
  local aug = vim.api.nvim_create_augroup("BufEditBridge", { clear = true })

  vim.api.nvim_create_autocmd(
    { "BufReadPost", "BufNewFile", "BufWritePre" },
    {
      group = aug,
      callback = function(args)
        vim.api.nvim_exec_autocmds("User", {
          pattern = "BufEdit",
          data = args,
        })
      end,
    }
  )
end

return M
