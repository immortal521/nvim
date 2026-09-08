---@class utils.autocmd
---@deprecated 当前配置只直接使用事件列表；该模块没有运行时调用方。
local M = {}

M.BufEdit = { "BufReadPost", "BufNewFile", "BufWritePre" }

return M
