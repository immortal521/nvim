# Toolchain 配置

`lua/toolchain` 是语言和开发工具配置的统一入口：

- `toolchain/lang/specs/*.lua` 描述语言、filetype、LSP、Treesitter，以及该语言使用的 formatter/linter 名称。
- `toolchain/tool/specs/*.lua` 描述工具自己的可用条件和 Conform 配置，例如项目中是否存在该工具的配置文件。
- `toolchain/mason.lua` 将 LSP、formatter、linter 名称映射为 Mason 包名，并保留调试和辅助工具。
- `toolchain/init.lua` 聚合这些配置，供 LSP、Conform、nvim-lint、Mason、Treesitter 和 fzf source 使用。

## 目录结构

```text
lua/toolchain/
├── init.lua
├── README.md
├── mason.lua
├── lang/
│   ├── init.lua
│   └── specs/
│       ├── lua.lua
│       ├── python.lua
│       └── ...
└── tool/
    ├── init.lua
    └── specs/
        ├── prettier.lua
        ├── biome.lua
        └── oxfmt.lua
```

语言和工具规格目录中的每个 `.lua` 文件都会被自动扫描。不要在这两个
`specs/` 目录中放置模板 Lua 文件、测试文件或返回非规格内容的 Lua 文件，
否则启动时会被当作配置加载并产生警告。文档和模板应放在 `toolchain/`
根目录或 Markdown 文件中。

## 语言规格

例如 `lua/toolchain/lang/specs/zig.lua`：

```lua
---@type LangDefinition
return {
	filetypes = { "zig" },
	formatters = { "zigfmt" },
	lsp = { "zls" },
	treesitter = { "zig" },
}
```

`filetypes` 是必填的非空字符串数组，必须填写 Neovim 实际使用的
`vim.bo.filetype`，而不是文件扩展名。例如 React 文件使用
`javascriptreact` 或 `typescriptreact`。

支持的字段：

| 字段 | 类型 | 作用 |
| --- | --- | --- |
| `filetypes` | `string[]` | 语言对应的 Neovim filetype，必填。 |
| `formatters` | `string[]` | 该语言的 Conform formatter 名称。 |
| `linters` | `string[]` | 该语言的 nvim-lint linter 名称。 |
| `lint_filetypes` | `string[]` | 实际运行 lint 的 filetype；省略时使用 `filetypes`。 |
| `lsp` | `string[]` | 打开对应 filetype 时按需启用的 LSP 名称。 |
| `treesitter` | `string[]` | 要安装和启用的 Treesitter parser 名称。 |

即使只有一个值也使用数组形式，例如 `{ "stylua" }`。同一 filetype 被多个
语言规格声明时，formatter、linter、LSP 和 Treesitter 聚合查询会去重。

Treesitter 插件会把规格中的 parser 和 filetype 自动加入现有基础列表。parser
只传给 `TS.install()`，filetype 只用于 `FileType` 自动命令；因此
`typescriptreact`、`markdown.mdx` 等 Neovim filetype 不会被误当作 parser。
未拆分为语言规格的额外 parser 仍由 `lua/plugins/highlight/treesitter.lua`
保留。

LSP 的具体命令、root、settings 和特殊行为仍放在顶层 `lsp/` 目录：

```text
lsp/pyright.lua
lsp/ruff.lua
```

语言规格只决定哪些语言使用它；修改 LSP 实现细节时修改对应的
`lsp/<名称>.lua`。

Neovim 配置中的 Lua 使用 `lua_ls`。它的 `vim` 全局、Neovim runtime、配置
目录和 LuaJIT 环境写在配置根目录的 `.luarc.json` 中；不要把这些 workspace
library 设置复制到 `lsp/lua_ls.lua`。后者只负责声明启动命令、filetype 和
项目根标记。

## 工具规格

工具规格负责工具自己的可用条件。以 Prettier 为例：

```lua
local configs = {
	".prettierrc",
	".prettierrc.json",
	"prettier.config.js",
}

---@type ToolDefinition
return {
	formatter = {
		condition = function(_, ctx)
			return #vim.fs.find(configs, {
				path = vim.fs.dirname(ctx.filename),
				upward = true,
				stop = vim.uv.os_homedir(),
			}) > 0
		end,
	},
}
```

`formatter.condition` 是 Conform formatter condition，返回 `true` 才会让
该 formatter 可用。工具条件不负责决定语言是否使用它；语言与工具的关联
仍由 `toolchain/lang/specs/*.lua` 中的 `formatters` 字段声明。

当前可选 formatter 的条件：

