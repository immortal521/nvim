-- utils/util.lua

---@class utils
---@field keymap utils.keymap
---@field colors utils.colors
local M = {}
setmetatable(M, {
  __index = function(t, k)
    t[k] = require("utils." .. k)
    return t[k]
  end,
})

-- ================================
-- 工具函数
-- ================================

M.log = function(msg)
  local time = os.date("%Y-%m-%d %H:%M:%S")
  print(("[UTIL] %s - %s"):format(time, msg))
end

M.map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.desc = opts.desc or ""
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.get_current_file_path = function()
  return vim.fn.expand("%:p")
end

M.file_exists = function(file_path)
  local f = io.open(file_path, "r")
  if f then
    io.close(f)
    return true
  end
  return false
end

M.create_dir = function(dir_path)
  if not M.file_exists(dir_path) then
    vim.fn.mkdir(dir_path, "p")
  end
end

M.is_win = function()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

M.async_function = function(callback)
  vim.defer_fn(function()
    callback("异步操作完成")
  end, 1000)
end

-- ================================
-- 项目根目录 / Git 根目录
-- ================================

-- 缓存表
M._cache = {
  project_root = {},
  git_root = {},
}

-- 内部函数：查找项目根目录
local function detect_root_from_files(files)
  local root = vim.fs.find(files, {
    upward = true,
    path = vim.api.nvim_buf_get_name(0),
  })[1]
  return root and vim.fs.dirname(root) or vim.loop.cwd()
end

-- 内部函数：根据系统归一化路径
local function normalize_path(path)
  if M.is_win() then
    return path:gsub("/", "\\")
  end
  return path
end

-- 获取项目根目录
M.get_project_root = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if M._cache.project_root[buf] then
    return M._cache.project_root[buf]
  end

  -- 尝试 LSP root
  local clients = vim.lsp.get_clients({ bufnr = buf })
  local root = nil
  if clients and clients[1] and clients[1].config.root_dir then
    root = clients[1].config.root_dir
  else
    root = detect_root_from_files({ ".git", "go.mod", "package.json", "pyproject.toml" })
  end

  root = normalize_path(root)
  M._cache.project_root[buf] = root
  return root
end

-- 获取 Git 根目录
M.get_git_root = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if M._cache.git_root[buf] then
    return M._cache.git_root[buf]
  end

  local project_root = M.get_project_root({ buf = buf })
  local git_dir = vim.fs.find(".git", { path = project_root, upward = true })[1]
  local git_root = git_dir and vim.fs.dirname(git_dir) or project_root

  git_root = normalize_path(git_root)
  M._cache.git_root[buf] = git_root
  return git_root
end

M.get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

return M
