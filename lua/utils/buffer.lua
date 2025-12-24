---@class utils.buffer
local M = {}

--- 获取所有已列出的缓冲区
---@return number[] 缓冲区编号列表
M.get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

--- 获取当前缓冲区
---@return number 当前缓冲区编号
M.get_current_buf = function()
  return vim.api.nvim_get_current_buf()
end

--- 检查缓冲区是否存在
---@param bufnr number 缓冲区编号
---@return boolean 是否存在
M.buf_exists = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
end

--- 获取缓冲区名称
---@param bufnr? number 缓冲区编号，默认为当前缓冲区
---@return string 缓冲区名称
M.get_buf_name = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_name(bufnr)
end

return M