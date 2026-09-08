---@class LanguageSpec
---@field filetypes string[] 文件类型
---@field formatters? string[] 格式化器名称
---@field linters? string[] lint 名称
---@field lint_filetypes? string[] 实际启用 lint 的文件类型
---@field lsp? string[] LSP 配置名称
---@field treesitter? string[] Treesitter 语言名称

---@class LanguageSourceItem
---@field name string 语言规格文件名
---@field file string 语言规格文件路径
---@field filetypes string 用于展示的文件类型
---@field formatters string 用于展示的 formatter
---@field linters string 用于展示的 linter
---@field lsp string 用于展示的 LSP

local M = {}
local specs_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "toolchain", "lang", "specs")
local languages = {} ---@type table<string, LanguageSpec>
local lsp_enabled = {} ---@type table<string, boolean>
local spec_names = {}

for name, kind in vim.fs.dir(specs_dir) do
	if kind == "file" and name:sub(-4) == ".lua" then
		spec_names[#spec_names + 1] = name:sub(1, -5)
	end
end

table.sort(spec_names)
for _, language in ipairs(spec_names) do
	local ok, definition = pcall(require, "toolchain.lang.specs." .. language)
	if ok and type(definition) == "table" and vim.islist(definition.filetypes) and #definition.filetypes > 0 then
		languages[language] = definition
	else
		vim.notify(("Invalid language specification: %s.lua"):format(language), vim.log.levels.WARN)
	end
end

---@return table<string, LanguageSpec>
function M.get()
	return vim.deepcopy(languages)
end

---@return table<string, string[]>
function M.get_formatters()
	local result = {}
	for _, definition in pairs(languages) do
		for _, filetype in ipairs(definition.filetypes) do
			if definition.formatters then
				result[filetype] = result[filetype] or {}
				for _, formatter in ipairs(definition.formatters) do
					if not vim.tbl_contains(result[filetype], formatter) then
						result[filetype][#result[filetype] + 1] = formatter
					end
				end
			end
		end
	end
	result.graphql = { "prettier", "biome", "oxfmt" }
	result.handlebars = { "prettier", "biome", "oxfmt" }
	result.luau = { "stylua" }
	return result
end

---@return table<string, string[]>
function M.get_linters()
	local result = {}
	for _, definition in pairs(languages) do
		if definition.linters then
			for _, filetype in ipairs(definition.lint_filetypes or definition.filetypes) do
				result[filetype] = result[filetype] or {}
				for _, linter in ipairs(definition.linters) do
					if not vim.tbl_contains(result[filetype], linter) then
						result[filetype][#result[filetype] + 1] = linter
					end
				end
			end
		end
	end
	return result
end

---@return { parsers: string[], filetypes: string[] }
function M.get_treesitter()
	local result = { parsers = {}, filetypes = {} }
	for _, definition in pairs(languages) do
		if definition.treesitter then
			for _, parser in ipairs(definition.treesitter) do
				if not vim.tbl_contains(result.parsers, parser) then
					result.parsers[#result.parsers + 1] = parser
				end
			end
			for _, filetype in ipairs(definition.filetypes) do
				if not vim.tbl_contains(result.filetypes, filetype) then
					result.filetypes[#result.filetypes + 1] = filetype
				end
			end
		end
	end
	return result
end

---仅在打开对应文件类型时启用该语言声明的 LSP。
---@param filetype string
function M.enable_lsp(filetype)
	for _, item in pairs(languages) do
		if vim.tbl_contains(item.filetypes, filetype) then
			for _, name in ipairs(item.lsp or {}) do
				if not lsp_enabled[name] then
					vim.lsp.enable(name)
					lsp_enabled[name] = true
				end
			end
		end
	end
end

---注册按文件类型延迟启用 LSP 的入口。
function M.setup()
	local group = vim.api.nvim_create_augroup("LanguageLsp", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(event)
			M.enable_lsp(vim.bo[event.buf].filetype)
		end,
	})
	M.enable_lsp(vim.bo.filetype)
end

---@param filetype string
---@return LanguageSpec?
function M.get_by_filetype(filetype)
	local result
	for _, definition in pairs(languages) do
		if vim.tbl_contains(definition.filetypes, filetype) then
			result = result or { filetypes = {} }
			vim.list_extend(result.filetypes, definition.filetypes)
			for _, field in ipairs({ "formatters", "linters", "lsp", "treesitter" }) do
				if definition[field] then
					result[field] = result[field] or {}
					for _, value in ipairs(definition[field]) do
						if not vim.tbl_contains(result[field], value) then
							result[field][#result[field] + 1] = value
						end
					end
				end
			end
		end
	end
	return result
end

---@return LanguageSourceItem[]
function M.source_items()
	local items = {}
	for name, definition in pairs(languages) do
		items[#items + 1] = {
			name = name,
			file = vim.fs.joinpath(specs_dir, name .. ".lua"),
			filetypes = table.concat(definition.filetypes, ", "),
			formatters = table.concat(definition.formatters or {}, ", "),
			linters = table.concat(definition.linters or {}, ", "),
			lsp = table.concat(definition.lsp or {}, ", "),
		}
	end
	table.sort(items, function(a, b)
		return a.name < b.name
	end)
	return items
end

return M
