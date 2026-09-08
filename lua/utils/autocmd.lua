---@class utils.autocmd
---@deprecated No active callers; prefer vim.api.nvim_create_autocmd directly.
local M = {}

M.BufEdit = { "BufReadPost", "BufNewFile", "BufWritePre" }

return M
