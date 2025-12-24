---@class utils
---@field keymap utils.keymap
---@field colors utils.colors
---@field lsp utils.lsp
---@field terminal utils.terminal
---@field fs utils.fs
---@field project utils.project
---@field system utils.system
---@field buffer utils.buffer
---@field log utils.log
local M = {}

-- 模块懒加载
setmetatable(M, {
  __index = function(t, k)
    local ok, module = pcall(require, "utils." .. k)
    if ok then
      t[k] = module
      return module
    end
    error("Utils module '" .. k .. "' not found")
  end,
})

--- 检查是否为 Windows 系统
---@return boolean 是否为 Windows
M.is_win = function()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

--- 异步执行函数
---@param callback function 回调函数
---@param delay? number 延迟时间（毫秒），默认 1000
M.async_function = function(callback, delay)
  delay = delay or 1000
  vim.defer_fn(function()
    callback("异步操作完成")
  end, delay)
end

return M
