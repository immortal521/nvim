# Neovim Keymaps 配置文档

## 全局配置 (`lua/config/keymaps.lua`)

| 按键 | 模式 | 描述 |
|------|------|------|
| `j`, `<Down>` | n, x | 智能向下移动 |
| `k`, `<Up>` | n, x | 智能向上移动 |
| `<A-h>` | c | 命令行模式向左 |
| `<A-l>` | c | 命令行模式向右 |
| `<A-h>` | i | 插入模式向左 |
| `<A-j>` | i | 插入模式向下 |
| `<A-k>` | i | 插入模式向上 |
| `<A-l>` | i | 插入模式向右 |
| `<A-h>` | t | 终端模式向左 |
| `<A-j>` | t | 终端模式向下 |
| `<A-k>` | t | 终端模式向上 |
| `<A-l>` | t | 终端模式向右 |
| `<leader>wh` | n | 转到左侧窗口 |
| `<leader>wj` | n | 转到下方窗口 |
| `<leader>wk` | n | 转到上方窗口 |
| `<leader>wl` | n | 转到右侧窗口 |
| `<C-Up>` | n | 增加窗口高度 |
| `<C-Down>` | n | 减少窗口高度 |
| `<C-Left>` | n | 减少窗口宽度 |
| `<C-Right>` | n | 增加窗口宽度 |
| `<C-j>` | n | 向下移动行 |
| `<C-k>` | n | 向上移动行 |
| `<C-j>` | i | 插入模式向下移动行 |
| `<C-k>` | i | 插入模式向上移动行 |
| `<C-j>` | v | 可视模式向下移动行 |
| `<C-k>` | v | 可视模式向上移动行 |
| `gV` | n | 可视选择更改的文本 |
| `g/` | x | 在可视选择中搜索 |
| `<esc>` | i, n, s | 退出并清除搜索高亮 |
| `<S-h>` | n | 上一个缓冲区 |
| `<S-l>` | n | 下一个缓冲区 |
| `[b` | n | 上一个缓冲区 |
| `]b` | n | 下一个缓冲区 |
| `<leader>bb` | n | 切换到其他缓冲区 |
| `<leader>` | n | 切换到其他缓冲区 |
| `<leader>bD` | n | 删除缓冲区和窗口 |
| `<leader>ur` | n | 重绘/清除搜索/更新差异 |
| `n` | n, x, o | 下一个搜索结果 |
| `N` | n, x, o | 上一个搜索结果 |
| `,` | i | 撤销断点 |
| `.` | i | 撤销断点 |
| `;` | i | 撤销断点 |
| `<C-s>` | i, x, n, s | 保存文件 |
| `<leader>K` | n | 关键词程序 |
| `<` | x | 保持选择的缩进 |
| `>` | x | 保持选择的缩进 |
| `gco` | n | 在下方添加注释 |
| `gcO` | n | 在上方添加注释 |
| `<leader>fn` | n | 新建文件 |
| `<leader>xl` | n | 位置列表 |
| `<leader>xq` | n | 快速修复列表 |
| `[q` | n | 上一个快速修复 |
| `]q` | n | 下一个快速修复 |
| `<leader>cd` | n | 行诊断 |
| `]d` | n | 下一个诊断 |
| `[d` | n | 上一个诊断 |
| `]e` | n | 下一个错误 |
| `[e` | n | 上一个错误 |
| `]w` | n | 下一个警告 |
| `[w` | n | 上一个警告 |
| `<leader>qq` | n | 退出所有 |
| `<leader>ui` | n | 检查位置 |
| `<leader>uI` | n | 检查树 |
| `<leader>-` | n | 在下方分割窗口 |
| `<leader>|` | n | 在右侧分割窗口 |
| `<leader>wd` | n | 删除窗口 |
| `<leader><tab>l` | n | 最后一个标签页 |
| `<leader><tab>o` | n | 关闭其他标签页 |
| `<leader><tab>f` | n | 第一个标签页 |
| `<leader><tab><tab>` | n | 新建标签页 |
| `<leader><tab>]` | n | 下一个标签页 |
| `<leader><tab>d` | n | 关闭标签页 |
| `<leader><tab>[` | n | 上一个标签页 |
| `<leader>pu` | n | 更新插件 |
| `<leader>bd` | n | 删除缓冲区 |
| `<leader>bo` | n | 删除其他缓冲区 |
| `<leader>gg` | n | Lazygit |
| `<leader>tf` | n | 浮动终端 |
| `<leader>tm` | n | 音乐播放器 |
| `jk` | i | 退出插入模式 |

## 插件 Keymaps

