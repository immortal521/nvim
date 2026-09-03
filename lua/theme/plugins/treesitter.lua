---@class treesitter.Highlights
local M = {}

---@param palette theme.Palette
---@param opts? table
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local ret = {
		-----------------------------------------------------------------------
		-- Annotations & Attributes
		-----------------------------------------------------------------------
		["@annotation"] = { fg = palette.pink },
		["@attribute"] = { fg = palette.yellow },

		-----------------------------------------------------------------------
		-- Booleans, Characters & Numbers
		-----------------------------------------------------------------------
		["@boolean"] = "Boolean",
		["@character"] = "Character",
		["@character.printf"] = { fg = palette.teal },
		["@character.special"] = { fg = palette.teal },
		["@number"] = "Number",
		["@number.float"] = "Float",

		-----------------------------------------------------------------------
		-- Comments & Todo Keywords
		-----------------------------------------------------------------------
		["@comment"] = "Comment",
		["@comment.error"] = { fg = palette.diag.error, bold = true },
		["@comment.warning"] = { fg = palette.diag.warn, bold = true },
		["@comment.info"] = { fg = palette.diag.info, bold = true },
		["@comment.hint"] = { fg = palette.diag.hint, bold = true },
		["@comment.todo"] = { fg = palette.bg, bg = palette.yellow, bold = true },
		["@comment.note"] = { fg = palette.bg, bg = palette.teal, bold = true },

		-----------------------------------------------------------------------
		-- Constants & Literals
		-----------------------------------------------------------------------
		["@constant"] = "Constant",
		["@constant.builtin"] = { fg = palette.peach, bold = true },
		["@constant.macro"] = { fg = palette.mauve },

		-----------------------------------------------------------------------
		-- Functions & Methods
		-----------------------------------------------------------------------
		["@constructor"] = { fg = palette.sapphire },
		["@function"] = "Function",
		["@function.builtin"] = { fg = palette.peach },
		["@function.call"] = "@function",
		["@function.macro"] = { fg = palette.mauve },
		["@function.method"] = "Function",
		["@function.method.call"] = "@function.method",

		-----------------------------------------------------------------------
		-- Keywords & Operators
		-----------------------------------------------------------------------
		["@keyword"] = { fg = palette.mauve, italic = true },
		["@keyword.conditional"] = "Conditional",
		["@keyword.coroutine"] = { fg = palette.mauve, italic = true },
		["@keyword.debug"] = "Debug",
		["@keyword.directive"] = { fg = palette.pink },
		["@keyword.directive.define"] = { fg = palette.pink },
		["@keyword.exception"] = { fg = palette.maroon, italic = true },
		["@keyword.function"] = { fg = palette.mauve, italic = true },
		["@keyword.import"] = { fg = palette.pink, italic = true },
		["@keyword.operator"] = { fg = palette.sky },
		["@keyword.repeat"] = "Repeat",
		["@keyword.return"] = { fg = palette.mauve, bold = true, italic = true },
		["@keyword.storage"] = "StorageClass",

		-----------------------------------------------------------------------
		-- Labels & Operators
		-----------------------------------------------------------------------
		["@label"] = { fg = palette.sapphire },
		["@operator"] = { fg = palette.sky },

		-----------------------------------------------------------------------
		-- Modules & Namespaces
		-----------------------------------------------------------------------
		["@module"] = { fg = palette.lavender },
		["@module.builtin"] = { fg = palette.red },
		["@namespace"] = "@module",
		["@namespace.builtin"] = "@module.builtin",

		-----------------------------------------------------------------------
		-- Objects, Properties & Members
		-----------------------------------------------------------------------
		["@property"] = { fg = palette.teal },

		-----------------------------------------------------------------------
		-- Punctuation
		-----------------------------------------------------------------------
		["@punctuation.bracket"] = { fg = palette.fg_muted },
		["@punctuation.delimiter"] = { fg = palette.fg_muted }, -- 修正：移除不存在的 overlay2
		["@punctuation.special"] = { fg = palette.sky },

		-----------------------------------------------------------------------
		-- Strings & Escape Sequences
		-----------------------------------------------------------------------
		["@string"] = "String",
		["@string.documentation"] = { fg = palette.yellow, italic = true },
		["@string.escape"] = { fg = palette.pink },
		["@string.regexp"] = { fg = palette.mauve },
		["@string.special"] = "SpecialChar",

		-----------------------------------------------------------------------
		-- HTML / JSX Tags
		-----------------------------------------------------------------------
		["@tag"] = { fg = palette.mauve },
		["@tag.attribute"] = { fg = palette.teal },
		["@tag.delimiter"] = { fg = palette.sky },

		-----------------------------------------------------------------------
		-- Types & Definitions
		-----------------------------------------------------------------------
		["@type"] = "Type",
		["@type.builtin"] = { fg = palette.yellow, bold = true },
		["@type.definition"] = "Typedef",
		["@type.qualifier"] = "@keyword",

		-----------------------------------------------------------------------
		-- Variables & Parameters
		-----------------------------------------------------------------------
		["@variable"] = { fg = palette.fg },
		["@variable.builtin"] = { fg = palette.red },
		["@variable.member"] = { fg = palette.teal },
		["@variable.parameter"] = { fg = palette.peach, italic = true },
		["@variable.parameter.builtin"] = { fg = palette.red, italic = true },

		-----------------------------------------------------------------------
		-- Markup & Markdown (Nvim 0.10+)
		-----------------------------------------------------------------------
		["@markup"] = { fg = palette.fg },
		["@markup.emphasis"] = { italic = true },
		["@markup.strong"] = { bold = true },
		["@markup.italic"] = { italic = true },
		["@markup.strikethrough"] = { strikethrough = true },
		["@markup.underline"] = { underline = true },

		["@markup.heading"] = { fg = palette.primary, bold = true }, -- 主阶标题与主基调对齐
		["@markup.heading.1"] = { fg = palette.primary_bright, bold = true },
		["@markup.heading.2"] = { fg = palette.primary, bold = true },
		["@markup.heading.3"] = { fg = palette.primary_dim, bold = true },
		["@markup.heading.4"] = { fg = palette.teal, bold = true },
		["@markup.heading.5"] = { fg = palette.peach, bold = true },
		["@markup.heading.6"] = { fg = palette.flamingo, bold = true },

		["@markup.link"] = { fg = palette.rosewater },
		["@markup.link.label"] = { fg = palette.primary }, -- 超链接文本采用 primary
		["@markup.link.url"] = { fg = palette.fg_muted, underline = true },

		["@markup.list"] = { fg = palette.primary },
		["@markup.list.checked"] = { fg = palette.green },
		["@markup.list.unchecked"] = { fg = palette.fg_muted },
		["@markup.list.markdown"] = { fg = palette.peach, bold = true },

		["@markup.math"] = { fg = palette.sky },
		["@markup.environment"] = { fg = palette.pink },
		["@markup.environment.name"] = { fg = palette.sapphire },

		["@markup.raw"] = { fg = palette.green },
		["@markup.raw.markdown_inline"] = {
			fg = palette.primary_bright,
			bg = palette.bg_highlight,
		},
		["@markup.raw.block"] = { fg = palette.fg, bg = palette.bg_dim },

		-----------------------------------------------------------------------
		-- Diff Syntax (Treesitter Standard)
		-----------------------------------------------------------------------
		["@diff.plus"] = { fg = palette.git.add },
		["@diff.minus"] = { fg = palette.git.delete },
		["@diff.delta"] = { fg = palette.git.change },

		["@none"] = {},
	}

	return ret
end

return M
