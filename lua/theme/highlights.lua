local M = {}

---@param palette theme.Palette
---@param transparent boolean
function M.setup(palette, transparent)
    local bg = transparent and "NONE" or palette.bg
    local bg_dim = transparent and "NONE" or palette.bg_dim
    local bg_deep = transparent and "NONE" or palette.bg_deep
    local bg_highlight = transparent and "NONE" or palette.bg_highlight

    -- Float 专用背景与边框处理
    local float_bg = transparent and "NONE" or palette.float.bg
    local float_border = palette.float.border

    local groups = {
        -----------------------------------------------------------------------
        -- Editor Core
        -----------------------------------------------------------------------
        Normal = { fg = palette.fg, bg = bg },
        NormalNC = { fg = palette.fg, bg = bg },
        NormalFloat = { fg = palette.float.fg, bg = float_bg },
        FloatBorder = { fg = float_border, bg = float_bg },
        FloatTitle = { fg = palette.blue, bg = float_bg, bold = true },
        FloatFooter = { fg = palette.fg_muted, bg = float_bg },

        EndOfBuffer = { fg = palette.bg, bg = bg }, -- 隐藏 ~ 符号
        SignColumn = { fg = palette.fg_gutter, bg = bg },
        Cursor = { fg = palette.bg, bg = palette.fg },
        TermCursor = { fg = palette.bg, bg = palette.fg },
        CursorLine = { bg = palette.cursor_line },
        CursorColumn = { bg = palette.cursor_line },

        LineNr = { fg = palette.fg_gutter, bg = bg },
        CursorLineNr = { fg = palette.fg, bg = bg, bold = true },
        LineNrAbove = { fg = palette.fg_gutter },
        LineNrBelow = { fg = palette.fg_gutter },

        FoldColumn = { fg = palette.fg_gutter, bg = bg },
        Folded = { fg = palette.fg_muted, bg = bg_dim },

        WinSeparator = { fg = palette.border, bg = bg },
        VertSplit = { fg = palette.border, bg = bg },

        -----------------------------------------------------------------------
        -- UI Controls & Selection
        -----------------------------------------------------------------------
        Visual = { bg = palette.selection },
        VisualNOS = { bg = palette.selection },

        Search = { fg = palette.fg, bg = palette.bg_search },
        IncSearch = { fg = palette.bg, bg = palette.orange, bold = true },
        CurSearch = { link = "IncSearch" },

        MatchParen = { fg = palette.orange, bg = palette.bg_highlight, bold = true },
        Directory = { fg = palette.blue },
        Title = { fg = palette.blue, bold = true },
        Question = { fg = palette.blue },
        MoreMsg = { fg = palette.blue },
        ModeMsg = { fg = palette.fg, bold = true },
        WarningMsg = { fg = palette.diag.warn },
        ErrorMsg = { fg = palette.diag.error, bold = true },

        SpecialKey = { fg = palette.fg_gutter },
        NonText = { fg = palette.fg_gutter },
        Whitespace = { fg = palette.fg_gutter },
        Conceal = { fg = palette.fg_muted },

        WildMenu = { fg = palette.fg, bg = palette.bg_highlight },

        -----------------------------------------------------------------------
        -- Popup Menu (Pmenu)
        -----------------------------------------------------------------------
        Pmenu = { fg = palette.fg, bg = bg_dim },
        PmenuSel = { fg = palette.fg, bg = palette.selection, bold = true },
        PmenuSbar = { bg = palette.bg_highlight },
        PmenuThumb = { bg = palette.fg_muted },

        -----------------------------------------------------------------------
        -- Tabline / Statusline
        -----------------------------------------------------------------------
        StatusLine = { fg = palette.statusline.active, bg = transparent and "NONE" or palette.statusline.bg },
        StatusLineNC = { fg = palette.statusline.inactive, bg = transparent and "NONE" or palette.bg_deep },
        TabLine = { fg = palette.fg_muted, bg = bg_dim },
        TabLineFill = { bg = bg_deep },
        TabLineSel = { fg = palette.fg, bg = bg_highlight, bold = true },

        WinBar = { link = "StatusLine" },
        WinBarNC = { link = "StatusLineNC" },

        -----------------------------------------------------------------------
        -- Syntax Highlighting (Standard Vim)
        -----------------------------------------------------------------------
        Bold = { fg = palette.fg, bold = true },
        Italic = { fg = palette.fg, italic = true },
        Comment = { fg = palette.comment, italic = true },

        Constant = { fg = palette.orange },
        String = { fg = palette.green },
        Character = { fg = palette.green },
        Number = { fg = palette.orange },
        Boolean = { fg = palette.orange },
        Float = { fg = palette.orange },

        Identifier = { fg = palette.fg },
        Function = { fg = palette.blue },
        Statement = { fg = palette.purple },
        Conditional = { fg = palette.purple },
        Repeat = { fg = palette.purple },
        Label = { fg = palette.blue },
        Operator = { fg = palette.blue_dim },
        Keyword = { fg = palette.purple, italic = true },
        Exception = { fg = palette.red },

        PreProc = { fg = palette.pink },
        Include = { fg = palette.pink },
        Define = { fg = palette.pink },
        Macro = { fg = palette.pink },
        PreCondit = { fg = palette.pink },

        Type = { fg = palette.cyan },
        StorageClass = { fg = palette.purple },
        Structure = { fg = palette.cyan },
        Typedef = { fg = palette.cyan },

        Special = { fg = palette.blue_bright },
        SpecialComment = { fg = palette.comment },
        Delimiter = { fg = palette.fg_muted },

        Underlined = { underline = true },
        Todo = { fg = palette.bg, bg = palette.yellow, bold = true },

        -----------------------------------------------------------------------
        -- Diagnostics
        -----------------------------------------------------------------------
        DiagnosticError = { fg = palette.diag.error },
        DiagnosticWarn = { fg = palette.diag.warn },
        DiagnosticInfo = { fg = palette.diag.info },
        DiagnosticHint = { fg = palette.diag.hint },
        DiagnosticUnnecessary = { fg = palette.fg_gutter },

        DiagnosticUnderlineError = { undercurl = true, sp = palette.diag.error },
        DiagnosticUnderlineWarn = { undercurl = true, sp = palette.diag.warn },
        DiagnosticUnderlineInfo = { undercurl = true, sp = palette.diag.info },
        DiagnosticUnderlineHint = { undercurl = true, sp = palette.diag.hint },

        DiagnosticVirtualTextError = { fg = palette.diag.error, bg = palette.diag.bg_error },
        DiagnosticVirtualTextWarn = { fg = palette.diag.warn, bg = palette.diag.bg_warn },
        DiagnosticVirtualTextInfo = { fg = palette.diag.info, bg = palette.diag.bg_info },
        DiagnosticVirtualTextHint = { fg = palette.diag.hint, bg = palette.diag.bg_hint },

        -----------------------------------------------------------------------
        -- LSP
        -----------------------------------------------------------------------
        LspReferenceText = { bg = palette.bg_highlight },
        LspReferenceRead = { bg = palette.bg_highlight },
        LspReferenceWrite = { bg = palette.bg_highlight },
        LspSignatureActiveParameter = { bg = palette.bg_highlight, bold = true },
        LspCodeLens = { fg = palette.comment },
        LspInlayHint = { fg = palette.fg_gutter, bg = transparent and "NONE" or palette.bg_deep },

        -----------------------------------------------------------------------
        -- Diff & Git (标准 Diff 与 Git 映射)
        -----------------------------------------------------------------------
        DiffAdd = { bg = palette.diff.add },
        DiffChange = { bg = palette.diff.change },
        DiffDelete = { bg = palette.diff.delete },
        DiffText = { bg = palette.diff.text, bold = true },

        diffAdded = { fg = palette.git.add },
        diffRemoved = { fg = palette.git.delete },
        diffChanged = { fg = palette.git.change },

        -----------------------------------------------------------------------
        -- Misc & Health
        -----------------------------------------------------------------------
        helpCommand = { fg = palette.blue, bg = palette.terminal_black },
        helpExample = { fg = palette.comment },
        qfFileName = { fg = palette.blue },
        qfLineNr = { fg = palette.fg_gutter },
        healthError = { fg = palette.diag.error },
        healthSuccess = { fg = palette.green },
        healthWarning = { fg = palette.diag.warn },
        debugPC = { bg = palette.bg_highlight },
        debugBreakpoint = { fg = palette.red, bg = palette.bg_highlight },
    }

    -- 循环批量应用所有的 Highlight Group
    for name, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

return M
