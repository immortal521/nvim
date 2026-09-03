---@class utils
---@field keymap utils.keymap
---@field color utils.color
---@field lsp utils.lsp
---@field terminal utils.terminal
---@field fs utils.fs
---@field project utils.project
---@field system utils.system
---@field buffer utils.buffer
---@field log utils.log
---@field autocmd utils.autocmd
---@field hlgroup utils.hlgroup
local M = {}

-- 模块懒加载
setmetatable(M, {
	__index = function(t, k)
		local ok, module = pcall(require, "utils." .. k)
		if ok then
			t[k] = module
			return module
		end
		error("Utils module '" .. k .. "' not found")
	end,
})

--- 检查是否为 Windows 系统
---@return boolean 是否为 Windows
M.is_win = function()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

--- 异步执行函数
---@param callback function 回调函数
---@param delay? integer 延迟时间（毫秒），默认 1000
M.async_function = function(callback, delay)
	delay = delay or 1000
	vim.defer_fn(function()
		callback("异步操作完成")
	end, delay)
end

---@param str string
M.keycode = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local key_cache = {} ---@type table<string, string>

---@param key string
function M.normkey(key)
	if key_cache[key] ~= nil then
		return key_cache[key]
	end
	local function norm(v)
		local l = v:lower()
		if l == "leader" then
			return M.normkey("<leader>")
		elseif l == "localleader" then
			return M.normkey("<localleader>")
		end
		return vim.fn.keytrans(M.keycode(("<%s>"):format(v)))
	end
	local orig = key
	key = key:gsub("<lt>", "<")
	local lower = key:lower()
	if lower == "<leader>" then
		key = vim.g.mapleader
		key = vim.fn.keytrans((not key or key == "") and "\\" or key)
	elseif lower == "<localleader>" then
		key = vim.g.maplocalleader
		key = vim.fn.keytrans((not key or key == "") and "\\" or key)
	else
		local extracted = {} ---@type string[]
		local function extract(v)
			v = v:sub(2, -2)
			if v:sub(2, 2) == "-" and v:sub(1, 1):find("[aAmMcCsS]") then
				local m = v:sub(1, 1):upper()
				m = m == "A" and "M" or m
				local k = v:sub(3)
				if #k > 1 then
					return norm(v)
				end
				if m == "C" then
					k = k:upper()
				elseif m == "S" then
					return k:upper()
				end
				return ("<%s-%s>"):format(m, k)
			end
			return norm(v)
		end
		local placeholder = "_#_"
		---@param v string
		key = key:gsub("(%b<>)", function(v)
			table.insert(extracted, extract(v))
			return placeholder
		end)
		key = vim.fn.keytrans(key):gsub("<lt>", "<")

		-- Restore extracted %b<> sequences
		local i = 0
		key = key:gsub(placeholder, function()
			i = i + 1
			return extracted[i] or ""
		end)
	end
	key_cache[orig] = key
	key_cache[key] = key
	return key
end

--- Set window-local options.
---@param win integer
---@param wo vim.wo|{}|{winhighlight: string|table<string, string>}
function M.wo(win, wo)
	for k, v in pairs(wo or {}) do
		if k == "winhighlight" and type(v) == "table" then
			local parts = {} ---@type string[]
			for kk, vv in pairs(v) do
				if vv ~= "" then
					parts[#parts + 1] = ("%s:%s"):format(kk, vv)
				end
			end
			v = table.concat(parts, ",")
		end
		vim.api.nvim_set_option_value(k --[[@as string]], v, { scope = "local", win = win })
	end
end

--- Set buffer-local options.
---@param buf integer
---@param bo vim.bo|{}
function M.bo(buf, bo)
	for k, v in pairs(bo or {}) do
		vim.api.nvim_set_option_value(k, v, { buf = buf })
	end
end

return M
