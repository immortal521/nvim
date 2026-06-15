---@type LazyPluginSpec
return {
	"nvim-mini/mini.base16",
	version = "*",
	enabled = false,
	opts = {
		palette = {
			base00 = "#1a1b26",
			base01 = "#14151d", -- surface dim
			base02 = "#20212f", -- surface low
			base03 = "#242635", -- surface variant
			base04 = "#33354a", -- surface high
			base05 = "#e6e1e5", -- on_primary / main fg
			base06 = "#ffffff", -- high contrast text
			base07 = "#ffffff", -- max contrast (fallback)

			base08 = "#f7768e", -- error
			base09 = "#7aa2f7", -- primary (blue)
			base0A = "#bb9af7", -- secondary (purple)
			base0B = "#9ece6a", -- success / green (tertiary)
			base0C = "#22d3ee", -- cyan (approx from palette space)
			base0D = "#7aa2f7", -- functions / primary
			base0E = "#bb9af7", -- keywords / secondary
			base0F = "#5e70be", -- outline / accent
		},
		plugins = {
			default = false,
			["nvim-mini/mini.nvim"] = true,
		},
	},
}
