local M = {}

local lsp_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lsp", "*.lua", false, true)
M.get_lsp_names = function()
  local lsp_names = {}
  for _, file in ipairs(lsp_files) do
    -- 从路径中提取不带后缀的名字
    local name = vim.fn.fnamemodify(file, ":t:r")
    if name then
      table.insert(lsp_names, name)
    end
  end
  return lsp_names
end

return M
