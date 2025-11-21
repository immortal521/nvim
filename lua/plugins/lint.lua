local utils = require("utils")

-- 通过文件类型来配置 linter
local linters_by_ft = {
  go = { "golangcilint" },
  vue = { "eslint" },
  javascript = { "eslint" },
  typescript = { "eslint" },
}

-- 默认的 linters 配置表
local linters = {}

-- 获取 nvim-lint 插件
local lint = require("lint")

-- 触发 lint 检查的事件列表
local events = { "BufWritePost", "BufReadPost", "InsertLeave" }

-- 将 linters_by_ft 内容加载到 linters 配置中
for ft, linters_for_ft in pairs(linters_by_ft) do
  for _, linter in ipairs(linters_for_ft) do
    -- 可以根据需求进一步处理 linter
    linters[ft] = linters[ft] or {}
    table.insert(linters[ft], linter)
  end
end

-- 将 linters 配置赋给 nvim-lint 插件
for name, linter in pairs(linters) do
  if type(linter) == "table" and type(lint.linters[name]) == "table" then
    lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
    if type(linter.prepend_args) == "table" then
      lint.linters[name].args = lint.linters[name].args or {}
      vim.list_extend(lint.linters[name].args, linter.prepend_args)
    end
  else
    lint.linters[name] = linter
  end
end

-- 更新文件类型与 linter 的映射
lint.linters_by_ft = linters_by_ft

-- 防抖函数，减少频繁执行
local function debounce(ms, fn)
  if type(fn) ~= "function" then
    vim.notify("[debounce] expected a function, got " .. type(fn), vim.log.levels.WARN)
    return function() end -- 返回一个空函数，避免报错
  end

  local timer = vim.uv.new_timer()
  if not timer then
    vim.notify("[debounce] failed to create timer", vim.log.levels.ERROR)
    return function() end
  end

  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      -- 安全调用
      if fn then
        vim.schedule_wrap(fn)(unpack(argv))
      end
    end)
  end
end

-- linter 执行逻辑
local function linter()
  -- 通过 nvim-lint 获取当前文件类型的 linter
  local names = lint._resolve_linter_by_ft(vim.bo.filetype)

  -- 创建副本，避免修改原始数据
  names = vim.list_extend({}, names)

  -- 添加回退 linter，如果没有找到与当前文件类型匹配的 linter
  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft["_"] or {})
  end

  -- 添加全局 linter
  vim.list_extend(names, lint.linters_by_ft["*"] or {})

  -- 过滤掉不存在或者不满足条件的 linter
  local ctx = { filename = vim.api.nvim_buf_get_name(0) }
  ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
  names = vim.tbl_filter(function(name)
    local linter_by_name = lint.linters[name]
    if not linter_by_name then
      utils.log("Linter not found: " .. name)
    end
    return linter_by_name
      and not (type(linter_by_name) == "table" and linter_by_name.condition and not linter_by_name.condition(ctx))
  end, names)

  -- 运行符合条件的 linter
  if #names > 0 then
    lint.try_lint(names)
  end
end

-- 设置自动命令，绑定事件触发 linter 检查
vim.api.nvim_create_autocmd(events, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = debounce(100, linter),
})
