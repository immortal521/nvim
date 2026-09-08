# Builtin UI：通知与消息总线

`lua/builtin` 提供配置内置 UI 的模块。通知系统由两部分组成：

- `builtin.bus` 负责接收、分发和观察消息。
- `builtin.notify` 负责显示通知、fidget 消息和保存历史。

## 消息总线

消息总线的入口是：

```lua
Builtin.bus.setup()
Builtin.bus.emit(tag, level, content, data)
Builtin.bus.register_subscriber(id, spec)
Builtin.bus.register_observer(id, callback)
Builtin.bus.unsubscribe(id)
```

每条消息包含以下字段：

| 字段 | 说明 |
| --- | --- |
| `id` | 总线生成的递增消息 ID。 |
| `tag` | 消息类别，例如 `notify`、`msg.show.echomsg` 或 `msg.clear`。 |
| `level` | `vim.log.levels` 数值。 |
| `content` | 消息正文。 |
| `data` | 与消息类别相关的附加数据。 |
| `timestamp` | 消息进入总线时的时间戳。 |

订阅可以使用 `exact`、`prefix` 和 `min_level` 过滤：

```lua
Builtin.bus.register_subscriber("example", {
	exact = { "notify" },
	min_level = vim.log.levels.INFO,
	handler = function(message)
		-- 处理 message.content 和 message.data
	end,
})
```

`Builtin.bus.setup()` 是幂等的。初始化后，bus 通过
`vim.ui_attach(..., { ext_messages = true })` 接收 Neovim 的 `msg_show` 和
`msg_clear` 事件，并转换为 `msg.show.<kind>` 和 `msg.clear` 标签。回调中的
总线发送会延迟到安全调度点执行，避免在 UI 回调中直接修改窗口。

普通 `vim.notify()` 使用 `notify` 标签。`msg_show.*` 不再同时交给 notify
和 fidget，避免同一条命令消息显示两次。

## Notify 与 Fidget

配置入口是 `lua/plugins/builtin.lua` 的 `notify`：

```lua
backends = {
	notify = {
		enabled = true,
		anchor = "NE",
		width = 50,
		max_width = 0.45,
	},
	fidget = {
		enabled = true,
		anchor = "SE",
		border = false,
		title = false,
		icon = false,
		padding = 1,
		markdown = true,
		width = 999,
		max_width = 0.95,
	},
}
```

### Notify

`notify` 用于普通 `vim.notify()` 消息：

- 使用标题、图标和边框。
- 宽度由 `backends.notify.width` 和 `backends.notify.max_width` 控制。
- 多个通知堆叠时立即重排，避免入场动画使窗口短暂重叠。
- 鼠标移入、点击或进入窗口后暂停超时计时；移出后恢复计时。
- 窗口可获得焦点，文本可以进入 Visual 模式选择并复制。

### Fidget

`Builtin.notify.fidget(message, level, opts)` 是 fidget 的调用入口。它会自动
继承 `backends.fidget` 的位置、宽度、透明背景、Markdown 和交互配置。

默认 fidget：

- 只显示正文，不显示标题、分隔线或边框。
- 使用自适应宽度，并允许接近编辑器宽度，以优先保证消息可读。
- 使用 `border_hl` 中对应级别的高亮组作为正文颜色。
- 默认不显示图标；设置 `icon` 后只在正文开头显示一个图标。
- 支持鼠标悬停、点击、选择和复制。

如果需要显示图标，可以设置：

```lua
fidget = {
	icon = "󰍩",
}
```

## LSP 进度

LSP 进度属于 LSP 配置，不属于 builtin 模块的事件采集逻辑。入口位于
`lua/config/lsp.lua`，它监听 `LspProgress`，再调用
`Builtin.notify.fidget()` 显示：

```text
lua_ls: Indexing (45%)
```

同一个 LSP client 和 token 会复用同一个 fidget 窗口。进度结束后显示完成状态，
随后按超时配置消失。这样 LSP 只负责解释协议事件，builtin 只负责渲染和历史记录。

## 通知历史与 fzf

`Builtin.notify.history()` 返回通知历史。`lua/sources/notification.lua` 还会
读取 bus 初始化前产生的 `:messages`，补入尚未记录的消息。

`<leader>n` 打开的通知 source 默认不合并 notify 条目：

- `append = true` 的 fidget 历史记录，按 `notification_id` 合并为一个条目。
- 合并内容按历史 `index` 顺序追加，预览中保留完整消息列表。
- notify、replace 模式的 fidget 和补入的 `messages` 都分别保留。

如果新增 backend，需要同时决定它的 bus 标签、历史 backend 名称和显示样式；只有明确
需要追加的 fidget 消息才应设置 `append = true`，并提供稳定的 `id`。

## 验证

```sh
stylua --check lua/builtin lua/config/lsp.lua lua/plugins/builtin.lua
git diff --check
```
