---@class treesitter.Highlights
local M = {}

---@param palette theme.Palette
---@param _? theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, _)
	local ret = {
		-----------------------------------------------------------------------
		-- Annotations & Attributes
		-----------------------------------------------------------------------
		["@annotation"] = { fg = palette.maroon, bold = true },
		["@attribute"] = { fg = palette.yellow },

		-----------------------------------------------------------------------
		-- Booleans, Characters & Numbers
		-----------------------------------------------------------------------
		["@boolean"] = { fg = palette.peach, bold = true },
		["@character"] = "Character",
		["@character.printf"] = { fg = palette.teal, bold = true },
		["@character.special"] = { fg = palette.teal, bold = true },
		["@number"] = { fg = palette.peach },
		["@number.float"] = { fg = palette.peach },

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
		["@constant.macro"] = { fg = palette.purple, bold = true },

		-----------------------------------------------------------------------
		-- Functions & Methods
		-----------------------------------------------------------------------
		["@constructor"] = { fg = palette.primary_bright, bold = true },
		["@function"] = { fg = palette.blue, bold = true },
		["@function.builtin"] = { fg = palette.peach, bold = true },
		["@function.call"] = { fg = palette.blue },
		["@function.macro"] = { fg = palette.purple },
		["@function.method"] = { fg = palette.blue },
		["@function.method.call"] = { fg = palette.blue },

		-----------------------------------------------------------------------
		-- Keywords & Operators
		-----------------------------------------------------------------------
		["@keyword"] = { fg = palette.purple, italic = true },
		["@keyword.conditional"] = { fg = palette.purple, italic = true, bold = true },
		["@keyword.coroutine"] = { fg = palette.purple, italic = true },
		["@keyword.debug"] = "Debug",
		["@keyword.directive"] = { fg = palette.maroon },
		["@keyword.directive.define"] = { fg = palette.maroon, bold = true },
		["@keyword.exception"] = { fg = palette.maroon, bold = true, italic = true },
		["@keyword.function"] = { fg = palette.purple, italic = true },
		["@keyword.import"] = { fg = palette.maroon, italic = true },
		["@keyword.operator"] = { fg = palette.sapphire, bold = true },
		["@keyword.repeat"] = { fg = palette.purple, italic = true, bold = true },
		["@keyword.return"] = { fg = palette.primary_bright, bold = true, italic = true },
		["@keyword.storage"] = "StorageClass",

		-----------------------------------------------------------------------
		-- Labels & Operators
		-----------------------------------------------------------------------
		["@label"] = { fg = palette.sapphire },
		["@operator"] = { fg = palette.sapphire },

		-----------------------------------------------------------------------
		-- Modules & Namespaces
		-----------------------------------------------------------------------
		["@module"] = { fg = palette.primary, italic = true }, -- 模块定义联动主色
		["@module.builtin"] = { fg = palette.red, italic = true },
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
		["@punctuation.delimiter"] = { fg = palette.fg_muted },
		["@punctuation.special"] = { fg = palette.sapphire, bold = true },

		-----------------------------------------------------------------------
		-- Strings & Escape Sequences
		-----------------------------------------------------------------------
		["@string"] = "String",
		["@string.documentation"] = { fg = palette.yellow, italic = true },
		["@string.escape"] = { fg = palette.maroon, bold = true },
		["@string.regexp"] = { fg = palette.purple },
		["@string.special"] = "SpecialChar",

		-----------------------------------------------------------------------
		-- HTML / JSX Tags
		-----------------------------------------------------------------------
		["@tag"] = { fg = palette.primary, bold = true }, -- JSX/HTML 标签使用主色
		["@tag.attribute"] = { fg = palette.teal, italic = true },
		["@tag.delimiter"] = { fg = palette.fg_muted },

		-----------------------------------------------------------------------
		-- Types & Definitions
		-----------------------------------------------------------------------
		["@type"] = { fg = palette.yellow, bold = true }, -- 结构类型加粗，增加高饱和识别度
		["@type.builtin"] = { fg = palette.yellow, bold = true, italic = true },
		["@type.definition"] = { fg = palette.yellow, bold = true },
		["@type.qualifier"] = "@keyword",

		-----------------------------------------------------------------------
		-- Variables & Parameters
		-----------------------------------------------------------------------
		["@variable"] = { fg = palette.fg },
		["@variable.builtin"] = { fg = palette.red, bold = true },
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

		["@markup.heading"] = { fg = palette.primary, bold = true },
		["@markup.heading.1"] = { fg = palette.primary_bright, bold = true },
		["@markup.heading.2"] = { fg = palette.primary, bold = true },
		["@markup.heading.3"] = { fg = palette.primary_dim, bold = true },
		["@markup.heading.4"] = { fg = palette.teal, bold = true },
		["@markup.heading.5"] = { fg = palette.peach, bold = true },
		["@markup.heading.6"] = { fg = palette.flamingo, bold = true },

		["@markup.link"] = { fg = palette.rosewater },
		["@markup.link.label"] = { fg = palette.primary },
		["@markup.link.url"] = { fg = palette.fg_muted, underline = true },

		["@markup.list"] = { fg = palette.primary },
		["@markup.list.checked"] = { fg = palette.green },
		["@markup.list.unchecked"] = { fg = palette.fg_muted },
		["@markup.list.markdown"] = { fg = palette.peach, bold = true },

		["@markup.math"] = { fg = palette.sapphire },
		["@markup.environment"] = { fg = palette.maroon },
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
