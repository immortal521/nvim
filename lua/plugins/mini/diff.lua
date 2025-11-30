local MiniDiff = require("mini.diff")

MiniDiff.setup({
  -- 视图配置
  view = {
    -- 差异显示样式：'sign' 或 'number'
    style = "sign",
    -- 符号配置
    signs = {
      add = "▎",
      change = "▎",
      delete = "",
    },
    -- 数字配置（当 style = "number" 时使用）
    number = {
      -- 添加的行号前缀
      add = "",
      -- 更改的行号前缀
      change = "",
      -- 删除的行号前缀
      delete = "",
    },
  },

  -- 映射
  mappings = {
    -- 应用 hunk
    apply = "gh",
    -- 重置 hunk
    reset = "gH",
    -- 应用文本对象
    textobject = "gh",
    -- 切换 hunk 视图
    toggle_view = "g<CR>",
  },

  -- 选项
  options = {
    -- 是否在差异视图中启用单词差异
    word_diff = false,
    -- 是否在差异视图中启用行差异
    line_diff = true,
    -- 差异算法
    algorithm = "histogram",
    -- 差异阈值
    threshold = nil,
    -- 是否在差异视图中忽略空白字符
    ignore_whitespace = false,
    -- 是否在差异视图中忽略空白更改
    ignore_whitespace_change = false,
    -- 是否在差异视图中忽略空白行
    ignore_blank_lines = false,
  },
})
