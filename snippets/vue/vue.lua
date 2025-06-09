local ls = require("luasnip")

-- 定义你的代码片段
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("vue", {
  s("tem", {
    t('<script setup lang="'),
    i(1, "ts"),
    t('">'),
    t({ "", "", "</script>" }),
    t({ "", "", "<template>" }),
    t({ "", "", "</template>" }),
    t({ "", "", '<style lang="' }),
    i(2, "scss"),
    t('" scoped>'),
    t({ "", "", "</style>" }),
    i(0),
  }, { description = "Vue 3 Single File Component Template" }),
})
