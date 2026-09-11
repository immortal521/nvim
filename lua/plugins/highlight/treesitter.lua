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
	"nim", "ninja", "nu", "nix",
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

local language_treesitter = require("toolchain").get_treesitter()
local parsers = vim.deepcopy(langs)
local filetypes = vim.deepcopy(langs)
local installing = {}
local reported = {}
for _, parser in ipairs(language_treesitter.parsers) do
	if not vim.tbl_contains(parsers, parser) then
		parsers[#parsers + 1] = parser
	end
end
for _, filetype in ipairs(language_treesitter.filetypes) do
	if not vim.tbl_contains(filetypes, filetype) then
		filetypes[#filetypes + 1] = filetype
	end
end

local function start_treesitter(buf)
	if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype == "" then
		return true
	end

	local ok, err = pcall(vim.treesitter.start, buf)
	if not ok then
		return false, err
	end

	vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = win })
			vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
		end
	end
	return true
end

local function notify_failure(parser, err)
	if reported[parser] then
		return
	end
	reported[parser] = true
	vim.notify(
		("Treesitter parser '%s' could not be started: %s"):format(parser, tostring(err)),
		vim.log.levels.WARN,
		{ title = "Treesitter" }
	)
end

local function request_install(buf)
	local filetype = vim.bo[buf].filetype
	local parser = vim.treesitter.language.get_lang(filetype) or filetype
	if installing[parser] then
		return parser
	end

	local ok, treesitter = pcall(require, "nvim-treesitter")
	if not ok then
		return parser
	end

	installing[parser] = true
	local installed, err = pcall(treesitter.install, { parser }, { summary = false })
	if not installed then
		installing[parser] = nil
		notify_failure(parser, err)
	end
	return parser
end

local function start_when_ready(buf, attempts)
	local ok, err = start_treesitter(buf)
	if ok then
		return
	end

	local parser = request_install(buf)
	if attempts >= 300 then
		notify_failure(parser, err)
		return
	end
	vim.defer_fn(function()
		start_when_ready(buf, attempts + 1)
	end, 100)
end

---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile", "VeryLazy" },
	-- dependencies = { "neovim-treesitter/treesitter-parser-registry" },
	opts = {},
	init = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = filetypes,
			callback = function(event)
				start_when_ready(event.buf, 0)
			end,
		})
	end,
}
