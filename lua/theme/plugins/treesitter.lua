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
		["@annotation"] = "PreProc",
		["@attribute"] = { fg = palette.purple },

		-----------------------------------------------------------------------
		-- Booleans, Characters & Numbers
		-----------------------------------------------------------------------
		["@boolean"] = "Boolean",
		["@character"] = "Character",
		["@character.printf"] = "SpecialChar",
		["@character.special"] = "SpecialChar",
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
		["@comment.note"] = { fg = palette.bg, bg = palette.cyan, bold = true },

		-----------------------------------------------------------------------
		-- Constants & Literals
		-----------------------------------------------------------------------
		["@constant"] = "Constant",
		["@constant.builtin"] = { fg = palette.orange, bold = true },
		["@constant.macro"] = { fg = palette.pink },

		-----------------------------------------------------------------------
		-- Functions & Methods
		-----------------------------------------------------------------------
		["@constructor"] = { fg = palette.cyan },
		["@function"] = "Function",
		["@function.builtin"] = { fg = palette.blue_bright },
		["@function.call"] = "@function",
		["@function.macro"] = { fg = palette.pink },
		["@function.method"] = "Function",
		["@function.method.call"] = "@function.method",

		-----------------------------------------------------------------------
		-- Keywords & Operators
		-----------------------------------------------------------------------
		["@keyword"] = { fg = palette.purple, italic = true },
		["@keyword.conditional"] = "Conditional",
		["@keyword.coroutine"] = { fg = palette.purple, italic = true },
		["@keyword.debug"] = "Debug",
		["@keyword.directive"] = { fg = palette.pink },
		["@keyword.directive.define"] = { fg = palette.pink },
		["@keyword.exception"] = { fg = palette.red, italic = true },
		["@keyword.function"] = { fg = palette.purple, italic = true },
		["@keyword.import"] = { fg = palette.pink, italic = true },
		["@keyword.operator"] = { fg = palette.blue_dim },
		["@keyword.repeat"] = "Repeat",
		["@keyword.return"] = { fg = palette.purple, bold = true, italic = true },
		["@keyword.storage"] = "StorageClass",

		-----------------------------------------------------------------------
		-- Labels & Operators
		-----------------------------------------------------------------------
		["@label"] = { fg = palette.blue },
		["@operator"] = { fg = palette.blue_dim },

		-----------------------------------------------------------------------
		-- Modules & Namespaces
		-----------------------------------------------------------------------
		["@module"] = { fg = palette.yellow },
		["@module.builtin"] = { fg = palette.red },
		["@namespace"] = "@module",
		["@namespace.builtin"] = "@module.builtin",

		-----------------------------------------------------------------------
		-- Objects, Properties & Members
		-----------------------------------------------------------------------
		["@property"] = { fg = palette.cyan },

		-----------------------------------------------------------------------
		-- Punctuation
		-----------------------------------------------------------------------
		["@punctuation.bracket"] = { fg = palette.fg_muted },
		["@punctuation.delimiter"] = { fg = palette.fg_muted },
		["@punctuation.special"] = { fg = palette.blue_bright },

		-----------------------------------------------------------------------
		-- Strings & Escape Sequences
		-----------------------------------------------------------------------
		["@string"] = "String",
		["@string.documentation"] = { fg = palette.yellow, italic = true },
		["@string.escape"] = { fg = palette.pink },
		["@string.regexp"] = { fg = palette.blue_bright },
		["@string.special"] = "SpecialChar",

		-----------------------------------------------------------------------
		-- HTML / JSX Tags
		-----------------------------------------------------------------------
		["@tag"] = { fg = palette.purple },
		["@tag.attribute"] = { fg = palette.yellow },
		["@tag.delimiter"] = { fg = palette.fg_muted },

		-----------------------------------------------------------------------
		-- Types & Definitions
		-----------------------------------------------------------------------
		["@type"] = "Type",
		["@type.builtin"] = { fg = palette.cyan, bold = true },
		["@type.definition"] = "Typedef",
		["@type.qualifier"] = "@keyword",

		-----------------------------------------------------------------------
		-- Variables & Parameters
		-----------------------------------------------------------------------
		["@variable"] = { fg = palette.fg },
		["@variable.builtin"] = { fg = palette.red },
		["@variable.member"] = { fg = palette.cyan },
		["@variable.parameter"] = { fg = palette.fg_muted, italic = true },
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

		["@markup.heading"] = { fg = palette.blue, bold = true },
		["@markup.heading.1"] = { fg = palette.purple, bold = true },
		["@markup.heading.2"] = { fg = palette.blue, bold = true },
		["@markup.heading.3"] = { fg = palette.green, bold = true },
		["@markup.heading.4"] = { fg = palette.yellow, bold = true },

		["@markup.link"] = { fg = palette.cyan },
		["@markup.link.label"] = { fg = palette.blue },
		["@markup.link.url"] = { fg = palette.fg_muted, underline = true },

		["@markup.list"] = { fg = palette.blue },
		["@markup.list.checked"] = { fg = palette.green },
		["@markup.list.unchecked"] = { fg = palette.fg_muted },
		["@markup.list.markdown"] = { fg = palette.orange, bold = true },

		["@markup.math"] = { fg = palette.blue_bright },
		["@markup.environment"] = { fg = palette.pink },
		["@markup.environment.name"] = { fg = palette.cyan },

		["@markup.raw"] = { fg = palette.green },
		["@markup.raw.markdown_inline"] = {
			fg = palette.blue_bright,
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
