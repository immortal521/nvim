local M = {}

M.kind_icon = {
  text = function(ctx)
    local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
    return icon .. (ctx.icon_gap or "")
  end,
  highlight = function(ctx)
    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
    return hl
  end,
}

M.kind = {
  highlight = function(ctx)
    if vim.tbl_contains({ "Path" }, ctx.source_name) then
      local mini_icon, mini_hl = require("mini.icons").get("default", ctx.item.data.type)
      if mini_icon then
        return mini_hl
      end
    end
    return ctx.kind_hl
  end,
}

M.label = {
  width = { fill = true, max = 30 },
  text = function(ctx)
    return require("colorful-menu").blink_components_text(ctx)
  end,
  highlight = function(ctx)
    return require("colorful-menu").blink_components_highlight(ctx)
  end,
}

M.label_description = {
  width = { max = 30 },
  text = function(ctx)
    return ctx.label_description
  end,
  highlight = "BlinkCmpLabelDescription",
}

return M
