local M = {}

function M.setup(colorscheme)
	vim.cmd("colorscheme " .. colorscheme)
end

return M
