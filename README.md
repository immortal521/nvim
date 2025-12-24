# Neovim 配置

这是一个基于 Lua 的 Neovim 配置。

## 📚 相关文档
- [键位映射文档](./keymaps.md) - 详细的快捷键说明
- [工具库文档](./utils.md) - Utils 工具函数使用指南

## 📦 主要插件

### 核心功能
- **mini.nvim**: 一系列实用插件的集合
- **nvim-treesitter**: 语法高亮和代码理解
- **blink.cmp**: 快速的代码补全引擎
- **conform.nvim**: 代码格式化
- **nvim-lspconfig**: LSP 配置管理

### 界面增强
- **tokyonight.nvim**: 现代化主题
- **heirline.nvim**: 可定制的状态栏
- **noice.nvim**: 改进的 UI 通知
- **transparent.nvim**: 透明背景支持
- **highlight-color.nvim**: 颜色高亮显示

### 编辑增强
- **flash.nvim**: 快速导航
- **grug-far.nvim**: 强大的搜索和替换
- **dial.nvim**: 增量/减量操作
- **yanky.nvim**: 剪贴板增强
- **nvim-surround**: 包围字符操作

### 开发工具
- **oil.nvim**: 文件浏览器
- **trouble.nvim**: 诊断显示
- **overseer.nvim**: 任务运行器
- **rest.nvim**: HTTP 客户端
- **debug.nvim**: 调试支持

### 语言支持
- **rust.nvim**: Rust 开发支持
- **nvim-jdtls**: Java 开发支持
- **vue_ls**: Vue.js 支持
- **vtsls**: TypeScript/JavaScript 支持
- **gopls**: Go 语言支持

### 实用工具
- **auto-save.nvim**: 自动保存
- **im-select.nvim**: 输入法切换
- **wakatime.nvim**: 编程时间统计
- **screenkey.nvim**: 按键显示
- **lazygit**: Git 管理工具集成
- **music-player**: 音乐播放器集成

## 🔧 配置结构

```
nvim/
├── init.lua                 # 主配置文件
├── lua/
│   ├── config/             # 核心配置
│   │   ├── init.lua
│   │   ├── options.lua     # 基本选项
│   │   ├── keymaps.lua     # 键位映射
│   │   ├── autocmds.lua    # 自动命令
│   │   └── lsp.lua         # LSP 配置
│   ├── plugins/            # 插件配置
│   │   ├── init.lua
│   │   └── [插件名].lua
│   └── utils/              # 工具函数
├── lsp/                    # LSP 服务器配置
└── after/ftplugin/         # 文件类型插件
```

## 🎯 主要设置

### 编辑器选项
- 使用空格作为缩进（2 个空格）
- 相对行号和行号显示
- 智能大小写敏感搜索
- 自动保存和撤销文件
- 鼠标支持

### 键位映射
- `<leader>` 作为主键位前缀
- `<localleader>` 作为本地键位前缀
- 快速导航和编辑快捷键

### LSP 配置
支持多种语言的 LSP 服务器：
- Lua (lua_ls)
- JavaScript/TypeScript (vtsls)
- Rust (rust_analyzer)
- Python (pyright)
- Go (gopls)
- Java (jdtls)
- 等等...

## 📋 依赖需求

### 必需依赖
- **Neovim**: 0.12.0 或更高版本
- **字体**: Maple Mono NF CN（推荐）或其他 Nerd Font
    - Maple Mono NF CN: [下载地址](https://github.com/subframe7536/maple-font)
    - 或安装任何 Nerd Font: `sudo pacman -S nerd-fonts` (Arch Linux)
- **lazygit**: Git 管理工具 [GitHub](https://github.com/jesseduffield/lazygit)
- **music-player**: 音乐播放器 [GitHub](https://github.com/immortal521/music-player)

### 开发环境依赖
- **Go**: 用于 Go 语言开发环境
- **Rust**: 用于某些 LSP 服务器和工具
- **Node.js**: 用于 JavaScript/TypeScript 开发
- **Python**: 用于 Python 开发和某些 LSP 服务器

## 🛠 安装和使用

1. 安装依赖字体：
   ```bash
   # 安装 Maple Mono NF CN 或其他 Nerd Font
   ```

2. 备份现有配置：
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

3. 克隆此配置：
   ```bash
   git clone https://github.com/immortal521/nvim ~/.config/nvim
   ```

4. 启动 Neovim，插件会自动安装：
   ```bash
   nvim
   ```

## 🎨 主题和外观

- 使用 TokyoNight 主题
- 支持透明背景
- 自定义字体：Maple Mono NF CN
- 圆角边框和现代化 UI
- 适应不同终端环境（包括 WezTerm）

## 🔍 调试和故障排除

- 使用 `:checkhealth` 检查配置健康状态
- 查看 `:LspInfo` 了解 LSP 状态
- 使用 `:Trouble` 查看诊断信息

## ⚠️ 注意事项

### 插件更新
当使用 `<leader>pu` 或 `vim.pack.update()` 更新插件时：

1. **更新选择**: 在更新界面中，使用 `<leader>ca` 打开 code action 菜单，可以选择：
   - 更新特定插件
   - 跳过某些插件的更新

2. **插件清理**: 在更新界面中也可以通过 code action 的 delete 选项清除无用插件

这个机制允许你精确控制哪些插件需要更新，避免不必要的更新导致的兼容性问题。

## 📝 自定义

配置采用模块化设计，可以轻松：
- 在 `lua/config/` 中修改核心设置
- 在 `lua/plugins/` 中添加或移除插件
- 在 `lua/config/keymaps.lua` 中自定义键位映射


---

**注意**: 此配置针对 Neovim 0.12+ 版本优化，请确保使用兼容的 Neovim 版本。
