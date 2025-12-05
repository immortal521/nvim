if true then
  return
end

vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
})

require("fzf-lua").setup({
  winopts = {
    -- split = "belowright new",-- 是否在分屏中打开？
    -- "belowright new"  : 在下方分屏打开
    -- "aboveleft new"   : 在上方分屏打开
    -- "belowright vnew" : 在右侧分屏打开
    -- "aboveleft vnew   : 在左侧分屏打开
    -- 仅在使用浮动窗口时有效
    -- （即当未定义'split'时，默认使用浮动窗口）
    height = 0.85, -- 窗口高度
    width = 0.80, -- 窗口宽度
    row = 0.35, -- 窗口行位置（0=顶部，1=底部）
    col = 0.50, -- 窗口列位置（0=左侧，1=右侧）
    -- 传递给 nvim_open_win() 的边框参数
    border = "rounded",
    -- 背景透明度，0为完全不透明，100为完全透明（即禁用）
    backdrop = 60,
    -- title         = "Title",
    -- title_pos     = "center",        -- 'left'，'center' 或 'right'
    -- title_flags   = false,           -- 取消注释以禁用标题标志
    fullscreen = false, -- 是否全屏启动？
    -- 为主 fzf 窗口启用 treesitter 高亮，仅在存在类似 grep 的结果时生效，
    -- 即 "file:line:col:text" 格式
    -- 由于高亮颜色冲突，也会覆盖 `fzf_colors`
    -- 设置 `fzf_colors=false` 或 `fzf_colors.hl=...` 可覆盖此行为
    treesitter = {
      enabled = true,
      fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
    },
    preview = {
      -- default     = 'bat',           -- 是否覆盖默认预览器？
      -- 默认使用 'builtin' 预览器
      border = "rounded", -- 预览边框：支持 `nvim_open_win` 和 fzf 的值（如 "border-top", "none"）
      -- 原生 fzf 预览器（bat/cat/git 等）
      -- 也可以设置为 `fun(winopts, metadata)`
      wrap = false, -- 预览内容是否换行（fzf 的 'wrap|nowrap'）
      hidden = false, -- 是否默认隐藏预览
      vertical = "down:45%", -- 预览窗口垂直位置和大小（上|下:大小）
      horizontal = "right:60%", -- 预览窗口水平位置和大小（右|左:大小）
      layout = "flex", -- 布局方式：horizontal|vertical|flex
      flip_columns = 100, -- flex 布局切换为水平布局的列数阈值
      -- 仅用于内置预览器：
      title = true, -- 是否显示预览边框标题（文件/缓冲区）
      title_pos = "center", -- 标题对齐方式：left|center|right
      scrollbar = "float", -- 滚动条类型：`false` 或 字符串 'float|border'
      -- float: 窗口内浮动边框
      -- border: 边框内“块”标记
      scrolloff = -1, -- 浮动滚动条距离右侧的偏移量
      -- 仅当 scrollbar = 'float' 时生效
      delay = 20, -- 显示预览的延迟时间（毫秒）
      -- 防止快速滚动时卡顿
      winopts = { -- 内置预览器窗口选项
        number = true,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = "both",
        cursorcolumn = false,
        signcolumn = "no",
        list = false,
        foldenable = false,
        foldmethod = "manual",
      },
    },
    on_create = function()
      -- 在 fzf 主窗口创建时调用一次
      -- 可用于添加自定义 fzf-lua 快捷键，例如：
      --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
    end,
    -- 在 fzf 界面关闭后调用一次
    -- on_close = function() ... end
  },
})

-- stylua: ignore
local keys = {
  { "<leader>fb", "<cmd>lua FzfLua.buffers()<cr>", desc = "Buffers" },
  { "<leader>/", "<cmd>lua FzfLua.live_grep()<cr>", desc = "Grep"},
  { "<leader>:", "<cmd>lua FzfLua.command_history()<cr>", desc = "Command History"},
  { "<leader><space>", "<cmd>lua FzfLua.files()<cr>", desc = "Find Files"},
  { "<leader>n", "<cmd>NoiceFzf<cr>", desc = "Notification History"},
  { "<leader>fc", "<cmd>lua FzfLua.files({cwd=vim.fn.stdpath('config')})<cr>", desc = "Find Config File"},
  { "<leader>fg", "<cmd>lua FzfLua.git_files()<cr>", desc = "Find Git Files)" },
  { "<leader>fr", "<cmd>lua FzfLua.oldfiles()<cr>", desc = "Recent" },
  -- { "<leader>fR", "<cmd>lua FzfLua.oldfiles({ filter = { cwd = true }})<cr>", desc = "Recent (cwd)" },
  { "<leader>gd", "<cmd>lua FzfLua.git_diff()", desc = "Git Diff" },
  { "<leader>gs", "<cmd>lua FzfLua.git_status()", desc = "Git Status" },
  { "<leader>gS", "<cmd>lua FzfLua.git_stash()", desc = "Git Stash" },
  { "<leader>sg", "<cmd>lua FzfLua.live_grep()<cr>", desc = "Grep"},
  { "<leader>sw", "<cmd>lua FzfLua.cword()<cr>", desc = "Visual selection or word", mode = { "n", "x" } },
  { "<leader>sW", "<cmd>lua FzfLua.cWORD()<cr>", desc = "Visual selection or word", mode = { "n", "x" } },
  { "<leader>s.", "<cmd>lua FzfLua.registers()<cr>", desc = "Registers", mode = { "n", "x" } },
  { '<leader>s/', "<cmd>lua FzfLua.search_history()<cr>", desc = "Search History" },
  { "<leader>sa", "<cmd>lua FzfLua.autocmds()<cr>", desc = "Autocmds" },
  { "<leader>sc", "<cmd>lua FzfLua.command_history()<cr>", desc = "Command History" },
  { "<leader>sC", "<cmd>lua FzfLua.commands()<cr>", desc = "Commands" },
  { "<leader>sd", "<cmd>lua FzfLua.diagnostics_command()<cr>", desc = "Diagnostics" },
  { "<leader>sD", "<cmd>lua FzfLua.diagnostics_workspace()<cr>", desc = "Workspace Diagnostics" },
  { "<leader>sh", "<cmd>lua FzfLua.helptags()<cr>", desc = "Help Pages" },
  { "<leader>sH", "<cmd>lua FzfLua.highlights()<cr>", desc = "Highlights" },
  -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
  { "<leader>sj", "<cmd>lua FzfLua.jumps()<cr>", desc = "Jumps" },
  { "<leader>sk", "<cmd>lua FzfLua.keymaps()<cr>", desc = "Keymaps" },
  { "<leader>sl", "<cmd>lua FzfLua.loclist()<cr>", desc = "Location List" },
  { "<leader>sM", "<cmd>lua FzfLua.manpages()<cr>", desc = "Man Pages" },
  { "<leader>sm", "<cmd>lua FzfLua.marks()<cr>", desc = "Marks" },
  { "<leader>sR", "<cmd>lua FzfLua.resume()<cr>", desc = "Resume" },
  { "<leader>sq", "<cmd>lua FzfLua.quickfix()<cr>", desc = "Quickfix List" },
  -- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
  -- ui
  { "<leader>uC", "<cmd>lua FzfLua.colorschemes()<cr>", desc = "Colorschemes" },
  { "<leader>gL", "<cmd>lua FzfLua.git_commits()<cr>", desc = "Git Log"},
  { "<leader>gb", "<cmd>lua FzfLua.git_blame()<cr>", desc = "Git Blame"}
}

require("fzf-lua").register_ui_select()

Utils.keymap.add(keys)
