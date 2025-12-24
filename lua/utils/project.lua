---@class utils.project
local M = {}

--- 项目根目录检测文件列表
local PROJECT_ROOT_MARKERS = {
  ".git",
  "go.mod",
  "package.json",
  "pyproject.toml",
  "Cargo.toml",
  "pom.xml",
  "setup.py",
  "requirements.txt",
}

--- 缓存表
M._cache = {
  project_root = {},
  git_root = {},
}

--- 从文件列表检测项目根目录
---@param files string[] 文件列表
---@return string|nil 根目录路径
local function detect_root_from_files(files)
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == "" then
    return vim.loop.cwd()
  end

  local root = vim.fs.find(files, {
    upward = true,
    path = buf_name,
  })[1]

  return root and vim.fs.dirname(root) or vim.loop.cwd()
end

--- 获取项目根目录
---@param opts? table 配置选项
---@field buf? number 缓冲区编号，默认为当前缓冲区
---@return string 项目根目录路径
M.get_project_root = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  -- 检查缓存
  if M._cache.project_root[buf] then
    return M._cache.project_root[buf]
  end

  local root = nil

  -- 尝试 LSP 客户端根目录
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if clients and #clients > 0 then
    for _, client in ipairs(clients) do
      if client.config.root_dir then
        root = client.config.root_dir
        break
      end
    end
  end

  -- 如果没有 LSP 根目录，从文件检测
  if not root then
    root = detect_root_from_files(PROJECT_ROOT_MARKERS)
  end

  root = require("utils.fs").normalize_path(root)
  M._cache.project_root[buf] = root
  return root
end

--- 获取 Git 根目录
---@param opts? table 配置选项
---@field buf? number 缓冲区编号，默认为当前缓冲区
---@return string Git 根目录路径
M.get_git_root = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  -- 检查缓存
  if M._cache.git_root[buf] then
    return M._cache.git_root[buf]
  end

  local project_root = M.get_project_root({ buf = buf })
  local git_dir = vim.fs.find(".git", {
    path = project_root,
    upward = true,
    stop = vim.loop.cwd(),
  })[1]

  local git_root = git_dir and vim.fs.dirname(git_dir) or project_root

  git_root = require("utils.fs").normalize_path(git_root)
  M._cache.git_root[buf] = git_root
  return git_root
end

--- 清除缓存
---@param buf? number 缓冲区编号，nil 表示清除所有缓存
M.clear_cache = function(buf)
  if buf then
    M._cache.project_root[buf] = nil
    M._cache.git_root[buf] = nil
  else
    M._cache.project_root = {}
    M._cache.git_root = {}
  end
end

--- 缓冲区自动清理
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    M.clear_cache(args.buf)
  end,
  desc = "清理已删除缓冲区的缓存",
})

return M

