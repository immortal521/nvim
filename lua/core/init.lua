---@class core
---@field win core.win
---@field lazygit core.lazygit
---@field terminal core.terminal
---@field buf core.buf
local M = {}

setmetatable(M, {
	__index = function(t, k)
		local ok, module = pcall(require, "core." .. k)
		if ok then
			t[k] = module
			return module
		end
		error("Core module '" .. k .. "' not found")
	end,
})

---@type core
_G.Core = M

---@class core.Config
---@field lazygit? core.lazygit.Config|{}
---@field terminal? core.terminal.Config|{}
---@field win? core.win.Config|{}
local config = {}

-- window styles default config
config.styles = {}

---@class core.Config
M.config = setmetatable({}, {
	__index = function(_, k)
		config[k] = config[k] or {}
		return config[k]
	end,
	__newindex = function(_, k, v)
		config[k] = v
	end,
})

local is_dict_like = function(v) -- has string and number keys
	return type(v) == "table" and (vim.tbl_isempty(v) or not vim.islist(v))
end
local is_dict = function(v) -- has only string keys
	return type(v) == "table" and (vim.tbl_isempty(v) or not v[1])
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type
---@generic T
---@param ... T
---@return T
function M.config.merge(...)
	local ret = select(1, ...)
	for i = 2, select("#", ...) do
		local value = select(i, ...)
		if is_dict_like(ret) and is_dict(value) then
			for k, v in pairs(value) do
				ret[k] = M.config.merge(ret[k], v)
			end
		elseif value ~= nil then
			ret = value
		end
	end
	return ret
end

---@generic T: table
---@param snack string
---@param defaults T
---@param ... T[]
---@return T
function M.config.get(snack, defaults, ...)
	local merge, todo = {}, { defaults, config[snack] or {}, ... }
	for i = 1, select("#", ...) + 2 do
		local v = todo[i] --[[@as snacks.Config.base]]
		if type(v) == "table" then
			if v.example then
				table.insert(merge, vim.deepcopy(M.config.example(snack, v.example)))
				v.example = nil
			end
			table.insert(merge, vim.deepcopy(v))
		end
	end
	local ret = M.config.merge(unpack(merge))
	if type(ret.config) == "function" then
		ret.config(ret, defaults)
	end
	return ret
end

--- Register a new window style config.
---@param name string
---@param defaults snacks.win.Config|{}
---@return string
function M.config.style(name, defaults)
	config.styles[name] = vim.tbl_deep_extend("force", vim.deepcopy(defaults), config.styles[name] or {})
	return name
end

function M.setup(opts)
	opts = opts or {}
	for k in pairs(opts) do
		opts[k].enabled = opts[k].enabled == nil or opts[k].enabled
	end
	config = vim.tbl_deep_extend("force", config, opts or {})
end

return M
