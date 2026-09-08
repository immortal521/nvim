---@class utils.log
local M = setmetatable({}, {
	__call = function(m, ...)
		return m.log(...)
	end,
})

--- 日志级别
---@type table<string, number>
M.levels = {
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4,
}

--- 当前日志级别
M.current_level = M.levels.INFO

--- 设置日志级别
---@deprecated 当前配置没有调用方；日志级别目前由 `current_level` 直接控制。
---@param level number
function M.set_level(level)
	M.current_level = level
end

---@class LogOpts
---@field time? boolean 是否显示时间（默认 true）
---@field title? string 通知标题

--- 日志输出
---@param msg string
---@param level? number
---@param opts? LogOpts
function M.log(msg, level, opts)
	level = level or M.levels.INFO
	opts = opts or {}

	if level < M.current_level then
		return
	end

	local show_time = opts.time ~= false

	local level_name = level == M.levels.DEBUG and "DEBUG"
		or level == M.levels.INFO and "INFO"
		or level == M.levels.WARN and "WARN"
		or level == M.levels.ERROR and "ERROR"
		or "INFO"

	local formatted_msg
	if show_time then
		local time = os.date("%Y-%m-%d %H:%M:%S")
		formatted_msg = ("[%s] %s - %s"):format(level_name, time, msg)
	else
		formatted_msg = ("[%s] %s"):format(level_name, msg)
	end

	local vim_level = level == M.levels.ERROR and vim.log.levels.ERROR
		or level == M.levels.WARN and vim.log.levels.WARN
		or vim.log.levels.INFO

	vim.notify(formatted_msg, vim_level, opts.title and { title = opts.title } or nil)
end

--- 调试日志
---@deprecated 当前配置没有调用方；保留兼容 API，但新代码请避免增加 DEBUG 日志噪音。
---@param msg string
---@param opts? LogOpts
function M.debug(msg, opts)
	M.log(msg, M.levels.DEBUG, opts)
end

--- 信息日志
---@param msg string
---@param opts? LogOpts
function M.info(msg, opts)
	M.log(msg, M.levels.INFO, opts)
end

--- 警告日志
---@param msg string
---@param opts? LogOpts
function M.warn(msg, opts)
	M.log(msg, M.levels.WARN, opts)
end

--- 错误日志
---@param msg string
---@param opts? LogOpts
function M.error(msg, opts)
	M.log(msg, M.levels.ERROR, opts)
end

return M
