local MiniSurround = require("mini.surround")
MiniSurround.setup({
  mappings = {
    -- 添加环绕的映射
    add = "gsa",
    -- 删除环绕的映射
    delete = "gsd",
    -- 查找右侧环绕的映射
    find = "gsf",
    -- 查找左侧环绕的映射
    find_left = "gsF",
    -- 高亮环绕的映射
    highlight = "gsh",
    -- 替换环绕的映射
    replace = "gsr",
    -- 更新搜索行数的映射
    update_n_lines = "gsn",
  },

  -- 搜索行数（用于查找环绕）
  n_lines = 20,

  -- 尊重 ts_node 范围
  respect_selection_type = false,
})
