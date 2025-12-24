---@class utils.log
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.log(...)
  end,
})

--- 日志级别
M.levels = {
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
}

--- 当前日志级别
M.current_level = M.levels.INFO

--- 设置日志级别
---@param level number 日志级别
M.set_level = function(level)
  M.current_level = level
end

--- 带时间戳的日志输出
---@param msg string 要记录的消息
---@param level? number 日志级别，默认为 INFO
M.log = function(msg, level)
  level = level or M.levels.INFO

  if level < M.current_level then
    return
  end

  local time = os.date("%Y-%m-%d %H:%M:%S")
  local level_name = level == M.levels.DEBUG and "DEBUG"
    or level == M.levels.INFO and "INFO"
    or level == M.levels.WARN and "WARN"
    or level == M.levels.ERROR and "ERROR"
    or "INFO"

  local formatted_msg = ("[%s] %s - %s"):format(level_name, time, msg)

  -- 使用 vim.notify 以获得更好的通知体验
  local vim_level = level == M.levels.ERROR and vim.log.levels.ERROR
    or level == M.levels.WARN and vim.log.levels.WARN
    or vim.log.levels.INFO

  vim.notify(formatted_msg, vim_level)
end

--- 调试日志
---@param msg string 消息
M.debug = function(msg)
  M.log(msg, M.levels.DEBUG)
end

--- 信息日志
---@param msg string 消息
M.info = function(msg)
  M.log(msg, M.levels.INFO)
end

--- 警告日志
---@param msg string 消息
M.warn = function(msg)
  M.log(msg, M.levels.WARN)
end

--- 错误日志
---@param msg string 消息
M.error = function(msg)
  M.log(msg, M.levels.ERROR)
end

return M
