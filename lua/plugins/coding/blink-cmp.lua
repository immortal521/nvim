-- Code Completion
return {
	---@type LazyPluginSpec
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "1.*",
		dependencies = {
			"immortal521/windsurf.nvim",
		},

		---@type blink.cmp.Config
		opts = {
			appearance = { nerd_font_variant = "mono" },
			cmdline = {
				enabled = true,
				sources = function()
					local type = vim.fn.getcmdtype()
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					if type == ":" or type == "@" then
						return { "cmdline" }
					end
					return {}
				end,
				completion = {
					menu = { auto_show = true },
					list = { selection = { preselect = false, auto_insert = true } },
				},
			},
			completion = {
				menu = {
					scrollbar = false,
					border = "rounded",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder",
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon", gap = 1 },
							{ "label", gap = 1, "label_description" },
							{ "kind", gap = 1 },
							{ "source_name", gap = 1 },
						},
					},
				},
				keyword = { range = "full" },
				list = { selection = { preselect = false, auto_insert = true } },
				documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = "rounded" } },
				trigger = { prefetch_on_insert = true, show_on_blocked_trigger_characters = {} },
				accept = { dot_repeat = true, auto_brackets = { enabled = true } },
			},
			signature = {
				enabled = true,
				trigger = { show_on_insert = true },
				window = { border = "rounded", treesitter_highlighting = true, show_documentation = true },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "codeium" },
				providers = {
					codeium = { name = "codeium", module = "codeium.blink", async = true, max_items = 3 },
					ripgrep = {
						name = "Ripgrep",
						module = "blink-cmp-rg",
						opts = {
							prefix_min_len = 3,
							get_command = function(_, prefix)
								return {
									"rg",
									"--no-config",
									"--json",
									"--word-regexp",
									"--ignore-case",
									"--",
									prefix .. "[\\w_-]+",
									vim.fs.root(0, ".git") or vim.fn.getcwd(),
								}
							end,
							get_prefix = function(context)
								return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
							end,
						},
						max_items = 3,
						score_offset = -20,
					},
				},
			},
			keymap = {
				preset = "none",
        -- stylua: ignore start
        ['<S-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-h>'] = { 'hide', 'show' },
        ['<cr>'] = { 'accept', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Tab>'] = {'select_next', 'snippet_forward', 'fallback'},
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
        ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
        ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
        ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
        ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
        ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
        ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
        ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
        ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
        ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
				-- stylua: ignore start
			},
		},
	},

	-- Completion Icon and Highlighting
	---@type LazyPluginSpec
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			local mini_icons = require("mini.icons")
			local colorful_menu = require("colorful-menu")

			opts.completion.menu.draw.components = vim.tbl_extend("force", opts.completion.menu.draw.components or {}, {
				kind_icon = {
					ellipsis = false,
					text = function(ctx)
						local icon = ctx.kind_icon
						if ctx.source_id == "lsp" then
							if ctx.kind == "File" then
								icon, _ = mini_icons.get("file", ctx.item.detail)
							elseif ctx.kind == "Folder" then
								icon, _ = mini_icons.get("directory", ctx.item.label)
							elseif ctx.kind == "Color" and ctx.item.documentation then
								-- local color_item = highlight_colors.format(ctx.item.documentation, { kind = "Color" })
								-- if color_item and color_item.abbr then
								-- 	icon = color_item.abbr
								-- end
							else
								icon, _ = mini_icons.get("lsp", ctx.kind)
							end
						elseif ctx.source_id == "path" then
							if ctx.item.data.type ~= "link" then
								icon, _ = mini_icons.get(ctx.item.data.type, ctx.label)
							end
						end

						return icon .. ctx.icon_gap
					end,
					highlight = function(ctx)
						local hl = ctx.kind_hl
						if ctx.source_id == "lsp" then
							if ctx.kind == "File" then
								_, hl = mini_icons.get("file", ctx.item.detail)
							elseif ctx.kind == "Folder" then
								_, hl = mini_icons.get("directory", ctx.item.label)
							elseif ctx.kind == "Color" and ctx.item.documentation then
								-- local color_item = highlight_colors.format(ctx.item.documentation, { kind = "Color" })
								-- if color_item and color_item.abbr then
								-- 	hl = color_item.abbr_hl_group
								-- end
							else
								_, hl = mini_icons.get("lsp", ctx.kind)
							end
						elseif ctx.source_id == "path" then
							if ctx.item.data.type ~= "link" then
								_, hl = mini_icons.get(ctx.item.data.type, ctx.label)
							end
						end

						return hl
					end,
				},
				label = {
					width = { fill = true, max = 30 },
					text = function(ctx)
						return colorful_menu.blink_components_text(ctx)
					end,
					highlight = function(ctx)
						return colorful_menu.blink_components_highlight(ctx)
					end,
				},
				kind = {
					highlight = function(ctx)
						if vim.tbl_contains({ "Path" }, ctx.source_name) then
							local mini_icon, mini_hl = require("mini.icons").get("default", ctx.item.data.type)
							if mini_icon then
								return mini_hl
							end
						end
						return ctx.kind_hl
					end,
				},

				label_description = {
					width = { max = 30 },
					text = function(ctx)
						return ctx.label_description
					end,
					highlight = "BlinkCmpLabelDescription",
				},
			})
		end,
	},
}
