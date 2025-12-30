local M = {}

function M.setup()
	local Event = require("lazy.core.handler.event")
	Event.mappings.BufEdit = { id = "BufEdit", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
	Event.mappings["User BufEdit"] = Event.mappings.BufEdit
end

return M
