-- utils/util.lua

local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("utils." .. k)
    return t[k]
  end,
})

-- 简单的 log 函数，打印时间戳和内容
M.log = function(msg)
  local time = os.date("%Y-%m-%d %H:%M:%S")
  print(("[UTIL] %s - %s"):format(time, msg))
end

-- 获取当前文件路径
M.get_current_file_path = function()
  return vim.fn.expand("%:p")
end

-- 检查一个文件是否存在
M.file_exists = function(file_path)
  local f = io.open(file_path, "r")
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

-- 创建目录
M.create_dir = function(dir_path)
  if not M.file_exists(dir_path) then
    vim.fn.mkdir(dir_path, "p")
  end
end

M.is_win = function()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

M.map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.desc = opts.desc or "" -- 设置描述
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.terminal = function(shell)
  vim.o.shell = shell or vim.o.shell

  vim.o.shellcmdflag = "-c"
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellpipe = "2>&1 | tee %s"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""

  -- Special handling for pwsh
  if shell == "pwsh" or shell == "powershell" then
    -- Check if 'pwsh' is executable and set the shell accordingly
    if vim.fn.executable("pwsh") == 1 then
      vim.o.shell = "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      vim.o.shell = "powershell"
    else
      return M.log("No powershell executable found")
    end

    -- Setting shell command flags
    vim.o.shellcmdflag =
      "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"

    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'

    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  end
end

-- 自定义的异步函数，假设它执行一些异步操作
M.async_function = function(callback)
  vim.defer_fn(function()
    callback("异步操作完成")
  end, 1000)
end

-- 返回模块表
return M
