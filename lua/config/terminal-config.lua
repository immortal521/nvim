local os_name = vim.loop.os_uname().sysname

if os_name == "Linux" then
  -- 使用 Linux 下的终端，例如 xterm 或 gnome-terminal
  if vim.fn.executable("/bin/zsh") == 1 then
    vim.o.shell = "/bin/zsh"
  else
    vim.o.shell = "/bin/bash"
  end
  vim.o.shellcmdflag = "-c"
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellpipe = "2>&1 | tee %s"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
elseif os_name == "Darwin" then
  -- 使用 macOS 下的终端
  vim.o.shell = "/bin/zsh"
  vim.o.shellcmdflag = "-c"
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellpipe = "2>&1 | tee %s"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
elseif os_name == "Windows_NT" then
  if vim.fn.executable("nu") == 1 then
    vim.o.shell = "nu"
    vim.o.shellcmdflag = "-c"
    vim.o.shellredir = ">%s 2>&1"
    vim.o.shellpipe = "2>&1 | tee %s"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  elseif vim.fn.executable("pwsh") == 1 then
    vim.o.shell = "pwsh"
    vim.o.shellcmdflag =
      "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    vim.o.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  else
    vim.o.shell = "powershell"
    vim.o.shellcmdflag =
      "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    vim.o.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end
end
