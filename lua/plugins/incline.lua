vim.pack.add({
  { src = "https://github.com/b0o/incline.nvim" },
})

local mini_icons = require("mini.icons")
require("incline").setup({
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":e")
    if filename == "" then
      filename = "[No Name]"
    end
    local ft_icon, ft_color_group = mini_icons.get("file", "file." .. extension)

    local hex_color = nil
    if ft_color_group then
      local hl = vim.api.nvim_get_hl(0, { name = ft_color_group, link = false })
      if hl.fg then
        hex_color = string.format("#%06x", hl.fg)
      end
    end

    local function get_git_diff()
      local icons = { removed = "", changed = "", added = "" }
      local summary = vim.b[props.buf].minidiff_summary
      local labels = {}
      if not summary then
        return labels
      end
      for name, icon in pairs(icons) do
        local count = summary[name]
        if tonumber(count) and count > 0 then
          table.insert(labels, { icon .. count .. " ", group = "Diff" .. name })
        end
      end
      if #labels > 0 then
        table.insert(labels, { "┊ " })
      end
      return labels
    end

    local function get_diagnostic_label()
      local icons = { error = "", warn = "", info = "", hint = "" }
      local label = {}

      for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
          table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
        end
      end
      if #label > 0 then
        table.insert(label, { "┊ " })
      end
      return label
    end

    return {
      { get_diagnostic_label() },
      { get_git_diff() },
      { (ft_icon or "") .. " ", guifg = hex_color, guibg = "none" },
      { filename .. " ", gui = "bold,italic" },
    }
  end,
})