### 1. 代码补全 (completion.lua - blink.cmp)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<S-space>` | i, n | 显示/隐藏补全和文档 |
| `<C-h>` | i, n | 隐藏/显示补全 |
| `<cr>` | i, n | 接受补全/回退 |
| `<S-Tab>` | i, n | 选择上一个 |
| `<Tab>` | i, n | 选择下一个 |
| `<C-b>` | i, n | 文档向上滚动 |
| `<C-f>` | i, n | 文档向下滚动 |
| `<A-1>` 到 `<A-0>` | i, n | 选择第1-10个补全项 |

### 2. 代码格式化 (conform.lua)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>cf` | n | 格式化当前文件 |

### 3. 调试器 (debug.lua - nvim-dap)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>dB` | n | 条件断点 |
| `<leader>db` | n | 切换断点 |
| `<leader>dc` | n | 运行/继续 |
| `<leader>da` | n | 带参数运行 |
| `<leader>dC` | n | 运行到光标 |
| `<leader>dg` | n | 跳转到行 |
| `<leader>di` | n | 单步进入 |
| `<leader>dj` | n | 向下 |
| `<leader>dk` | n | 向上 |
| `<leader>dl` | n | 运行最后一个 |
| `<leader>do` | n | 单步跳出 |
| `<leader>dO` | n | 单步跳过 |
| `<leader>dP` | n | 暂停 |
| `<leader>dr` | n | 切换REPL |
| `<leader>ds` | n | 会话 |
| `<leader>dt` | n | 终止 |
| `<leader>dw` | n | 小部件悬停 |
| `<leader>du` | n | Dap UI |
| `<leader>de` | n | 求值 |

### 4. 增量/减量操作 (dial.lua)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<C-a>` | n | 增加 |
| `<C-x>` | n | 减少 |
| `g<C-a>` | n | 增加 (g前缀) |
| `g<C-x>` | n | 减少 (g前缀) |
| `<C-a>` | v | 增加 (可视模式) |
| `<C-x>` | v | 减少 (可视模式) |
| `g<C-a>` | v | 增加 (可视模式，g前缀) |
| `g<C-x>` | v | 减少 (可视模式，g前缀) |

### 5. 快速跳转 (flash.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `s` | n, x, o | Flash跳转 |
| `S` | n, x, o | Flash Treesitter |
| `r` | o | 远程Flash |
| `R` | x, o | Treesitter搜索 |
| `<c-s>` | c | 切换Flash |
| `<c-space>` | n, x, o | Treesitter增量选择 |

### 6. 搜索替换 (grug-far.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>sr` | n, x | 搜索和替换 |

### 7. LSP功能 (lsp.lua)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>cm` | n | Mason |
| `gd` | n | 转到定义 |
| `gr` | n | 引用 |
| `gI` | n | 转到实现 |
| `gy` | n | 转到类型定义 |
| `gD` | n | 转到声明 |
| `K` | n | 悬停信息 |
| `gK` | n | 签名帮助 |
| `<M-k>` | i | 签名帮助 (插入模式) |
| `<leader>ca` | n | 代码操作 |
| `<leader>cc` | n | 运行CodeLens |
| `<leader>cC` | n | 刷新CodeLens |
| `<leader>cr` | n | 重命名 |
| `<leader>cR` | n | 重命名文件 |
| `<leader>ld` | n | LSP诊断 |
| `<leader>co` | n | 组织导入 |
| `gai` | n | 调用关系 (输入) |
| `gao` | n | 调用关系 (输出) |
| `<leader>ss` | n | LSP符号 (工作区) |
| `<leader>sS` | n | LSP符号 (文档) |

### 8. UI增强 (noice.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<S-Enter>` | c | 重定向命令行 |
| `<leader>snl` | n | 最后消息 |
| `<leader>snh` | n | 历史记录 |
| `<leader>sna` | n | 所有消息 |
| `<leader>snd` | n | 关闭所有 |
| `<leader>snt` | n | 消息选择器 |
| `<C-f>` | n | 向前滚动 |
| `<C-b>` | n | 向后滚动 |

### 9. 文件管理器 (oil.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `-` | n | 打开Oil文件管理器 |
| `<C-r>` | n | 刷新 |
| `<leader>y` | n | 复制条目 |
| `zh` | n | 切换隐藏文件 |
| `\` | n | 水平分割打开 |
| `|` | n | 垂直分割打开 |
| `-` | n | 关闭 |
| `<leader>e` | n | 关闭 |
| `<BS>` | n | 父目录 |
| `td` | n | 切换详细信息视图 |

### 10. 会话管理 (persistence.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>qs` | n | 恢复会话 |
| `<leader>qS` | n | 选择会话 |
| `<leader>ql` | n | 恢复最后会话 |
| `<leader>qd` | n | 不保存当前会话 |

