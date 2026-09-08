---@class utils.fs
local M = {}

--- 获取当前文件完整路径。
---@deprecated 当前配置没有调用方；请直接使用 `vim.api.nvim_buf_get_name(0)`。
---@return string 文件路径
M.get_current_file_path = function()
	return vim.fn.expand("%:p") --[[@as string]]
end

--- 检查文件是否存在。
---@deprecated 当前配置没有调用方；请使用 `vim.uv.fs_stat()` 区分文件、目录和不存在三种状态。
---@param file_path string 文件路径
---@return boolean 是否存在
M.file_exists = function(file_path)
	local stat = vim.uv.fs_stat(file_path)
	return stat ~= nil and stat.type == "file"
end

--- 创建目录（如果不存在）
---@deprecated 当前配置没有调用方；请直接使用 `vim.fn.mkdir(dir_path, "p")` 或先检查 `vim.uv.fs_stat()`。
---@param dir_path string 目录路径
M.create_dir = function(dir_path)
	local stat = vim.uv.fs_stat(dir_path)
	if not stat then
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
