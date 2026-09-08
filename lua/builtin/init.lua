---@class builtin
---@field win builtin.win
---@field lazygit builtin.lazygit
---@field terminal builtin.terminal
---@field buf builtin.buf
---@field animate builtin.animate
---@field scroll builtin.scroll
---@field notify builtin.notify
---@field bus builtin.bus
local M = {}

setmetatable(M, {
	__index = function(t, k)
		t[k] = require("builtin." .. k)
		return rawget(t, k)
	end,
})

---@type builtin
_G.Builtin = M

---@class builtin.Config
---@field lazygit? builtin.lazygit.Config|{}
---@field terminal? builtin.terminal.Config|{}
---@field win? builtin.win.Config|{}
---@field scroll? builtin.scroll.Config|{}
---@field notify? builtin.notify.Options|{}
---@field animate? builtin.animate.Config|{}
---@field bus? table
local config = {}

---@class builtin.Config
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
---@param ... (T|table)?
---@return T
function M.config.get(snack, defaults, ...)
	local merge = { vim.deepcopy(defaults) }

	if type(config[snack]) == "table" then
		table.insert(merge, vim.deepcopy(config[snack]))
	end

	local vararg_count = select("#", ...)
	for i = 1, vararg_count do
		local v = select(i, ...)
		if type(v) == "table" then
			table.insert(merge, vim.deepcopy(v))
		end
	end

	local unpack_fn = table.unpack or unpack
	local ret = M.config.merge(unpack_fn(merge))

	if type(ret.config) == "function" then
		ret.config(ret, defaults)
	end

	return ret
end

function M.setup(opts)
	opts = opts or {}
	local defaults = {
		bus = { enabled = true },
		notify = { enabled = true },
		scroll = { enabled = false },
	}
	config = vim.tbl_deep_extend("force", defaults, config, opts)
	for _, module_config in pairs(config) do
		if type(module_config) == "table" and module_config.enabled == nil then
			module_config.enabled = true
		end
	end

	local events = {
		UIEnter = { "bus", "notify", "scroll" },
	}

	---@param event string
	---@param ev? vim.api.keyset.create_autocmd.callback_args
	local function load(event, ev)
		local todo = events[event] or {}
		events[event] = nil
		for _, module in ipairs(todo) do
			local module_config = M.config[module]
			if module_config and module_config.enabled then
				local implementation = M[module]
				if implementation.setup then
					implementation.setup(module_config, ev)
				elseif implementation.enable then
					implementation.enable(module_config, ev)
				end
			end
		end
	end

	if vim.v.vim_did_enter == 1 then
		load("UIEnter")
	end

	if next(events) then
		local group = vim.api.nvim_create_augroup("builtin", { clear = true })
		vim.api.nvim_create_autocmd(vim.tbl_keys(events --[[@as table]]), {
			group = group,
			once = true,
			nested = true,
			callback = function(ev)
				load(ev.event, ev)
			end,
		})
	end
end

return M
