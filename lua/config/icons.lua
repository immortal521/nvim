local M = {}

M.branch = "󰘬"

M.diagnostics = {
	Error = " ",
	Warn = " ",
	Info = " ",
	Hint = " ",
}

M.fileformat = {
	unix = "",
	dos = "",
	mac = "",
}

M.bufferline = {
	indicator = "┃",
	modified = "●",
	separator = "│",
	trunc_left = " ",
	trunc_right = " ",
}

M.LeftSectionSep = ""
M.RightSectionSep = ""
M.LeftComponentSep = ""
M.RightComponentSep = ""

M.Record = "󰻃 "

_G.Config.icons = M
return M
