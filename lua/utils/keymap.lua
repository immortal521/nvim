---@class utils.keymap.config: vim.keymap.set.Opts
---@field [1] string
---@field [2] string|fun()
---@field desc? string|fun():string
---@field mode? string|string[]

---@class utils.keymap
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.map(...)
  end,
})

---过滤出有效的 vim.keymap.set.Opts 配置项
---@param config utils.keymap.config
---@return vim.keymap.set.Opts 过滤后的配置
local function filter_config(config)
  local opts = {}

  -- 只保留非 [1]、[2] 和 mode 的字段
  for key, value in pairs(config) do
    if key ~= 1 and key ~= 2 and key ~= "mode" then
      opts[key] = value
    end
  end

  return opts
end

---统一的 keymap 映射函数
---@param config utils.keymap.config
function M.map(config)
  local lhs = config[1] -- 键绑定

  local rhs = config[2] -- 执行的命令或回调函数

  local mode = config.mode or "n"

  local opts = filter_config(config)

  -- 设置键位映射
  vim.keymap.set(mode, lhs, rhs, opts)
end

---批量添加多个键位映射
---@param configs utils.keymap.config[] 一组配置
function M.add(configs)
  for _, config in ipairs(configs) do
    M.map(config) -- 调用 map 方法设置每一个键位映射
  end
end

-- 返回模块
return M
