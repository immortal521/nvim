local MiniIcons = require("mini.icons")

vim.pack.add({
  { src = "https://github.com/b0o/incline.nvim" },
})

require("incline").setup({
  window = {
    padding = 0,
    margin = { horizontal = 0 },
  },
  ignore = {
    buftypes = "special",
    filetypes = { "oil" },
    floating_wins = true,
    unlisted_buffers = true,
    wintypes = "special",
  },
  highlight = {
    groups = {
      InclineNormal = { default = true, group = "Normal" },
      InclineNormalNC = { default = true, group = "NormalNC" },
    },
  },
  render = function(props)
    local function get_buffer_filename()
      -- 获取所有已列出的 buffer
      local bufs = Utils.get_bufs()

      if #bufs > 1 then
        return nil
      end

      -- 获取文件名和扩展名
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":e")
      if filename == "" then
        filename = "[No Name]"
      end

      -- 获取文件图标和颜色
      local ft_icon, ft_color_group = MiniIcons.get("file", "file." .. extension)

      local hex_color = nil
      if ft_color_group then
        local hl = vim.api.nvim_get_hl(0, { name = ft_color_group, link = false })
        if hl.fg then
          hex_color = string.format("#%06x", hl.fg)
        end
      end

      return {
        { (ft_icon or "") .. " ", guifg = hex_color, guibg = "none" },
        { filename .. " ", gui = "italic" },
      }
    end

    local function get_mini_diff()
      local icons = {
        add = " ",
        change = " ",
        delete = " ",
      }
      local signs = vim.b[props.buf].minidiff_summary

      local labels = {}
      if signs == nil then
        return labels
      end
      for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
          table.insert(labels, { " ", icon .. signs[name], group = "MiniDiffSign" .. name })
        end
      end
      if #labels > 0 then
        table.insert(labels, { " " })
      end
      return labels
    end

    local function get_diagnostics()
      local icons = {
        error = " ",
        warn = " ",
        info = " ",
        hint = " ",
      }
      local labels = {}

      for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
          table.insert(labels, { " " .. icon .. n, group = "DiagnosticSign" .. severity })
        end
      end
      if #labels > 0 then
        table.insert(labels, { " " })
      end
      return labels
    end

    local result = {}

    table.insert(result, {
      { get_diagnostics() },
      { get_mini_diff() },
      { get_buffer_filename() },
    })

    return result
  end,
})
