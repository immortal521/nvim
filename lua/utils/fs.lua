---@class utils.fs
local M = {}

--- 获取当前文件完整路径
---@return string 文件路径
M.get_current_file_path = function()
  return vim.fn.expand("%:p")
end

--- 检查文件是否存在
---@param file_path string 文件路径
---@return boolean 是否存在
M.file_exists = function(file_path)
  local f = io.open(file_path, "r")
  if f then
    io.close(f)
    return true
  end
  return false
end

--- 创建目录（如果不存在）
---@param dir_path string 目录路径
M.create_dir = function(dir_path)
  if not M.file_exists(dir_path) then
    vim.fn.mkdir(dir_path, "p")
  end
end

--- 根据系统归一化路径
---@param path string 原始路径
---@return string 归一化后的路径
M.normalize_path = function(path)
  if Utils.is_win() then
    path, _ = path:gsub("/", "\\")
  end
  return path
end

return M