### 11. 代码重构 (refactoring.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>rs` | n | 选择重构 |
| `<leader>ri` | n | 内联变量 |
| `<leader>rb` | n | 提取代码块 |
| `<leader>rf` | n | 提取函数 |
| `<leader>rF` | n | 提取函数到文件 |
| `<leader>rx` | n | 提取变量 |
| `<leader>rP` | n | 调试打印 |
| `<leader>rp` | n | 调试打印变量 |
| `<leader>rc` | n | 调试清理 |

### 12. HTTP客户端 (rest.nvim - kulala.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>Rb` | n | 打开临时文件 |
| `<leader>Rc` | n | 复制为cURL |
| `<leader>RC` | n | 从curl粘贴 |
| `<leader>Re` | n | 设置环境 |
| `<leader>Rg` | n | 下载GraphQL模式 |
| `<leader>Ri` | n | 检查当前请求 |
| `<leader>Rn` | n | 跳转到下一个请求 |
| `<leader>Rp` | n | 跳转到上一个请求 |
| `<leader>Rq` | n | 关闭窗口 |
| `<leader>Rr` | n | 重放最后一个请求 |
| `<leader>Rs` | n | 发送请求 |
| `<leader>RS` | n | 显示统计 |
| `<leader>Rt` | n | 切换视图 |

### 13. 屏幕按键显示 (screenkey.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>uk` | n | 切换屏幕按键 |

### 14. 文件选择器和工具 (snacks.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>,` | n | 缓冲区选择 |
| `<leader>/` | n | Grep搜索 |
| `<leader>:` | n | 命令历史 |
| `<leader><space>` | n | 查找文件 |
| `<leader>n` | n | 通知历史 |
| `<leader>fb` | n | 缓冲区 |
| `<leader>fB` | n | 缓冲区 (全部) |
| `<leader>fc` | n | 配置文件 |
| `<leader>ff` | n | 文件查找 |
| `<leader>fg` | n | 文件查找 (git) |
| `<leader>fr` | n | 最近文件 |
| `<leader>fR` | n | 最近文件 (全部) |
| `<leader>fp` | n | 项目 |
| `<leader>gb` | n | Git分支 |
| `<leader>gi` | n | Git提交 |
| `<leader>gI` | n | Git提交 (全部) |
| `<leader>gp` | n | Git推送 |
| `<leader>gP` | n | Git拉取 |
| `<leader>gd` | n | Git差异 |
| `<leader>gD` | n | Git差异 (工作区) |
| `<leader>gs` | n | Git状态 |
| `<leader>gS` | n | Git状态 (工作区) |
| `<leader>sb` | n | 搜索缓冲区 |
| `<leader>sB` | n | 搜索缓冲区 (全部) |
| `<leader>sg` | n | Grep搜索 |
| `<leader>sG` | n | Grep搜索 (工作区) |
| `<leader>sw` | n | 单词搜索 |
| `<leader>sW` | n | 单词搜索 (工作区) |
| `<leader>s"` | n | 寄存器 |
| `<leader>s/` | n | 搜索历史 |
| `<leader>sa` | n | 自动命令 |
| `<leader>sc` | n | 命令 |
| `<leader>sC` | n | 命令 (全部) |
| `<leader>sd` | n | 诊断 |
| `<leader>sD` | n | 诊断 (工作区) |
| `<leader>sh` | n | 帮助 |
| `<leader>sH` | n | 帮助 (全部) |
| `<leader>si` | n | 图标 |
| `<leader>sj` | n | 跳转 |
| `<leader>sk` | n | 键映射 |
| `<leader>sl` | n | 位置列表 |
| `<leader>sM` | n | 手册 |
| `<leader>sm` | n | 标记 |
| `<leader>sR` | n | 恢复 |
| `<leader>sq` | n | 快速列表 |
| `<leader>su` | n | 撤销树 |
| `<leader>uC` | n | 颜色主题 |

### 15. 诊断显示 (trouble.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>xx` | n | 诊断 (Trouble) |
| `<leader>xX` | n | 缓冲区诊断 (Trouble) |
| `<leader>cs` | n | 符号 (Trouble) |
| `<leader>cS` | n | LSP引用/定义 (Trouble) |
| `<leader>xL` | n | 位置列表 (Trouble) |
| `<leader>xQ` | n | 快速修复列表 (Trouble) |
| `[q` | n | 上一个Trouble/快速修复项 |
| `]q` | n | 下一个Trouble/快速修复项 |

