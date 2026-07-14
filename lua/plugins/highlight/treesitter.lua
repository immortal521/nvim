-- stylua: ignore
local langs = {
	"bash", "bibtex",
	"c", "cpp", "cmake",
	"clojure",
	"css",
	"diff", "dockerfile",
	"ecma", "elixir", "erlang",
	"fish",
	"git_config", "gitcommit", "gitattributes", "gitignore", "git_rebase",
	"go", "gomod", "gowork", "gosum",
	"graphql",
  "haskell", "html", "html_tags",
	"http",
	"java", "javascript", "jsdoc", "json", "jsx",
	"kotlin",
	"latex", "lua", "luadoc", "luap",
	"make", "markdown", "markdown_inline",
	"nim", "ninja", "nu",
	"ocaml",
	"php", "proto", "python",
	"query",
	"regex", "ron", "ruby", "rust",
	"scss", "sql", "swift",
	"toml", "tsx", "typescript",
	"vim", "vimdoc", "vue",
	"xml",
	"yaml",
	"zig",
}

---@type LazyPluginSpec
return {
	"neovim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufEdit", "VeryLazy" },
	dependencies = { "neovim-treesitter/treesitter-parser-registry" },
	opts = {},
	init = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = langs,
			callback = function()
				vim.treesitter.start()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
			end,
		})
	end,
	config = function(_, opts)
		local TS = require("nvim-treesitter")
		TS.setup(opts)
		TS.install(langs)
	end,
}