- Prettier：找到 Prettier 配置文件后才生效。
- Biome：找到 `biome.json` 或 `biome.jsonc` 后才生效。
- Oxfmt：找到 Oxfmt 配置文件后生效；当项目没有 Prettier、Biome、Oxfmt
  配置时，作为默认 fallback 生效。

这些条件位于：

```text
lua/toolchain/tool/specs/prettier.lua
lua/toolchain/tool/specs/biome.lua
lua/toolchain/tool/specs/oxfmt.lua
```

修改工具配置文件探测规则时，只修改对应工具规格，不要把条件逻辑重新写回
`lua/plugins/formatting.lua`。

Conform 当前仍使用 formatter 列表的默认行为：如果多个 formatter 条件同时
满足，且调用时没有设置 `stop_after_first = true`，Conform 可能按顺序执行多个
formatter。工具规格只决定工具是否可用，不改变这个执行策略。

跨语言的兼容映射仍由 `toolchain/lang/init.lua` 维护：

- `graphql`：`prettier`、`biome`、`oxfmt`
- `handlebars`：`prettier`、`biome`、`oxfmt`
- `luau`：`stylua`

## Lint 规则

如果某些 filetype 不应运行 lint，使用 `lint_filetypes`，例如：

```lua
filetypes = { "typescript", "typescriptreact" },
linters = { "eslint", "oxlint" },
lint_filetypes = { "typescript" },
```

这就是 JavaScript/TypeScript 排除 React filetype 的方式。不要从
`filetypes` 中删除 React 类型，否则会同时影响 LSP 和 formatter。

## 新增语言

以新增 Zig 为例：

1. 确认 Neovim 的 filetype 是 `zig`。
2. 新建 `lua/toolchain/lang/specs/zig.lua`，至少填写 `filetypes`。
3. 按需补充 `formatters`、`linters`、`lsp` 和 `treesitter`。
4. 如果 LSP 名称没有对应的 `lsp/<名称>.lua`，新建该文件。
5. 如果工具需要配置文件条件，在 `toolchain/tool/specs/` 中新增或修改对应工具规格。
6. 打开该语言文件，确认 LSP、格式化、lint 和 Treesitter 行为。

新增语言不需要修改语言列表，也不需要手动加入 fzf source；`<leader>cL`
会自动显示新语言规格。

## 修改已有配置

- 改变语言与 filetype 的关系：修改 `toolchain/lang/specs/*.lua` 的 `filetypes`。
- 改变语言使用哪些工具：修改语言规格的 `formatters` 或 `linters`。
- 改变工具是否可用：修改 `toolchain/tool/specs/<tool>.lua` 的条件。
- 改变 LSP 命令、root 或 settings：修改 `lsp/<名称>.lua`。
- 改变 Treesitter 基础语言列表：修改 `lua/plugins/highlight/treesitter.lua`。
- 改变跨语言兼容 formatter：修改 `lua/toolchain/lang/init.lua` 的显式映射。

不要把项目路径写入语言或工具规格；这些规格必须能复用在不同工作区。

## Mason 自动安装

启动时 Mason 会调用 `toolchain.get_mason_packages()`，根据当前语言规格中
实际声明的 LSP、formatter 和 linter 自动安装对应包。Mason 包名与运行时
名称可能不同，例如：

| 运行时名称 | Mason 包名 |
| --- | --- |
| `rust_analyzer` | `rust-analyzer` |
| `clang_format` | `clang-format` |
| `golangcilint` | `golangci-lint` |
| `ruff_format` | `ruff` |

名称映射位于 `lua/toolchain/mason.lua`。新增 LSP、formatter 或 linter 时，
如果它没有使用相同的 Mason 包名，需要在该映射中补充；否则它会继续被配置
使用，但 Mason 不会自动安装它。

调试适配器和通用辅助工具仍在 `extra_packages` 中维护，不会因为当前语言
没有打开而被移除。Mason 注册表刷新失败或包不存在时，安装动作由 Mason
自身报告失败，不会阻止语言规格加载。

## 验证

```sh
stylua --check lua/toolchain lua/plugins/highlight/treesitter.lua lua/sources/language.lua
git diff --check
```

检查规格加载和聚合：

```sh
nvim --headless -u NONE \
  '+set rtp^=/home/immortal/.config/nvim' \
  '+lua local tc=require("toolchain"); assert(#tc.lang.source_items() > 0); assert(tc.get_formatter_configs().prettier); print("toolchain specs passed")' \
  '+qa!'
```

`<leader>cL` 显示语言名和 filetype，预览显示语言规格源码，默认选择直接
打开对应的 `toolchain/lang/specs/<语言名>.lua` 文件。
