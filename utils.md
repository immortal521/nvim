# Utils 工具库文档

这个工具库为 Neovim 配置提供了常用的工具函数和辅助功能，采用模块化设计，方便在配置中复用。

## 📁 模块结构

```
lua/utils/
├── init.lua      # 主入口文件，提供模块懒加载和基础系统函数
├── keymap.lua    # 键位映射工具
├── colors.lua    # 颜色工具
├── lsp.lua       # LSP 相关工具
├── terminal.lua  # 终端配置工具
├── fs.lua        # 文件系统工具
├── project.lua   # 项目和 Git 根目录工具
├── system.lua    # 系统相关工具
├── buffer.lua    # 缓冲区工具
└── log.lua       # 日志工具
```

## 🔧 核心模块 (init.lua)

### 模块懒加载机制
主模块使用 `__index` 元方法实现懒加载，只有在首次访问子模块时才会加载对应的模块文件。

### `Utils.is_win()`
检查当前系统是否为 Windows。

**返回值:**
- (boolean): 是否为 Windows 系统

### `Utils.async_function(callback, delay)`
异步执行函数。

**参数:**
- `callback` (function): 回调函数
- `delay` (number, 可选): 延迟时间（毫秒），默认 1000

**示例:**
```lua
Utils.async_function(function(msg)
  print(msg)  -- 输出: "异步操作完成"
end, 2000)
```

## 📁 文件系统工具 (fs.lua)

### `Utils.fs.get_current_file_path()`
获取当前文件的完整路径。

**返回值:**
- (string): 当前文件的绝对路径

### `Utils.fs.file_exists(file_path)`
检查文件是否存在。

**参数:**
- `file_path` (string): 文件路径

**返回值:**
- (boolean): 文件是否存在

### `Utils.fs.create_dir(dir_path)`
创建目录（如果不存在）。

**参数:**
- `dir_path` (string): 目录路径

### `Utils.fs.normalize_path(path)`
根据系统归一化路径。

**参数:**
- `path` (string): 原始路径

**返回值:**
- (string): 归一化后的路径

## 🏗️ 项目工具 (project.lua)

### `Utils.project.get_project_root(opts)`
获取项目根目录，支持缓存和 LSP 根目录检测。

**参数:**
- `opts` (table, 可选): 配置选项
  - `buf` (number): 缓冲区编号，默认为当前缓冲区

**返回值:**
- (string): 项目根目录路径

**检测的标记文件:**
- `.git`, `go.mod`, `package.json`, `pyproject.toml`
- `Cargo.toml`, `pom.xml`, `setup.py`, `requirements.txt`

### `Utils.project.get_git_root(opts)`
获取 Git 仓库根目录。

**参数:**
- `opts` (table, 可选): 配置选项
  - `buf` (number): 缓冲区编号，默认为当前缓冲区

**返回值:**
- (string): Git 根目录路径

### `Utils.project.clear_cache(buf)`
清除项目根目录缓存。

**参数:**
- `buf` (number, 可选): 缓冲区编号，nil 表示清除所有缓存

## 🖥️ 系统工具 (system.lua)

该模块目前为空，系统相关功能已移至主模块 `init.lua` 中。

**可用功能:**
- `Utils.is_win()` - 检查是否为 Windows 系统
- `Utils.async_function()` - 异步执行函数

## 📝 缓冲区工具 (buffer.lua)

### `Utils.buffer.get_bufs()`
获取所有已列出的缓冲区。

**返回值:**
- (number[]): 缓冲区编号列表

### `Utils.buffer.get_current_buf()`
获取当前缓冲区。

**返回值:**
- (number): 当前缓冲区编号

### `Utils.buffer.buf_exists(bufnr)`
检查缓冲区是否存在。

**参数:**
- `bufnr` (number): 缓冲区编号

**返回值:**
- (boolean): 是否存在

### `Utils.buffer.get_buf_name(bufnr)`
获取缓冲区名称。

**参数:**
- `bufnr` (number, 可选): 缓冲区编号，默认为当前缓冲区

**返回值:**
- (string): 缓冲区名称

## 📊 日志工具 (log.lua)

该模块支持直接调用，`Utils.log(msg)` 等同于 `Utils.log.log(msg)`。

### 日志级别
- `DEBUG = 1`
- `INFO = 2`
- `WARN = 3`
- `ERROR = 4`

### `Utils.log.set_level(level)`
设置日志级别。

**参数:**
- `level` (number): 日志级别

### `Utils.log.log(msg, level)`
带时间戳的日志输出，使用 `vim.notify` 提供更好的通知体验。

**参数:**
- `msg` (string): 要记录的消息
- `level` (number, 可选): 日志级别，默认为 INFO

### 便捷日志函数

#### `Utils.log.debug(msg)`
输出调试日志。

#### `Utils.log.info(msg)`
输出信息日志。

#### `Utils.log.warn(msg)`
输出警告日志。

#### `Utils.log.error(msg)`
输出错误日志。

**示例:**
```lua
-- 设置日志级别
Utils.log.set_level(Utils.log.levels.DEBUG)

-- 使用不同级别的日志
Utils.log.debug("调试信息")
Utils.log.info("普通信息")
Utils.log.warn("警告信息")
Utils.log.error("错误信息")

-- 或者使用直接调用方式
Utils.log("直接日志消息")
```

## ⌨️ 键位映射工具 (keymap.lua)

该模块支持直接调用，`Utils.keymap(config)` 等同于 `Utils.keymap.map(config)`。

### `Utils.keymap.map(config)`
统一的键位映射函数，支持更简洁的配置格式。

