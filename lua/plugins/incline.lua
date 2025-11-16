vim.pack.add({
  { src = "https://github.com/b0o/incline.nvim" },
})

-- local mini_icons = require("mini.icons")
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
      InclineNormal = { default = true, group = "StatusLine" },
      InclineNormalNC = { default = true, group = "StatusLineNC" },
    },
  },
  render = function(props)
    -- local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    -- local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":e")
    -- if filename == "" then
    --   filename = "[No Name]"
    -- end
    -- local ft_icon, ft_color_group = mini_icons.get("file", "file." .. extension)
    --
    -- local hex_color = nil
    -- if ft_color_group then
    --   local hl = vim.api.nvim_get_hl(0, { name = ft_color_group, link = false })
    --   if hl.fg then
    --     hex_color = string.format("#%06x", hl.fg)
    --   end
    -- end

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
      -- if #labels > 0 then
      --   table.insert(labels, { " 󰊢 " .. signs.n_ranges .. " ┊" })
      -- end
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
        table.insert(labels, { " ┊" })
      end
      return labels
    end
    return {
      { get_diagnostics() },
      { get_mini_diff() },
    }
  end,
})
