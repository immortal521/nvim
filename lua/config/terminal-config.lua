local os_name = vim.loop.os_uname().sysname

-- 默认的 shell 选项，适用于大多数 Unix-like 系统和默认 PowerShell
local default_shell_options = {
  shellcmdflag = "-c",
  shellredir = ">%s 2>&1",
  shellpipe = "2>&1 | tee %s",
  shellquote = "",
  shellxquote = "",
}

-- PowerShell 特定的 shell 选项
local powershell_options = {
  shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
  shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode',
  shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode',
  shellquote = "",
  shellxquote = "",
}

-- 辅助函数：设置 shell 选项
local function set_options(options_table)
  for opt, value in pairs(options_table) do
    vim.o[opt] = value
  end
end

if os_name == "Linux" then
  -- 尝试查找可用的 shell，优先级：fish -> zsh -> bash
  local shells_to_try = { "/bin/fish", "/bin/zsh", "/bin/bash" }
  for _, s in ipairs(shells_to_try) do
    if vim.fn.executable(s) == 1 then
      vim.o.shell = s
      break -- 找到第一个可用的就停止
    end
  end
  set_options(default_shell_options)
elseif os_name == "Darwin" then
  -- macOS 默认使用 /bin/bash 或 /bin/zsh (Catalina 后)
  -- 这里的逻辑可以根据你的偏好设置默认shell，或者让系统决定
  -- 如果不设置 vim.o.shell，Neovim 会使用系统默认的SHELL环境变量
  set_options(default_shell_options)
elseif os_name == "Windows_NT" then
  -- 尝试查找 Nushell, 然后是 PowerShell Core (pwsh), 最后是 Windows PowerShell
  if vim.fn.executable("nu") == 1 then
    vim.o.shell = "nu"
    set_options(default_shell_options)
  elseif vim.fn.executable("pwsh") == 1 then
    vim.o.shell = "pwsh"
    set_options(powershell_options)
  else
    vim.o.shell = "powershell"
    set_options(powershell_options)
  end
end
