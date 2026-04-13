-- stylua: ignore
local langs = {
	"bash", "bibtex",
	"c", "cpp", "cmake",
	"clojure",
	"css",
	"diff", "dockerfile",
	"elixir", "erlang",
	"fish",
	"git_config", "gitcommit", "gitattributes", "gitignore", "git_rebase",
	"go", "gomod", "gowork", "gosum",
	"graphql",
	"haskell", "html",
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
	opts = {},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
			callback = function(args)
				local buf = args.buf
				local ft = vim.bo[buf].filetype

				if ft == "" or vim.bo[buf].buftype ~= "" then
					return
				end

				local max_filesize = 100 * 1024 * 1024 -- 100 MB
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return
				end

				local lang = vim.treesitter.language.get_lang(ft) or ft

				if not vim.tbl_contains(langs, lang) then
					return
				end

				local no_err, is_added = pcall(vim.treesitter.language.add, lang)
				if not no_err or not is_added then
					vim.notify("Installing " .. lang .. " parser...", vim.log.levels.INFO)
					local ts = require("nvim-treesitter")
					if ts.install then
						ts.install({ lang }):wait(60000)
					else
						vim.cmd("TSInstall " .. lang)
					end
				end

				pcall(vim.treesitter.start, buf, lang)

				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
			end,
		})
	end,
	config = function(_, opts)
		local TS = require("nvim-treesitter")
		TS.setup(opts)
	end,
}