### 16. 剪贴板增强 (yanky.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>v` | n | 打开复制历史 |
| `y` | n | 复制文本 |
| `p` | n | 粘贴文本 |
| `P` | n | 粘贴文本 (前) |
| `gp` | n | 选择后粘贴 |
| `gP` | n | 选择后粘贴 (前) |
| `[y` | n | 上一个复制历史 |
| `]y` | n | 下一个复制历史 |
| `]p` | n | 缩进粘贴 |
| `[p` | n | 缩进粘贴 (前) |
| `]P` | n | 缩进粘贴 (后) |
| `[P` | n | 缩进粘贴 (前) |
| `>p` | n | 缩进粘贴 (增加) |
| `<p` | n | 缩进粘贴 (减少) |
| `>P` | n | 缩进粘贴 (增加，前) |
| `<P` | n | 缩进粘贴 (减少，前) |
| `=p` | n | 过滤粘贴 |
| `=P` | n | 过滤粘贴 (前) |

### 17. 注释插件组 (comment/)

#### neogen.lua - 注释生成

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>cn` | n | 生成注释 |

#### todo-comments.lua - TODO注释

| 按键 | 模式 | 描述 |
|------|------|------|
| `]t` | n | 下一个TODO注释 |
| `[t` | n | 上一个TODO注释 |
| `<leader>xt` | n | TODO (Trouble) |
| `<leader>xT` | n | TODO (Trouble，全部) |
| `<leader>st` | n | TODO搜索 |
| `<leader>sT` | n | TODO搜索 (全部) |

### 18. AI助手插件组 (llm/)

#### init.lua - AI助手主功能

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>ac` | n | 切换AI聊天 |
| `<leader>aa` | n | 多轮询问AI |
| `<leader>ak` | n | 询问AI |
| `<leader>ae` | n | 代码解释 |
| `<leader>aw` | n | 单词翻译 |
| `<leader>at` | n | AI翻译器 |
| `<leader>aT` | n | 生成测试用例 |
| `<leader>ao` | n | 优化代码 |
| `<leader>ag` | n | 生成AI提交消息 |
| `<leader>ad` | n | 生成文档字符串 |
| `<leader>au` | n | 检查账户信息 |
| `<leader>ab` | n | Bash运行器 |
| `<leader>ai` | n | 公式识别 |

#### keymaps.lua - LLM输入窗口快捷键

| 按键 | 模式 | 描述 |
|------|------|------|
| `<C-g>` | n | 提交输入 |
| `<C-c>` | n | 取消 |
| `<C-r>` | n | 重新发送 |
| `<C-j>` | n | 历史记录 (上一个) |
| `<C-k>` | n | 历史记录 (下一个) |
| `<C-S-J>` | n | 上一个模型 |
| `<C-S-K>` | n | 下一个模型 |
| `i` | n | 在输出窗口询问 |
| `q` | n | 隐藏会话 |
| `<esc>` | n | 关闭会话 |
| `<C-n>` | n | 新会话 |
| `<C-h>` | n | 会话历史 |

### 19. Mini插件组 (mini/)

#### mini.diff.lua - 差异可视化

| 按键 | 模式 | 描述 |
|------|------|------|
| `gh` | n | 应用hunk |
| `gH` | n | 重置hunk |
| `g<CR>` | n | 切换hunk视图 |

#### mini.files.lua - 文件管理器

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>e` | n | 打开Mini文件管理器 |

#### mini.surround.lua - 环绕操作

| 按键 | 模式 | 描述 |
|------|------|------|
| `gsa` | n | 添加环绕 |
| `gsd` | n | 删除环绕 |
| `gsf` | n | 查找右侧环绕 |
| `gsF` | n | 查找左侧环绕 |
| `gsh` | n | 高亮环绕 |
| `gsr` | n | 替换环绕 |
| `gsn` | n | 更新搜索行数 |

### 20. 任务运行器 (overseer.nvim)

| 按键 | 模式 | 描述 |
|------|------|------|
| `<leader>ow` | n | 任务列表 |
| `<leader>oo` | n | 运行任务 |
| `<leader>oq` | n | 快速操作最近任务 |
| `<leader>oi` | n | Overseer信息 |
| `<leader>ob` | n | 任务构建器 |
| `<leader>ot` | n | 任务操作 |
| `<leader>oc` | n | 清除缓存 |

---

## Leader 键分组

| 前缀 | 描述 |
|------|------|
| `<leader>a` | AI功能 |
| `<leader>b` | 缓冲区操作 |
| `<leader>c` | 代码操作 |
| `<leader>d` | 调试功能 |
| `<leader>e` | 文件管理 |
| `<leader>f` | 查找功能 |
| `<leader>g` | Git功能 |
| `<leader>l` | LSP功能 |
| `<leader>o` | 任务运行器 |
| `<leader>p` | 插件管理 |
| `<leader>q` | 会话管理 |
| `<leader>r` | 重构功能 |
| `<leader>R` | HTTP请求 |
| `<leader>s` | 搜索功能 |
| `<leader>t` | 终端功能 |
| `<leader>u` | UI功能 |
| `<leader>w` | 窗口操作 |
| `<leader>x` | 其他功能 |
| `<leader><tab>` | 标签页操作 |