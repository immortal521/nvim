local langs = {
	"bash",
	"c",
	"css",
	"diff",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"jsx",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"nu",
	"printf",
	"python",
	"query",
	"go",
	"gomod",
	"gowork",
	"gosum",
	"git_config",
	"gitcommit",
	"git_rebase",
	"gitignore",
	"gitattributes",
	"regex",
	"rust",
	"ron",
	"scss",
	"toml",
	"tsx",
	"typescript",
	"vue",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

return {
	"neovim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufEdit", "VeryLazy" },
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
		for _, lang in ipairs(langs) do
			TS.install(lang)
		end
	end,
}
