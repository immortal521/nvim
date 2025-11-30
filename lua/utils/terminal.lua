local M = setmetatable({}, {
  __call = function(m, ...)
    return m.terminal(...)
  end,
})

---@param shell? string
M.terminal = function(shell)
  vim.o.shell = shell or vim.o.shell
  vim.o.shellcmdflag = "-c"
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellpipe = "2>&1 | tee %s"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  if shell == "pwsh" or shell == "powershell" then
    -- Check if 'pwsh' is executable and set the shell accordingly
    if vim.fn.executable("pwsh") == 1 then
      vim.o.shell = "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      vim.o.shell = "powershell"
    else
      return vim.notify("No powershell executable found", vim.log.levels.ERROR)
    end

    -- Setting shell command flags
    vim.o.shellcmdflag =
      "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"

    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'

    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'

    -- Setting shell quote options
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end
end

return M
