local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		"https://github.com/saghen/blink.cmp",
		"https://github.com/niuiic/blink-cmp-rg.nvim",
		"https://github.com/milanglacier/minuet-ai.nvim",
		"https://github.com/xzbdmw/colorful-menu.nvim",
	}, { confirm = false })
	pcall(function()
		require("minuet").setup({
			provider = "openai_compatible",
			blink = { enable_auto_complete = true },
			context_window = 700,
			context_ratio = 0.75,
			debounce = 3000,
			request_timeout = 3,
			provider_options = {
				openai_compatible = {
					api_key = function()
						return os.getenv("OPENROUTER_TOKEN")
					end,
					end_point = "https://openrouter.ai/api/v1/chat/completions",
					model = "cohere/north-mini-code:free",
					name = "Openrouter",
					optional = { max_tokens = 56, top_p = 0.9, reasoning_effort = "none" },
				},
			},
		})
	end)
	pcall(function()
		require("blink.cmp").build():wait(60000)
	end)
	require("blink.cmp").setup({
		appearance = { nerd_font_variant = "mono" },
		cmdline = {
			enabled = true,
			completion = {
				menu = { auto_show = true },
				list = { selection = { preselect = false, auto_insert = true } },
			},
		},
		completion = {
			menu = {
				scrollbar = false,
				border = "rounded",
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
						{ "source_name" },
					},
				},
			},
			keyword = { range = "full" },
			list = { selection = { preselect = false, auto_insert = true } },
			documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = "rounded" } },
		},
		signature = {
			enabled = true,
			window = { border = "rounded", treesitter_highlighting = true, show_documentation = true },
		},
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "snippets", "path", "buffer", "ripgrep", "minuet" },
			providers = {
				minuet = {
					name = "minuet",
					module = "minuet.blink",
					async = true,
					timeout_ms = 3000,
					score_offset = 50,
				},
				ripgrep = { name = "Ripgrep", module = "blink-cmp-rg", max_items = 3, score_offset = -20 },
			},
		},
		fuzzy = {
			implementation = "prefer_rust",
			max_typos = function(k)
				return math.floor(#k / 4)
			end,
			frecency = { enabled = true },
			use_proximity = true,
			sorts = { "score", "exact", "sort_text" },
		},
		keymap = {
			preset = "none",
			["<S-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-h>"] = { "hide", "show" },
			["<cr>"] = { "accept", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
	})
end

vim.api.nvim_create_autocmd({
	"InsertEnter",
	"CmdlineEnter",
}, {
	once = true,
	callback = load,
})