**参数:**
- `config` (table): 配置表
  - `[1]` (string): 左侧键位
  - `[2]` (string|function): 右侧命令或函数
  - `desc` (string|function, 可选): 描述信息
  - `mode` (string|table, 可选): 模式，默认为 "n"
  - 其他选项将传递给 `vim.keymap.set`

**示例:**
```lua
Utils.keymap.map({
  "<leader>w",
  ":w<CR>",
  desc = "保存文件",
  mode = "n"
})
```

### `Utils.keymap.add(configs)`
批量添加多个键位映射。

**参数:**
- `configs` (table): 配置数组，每个元素都是 `map` 函数接受的配置

**示例:**
```lua
Utils.keymap.add({
  { "<leader>w", ":w<CR>", desc = "保存文件" },
  { "<leader>q", ":q<CR>", desc = "退出" },
  { "<leader>e", vim.cmd.Ex, desc = "文件浏览器", mode = "n" }
})
```

## 🎨 颜色工具 (colors.lua)

该模块支持直接调用，`Utils.colors()` 等同于 `Utils.colors.get_colors()`。

### `Utils.colors.get_colors()`
获取当前主题的颜色配置。

**返回值:**
- (table): TokyoNight 主题的颜色表

**示例:**
```lua
local colors = Utils.colors.get_colors()
print(colors.bg) -- 背景色
print(colors.fg) -- 前景色

-- 或者使用直接调用方式
local colors = Utils.colors()
```

## 🔌 LSP 工具 (lsp.lua)

### `Utils.lsp.get_lsp_names()`
获取所有可用的 LSP 服务器名称。

**返回值:**
- (table): LSP 服务器名称列表

**功能:**
- 扫描 `lsp/` 目录下的所有 `.lua` 文件
- 返回文件名（不含扩展名）作为 LSP 服务器名称

## 🖥️ 终端工具 (terminal.lua)

该模块支持直接调用，`Utils.terminal(shell)` 等同于 `Utils.terminal.terminal(shell)`。

### `Utils.terminal.terminal(shell)`
配置终端环境，支持多种 shell。

**参数:**
- `shell` (string, 可选): shell 类型，如 "zsh", "bash", "pwsh" 等

**支持的 shell:**
- Unix/Linux shell (zsh, bash 等)
- PowerShell (pwsh, powershell)

**示例:**
```lua
-- 配置 zsh
Utils.terminal("zsh")

-- 配置 PowerShell（自动检测）
Utils.terminal("pwsh")

-- 或者使用直接调用方式
Utils.terminal.terminal("bash")
```

**PowerShell 特性:**
- 自动检测 pwsh 或 powershell
- 配置 UTF-8 编码
- 设置适当的执行策略
- 优化输出渲染

## 🚀 使用示例

### 推荐的新用法（模块化）

```lua
-- 加载工具库
local Utils = require("utils")

-- 使用子模块的函数
if Utils.fs.file_exists("~/.config/nvim/custom.lua") then
  dofile("~/.config/nvim/custom.lua")
end

-- 获取项目根目录
local root = Utils.project.get_project_root()
Utils.log.info("项目根目录: " .. root)

-- 缓冲区操作
local bufs = Utils.buffer.get_bufs()
Utils.log.info("当前缓冲区数量: " .. #bufs)

-- 系统检查
if Utils.is_win() then
  Utils.log.info("当前系统: Windows")
else
  Utils.log.info("当前系统: Unix/Linux")
end

-- 异步函数示例
Utils.async_function(function(msg)
  Utils.log.info(msg)  -- 输出: "异步操作完成"
end, 2000)
```

### 向后兼容用法

注意：由于新版本采用模块化设计，部分向后兼容的别名函数已被移除。建议使用模块化的调用方式。

```lua
-- 旧方式可能不再有效，请使用新方式
-- 错误: Utils.file_exists()
-- 正确: Utils.fs.file_exists()

-- 错误: Utils.get_project_root()
-- 正确: Utils.project.get_project_root()

-- 错误: Utils.log()
-- 正确: Utils.log.log() 或 Utils.log()
```

### 在插件配置中使用

```lua
-- 在插件配置中使用工具函数
require("plugins.nvim-tree").setup({
  on_attach = function(bufnr)
    local root = Utils.project.get_project_root({ buf = bufnr })
    -- 使用项目根目录进行配置
  end
})
```

### 日志使用示例

```lua
-- 设置日志级别为 DEBUG
Utils.log.set_level(Utils.log.levels.DEBUG)

-- 在不同场景下使用日志
Utils.log.debug("插件加载开始")
Utils.log.info("配置文件读取完成")
Utils.log.warn("发现过时的配置选项")
Utils.log.error("插件初始化失败")
```

## 📝 注意事项

1. **模块化设计**: 推荐使用 `Utils.module.function()` 的方式调用函数
2. **懒加载机制**: 工具模块采用懒加载机制，只在需要时才加载具体模块
3. **直接调用支持**: 某些模块支持直接调用，如 `Utils.colors()`、`Utils.log()`、`Utils.keymap()` 等
4. **缓存机制**: `Utils.project.get_project_root()` 和 `Utils.project.get_git_root()` 使用缓冲区级别的缓存，并在缓冲区删除时自动清理
5. **跨平台兼容**: 所有路径处理都考虑了 Windows 和 Unix 系统的差异
6. **类型注解**: 所有函数都提供了完整的类型注解，便于开发时获得智能提示
7. **日志增强**: `Utils.log` 模块使用 `vim.notify` 提供更好的通知体验，支持分级日志记录
8. **系统函数**: 系统相关函数已移至主模块，可直接通过 `Utils.is_win()` 和 `Utils.async_function()` 调用

这个重构后的工具库提供了更好的组织性和可维护性，采用了现代化的模块设计和懒加载机制。