---@class builtin.bus.Message
---@field id integer
---@field tag string
---@field level integer
---@field content any
---@field data table
---@field timestamp integer

---@class builtin.bus.SubscriberSpec
---@field exact? string[]
---@field prefix? string[]
---@field min_level? integer
---@field handler fun(message: builtin.bus.Message)

local M = {}
local subscribers = {}
local observers = {}
local next_id = 0
local initialized = false
local ui_namespace

local function message_text(content)
	local chunks = {}
	for _, chunk in ipairs(content or {}) do
		if type(chunk) == "table" then
			chunks[#chunks + 1] = chunk[2] or chunk[1] or ""
		else
			chunks[#chunks + 1] = tostring(chunk)
		end
	end
	return table.concat(chunks)
end

local function setup_ui_messages()
	if not vim.ui_attach or ui_namespace then
		return
	end

	ui_namespace = vim.api.nvim_create_namespace("builtin_bus_messages")
	vim.ui_attach(ui_namespace, { ext_messages = true, set_cmdheight = false }, function(event, kind, ...)
		if event == "msg_show" then
			local content, replace_last, history, append, id, trigger = ...
			local message_kind = kind ~= "" and kind or "unknown"
			vim.schedule(function()
				M.emit("msg.show." .. message_kind, vim.log.levels.TRACE, message_text(content), {
					kind = kind,
					replace_last = replace_last,
					history = history,
					append = append,
					id = id,
					trigger = trigger,
				})
			end)
		elseif event == "msg_clear" then
			vim.schedule(function()
				M.emit("msg.clear", vim.log.levels.TRACE, "", {})
			end)
		end
	end)
end

local function interested(spec, message)
	if spec.min_level and message.level < spec.min_level then
		return false
	end
	if spec.exact then
		for _, tag in ipairs(spec.exact) do
			if tag == message.tag then
				return true
			end
		end
	end
	if spec.prefix then
		for _, prefix in ipairs(spec.prefix) do
			if vim.startswith(message.tag, prefix) then
				return true
			end
		end
	end
	return not spec.exact and not spec.prefix
end

function M.setup()
	if initialized then
		return
	end
	initialized = true
	setup_ui_messages()
end

---@param id string
---@param spec builtin.bus.SubscriberSpec
---@return boolean
function M.register_subscriber(id, spec)
	if subscribers[id] then
		return false
	end
	subscribers[id] = spec
	return true
end

---@param id string
---@param callback fun(message: builtin.bus.Message)
function M.register_observer(id, callback)
	observers[id] = callback
end

---@param id string
function M.unsubscribe(id)
	subscribers[id] = nil
	observers[id] = nil
end

---@param tag string
---@param level integer
---@param content any
---@param data? table
---@return builtin.bus.Message
function M.emit(tag, level, content, data)
	if not initialized then
		M.setup()
	end
	next_id = next_id + 1
	local message = {
		id = next_id,
		tag = tag,
		level = level,
		content = content,
		data = data or {},
		timestamp = vim.uv.now(),
	}
	for _, callback in pairs(observers) do
		callback(message)
	end
	for _, spec in pairs(subscribers) do
		if interested(spec, message) then
			local ok, err = pcall(spec.handler, message)
			if not ok then
				vim.schedule(function()
					vim.api.nvim_echo(
						{ { ("Builtin bus subscriber failed: %s"):format(err), "ErrorMsg" } },
						true,
						{ err = true }
					)
				end)
			end
		end
	end
	return message
end

return M
