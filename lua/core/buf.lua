---@class core.buf
local M = {}

function M.delete()
	local buf = vim.api.nvim_get_current_buf()
	if vim.api.nvim_buf_is_valid(buf) then
		vim.cmd.bdelete()
	end
end

function M.delete_other()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_valid(buf) then
			if vim.fn.buflisted(buf) == 1 then
				vim.cmd("bdelete! " .. buf)
			end
		end
	end
end

return M
