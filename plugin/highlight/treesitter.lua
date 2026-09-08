-- Register the package early, but defer loading and parser installation until
-- a real file is opened. Installing every parser at startup is unnecessary.
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, {
	confirm = false,
	load = false,
})

local loaded = false

local function start(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return
	end

	local ok = pcall(vim.treesitter.start, bufnr)
	if not ok then
		return
	end

	vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	local winid = vim.fn.bufwinid(bufnr)
	if winid ~= -1 then
		vim.wo[winid].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[winid].foldmethod = "expr"
	end
end

local function attach(bufnr)
	local parser = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
	if not parser then
		return
	end

	local treesitter = require("nvim-treesitter")
	if vim.tbl_contains(treesitter.get_installed(), parser) then
		start(bufnr)
		return
	end

	-- Install asynchronously and attach the original buffer when ready.
	treesitter.install({ parser }):await(function()
		if vim.api.nvim_buf_is_valid(bufnr) then
			start(bufnr)
		end
	end)
end

local function load()
	if loaded then
		return
	end
	loaded = true
	vim.cmd.packadd("nvim-treesitter")
	require("nvim-treesitter").setup({})
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(event)
		if vim.bo[event.buf].buftype ~= "" then
			return
		end
		load()
		attach(event.buf)
	end,
	desc = "Load Treesitter and attach the current parser",
})
