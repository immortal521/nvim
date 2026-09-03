local icons = require("config.icons")
local utils = require("heirline.utils")
local tabline = require("heirline.components.tabline")

local buflist_cache = {}
local get_bufs = function()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
	end, vim.api.nvim_list_bufs())
end

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
	callback = function()
		vim.schedule(function()
			local buffers = get_bufs()
			for i, v in ipairs(buffers) do
				buflist_cache[i] = v
			end
			for i = #buffers + 1, #buflist_cache do
				buflist_cache[i] = nil
			end

			if #buflist_cache > 1 then
				vim.o.showtabline = 2
			elseif vim.o.showtabline ~= 1 then
				vim.o.showtabline = 1
			end
		end)
	end,
})

local BufferBlock = {
	static = {
		buffer_min_width = 20,
		filename_max_length = 18,
	},
	init = function(self)
		-- File
		self.filepath = vim.api.nvim_buf_get_name(self.bufnr)
		self.filename = self.filepath == "" and "[No Name]" or vim.fn.fnamemodify(self.filepath, ":t")
		if #self.filename > self.filename_max_length then
			self.filename = self.filename:sub(1, self.filename_max_length) .. "..."
		end

		-- Diagnostics
		local diagnostics = vim.diagnostic.get(self.bufnr)
		self.errors = #vim.tbl_filter(function(d)
			return d.severity == vim.diagnostic.severity.ERROR
		end, diagnostics)
		self.warnings = #vim.tbl_filter(function(d)
			return d.severity == vim.diagnostic.severity.WARN
		end, diagnostics)
		self.has_errors = self.errors > 0
		self.has_warnings = self.warnings > 0

		-- Padding
		local current_width = 4 + #self.filename
		local padding_needed = math.max(0, self.buffer_min_width - current_width) --[[@type number]]
		self.buffer_padding = math.floor(padding_needed / 2)
	end,

	hl = function(self)
		return self.is_active and { bg = self.palette.bg, bold = true } or { bg = self.palette.bg, bold = false }
	end,

	on_click = {
		minwid = function(self)
			return self.bufnr
		end,
		callback = function(_, minwid, _, button)
			if button == "l" then
				vim.api.nvim_set_current_buf(minwid)
			end
		end,
		name = "heirline_buffer_switch_button",
	},

	tabline.Indicator,
	tabline.BufferPadding,
	tabline.FileName,
	tabline.BufferPadding,
	tabline.CloseButton,
}

local BufferLine = utils.make_buflist(BufferBlock, {
	provider = " " .. icons.bufferline.trunc_left,
	hl = function(self)
		return { fg = self.palette.comment }
	end,
}, {
	provider = "%=" .. icons.bufferline.trunc_right .. " ",
	hl = function(self)
		return { fg = self.palette.comment }
	end,
}, function()
	return buflist_cache
end, false)

local Tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
	end,
}

local TabpageClose = {
	provider = "%999X ✗ %X",
}

local TabPages = {
	-- only show this component if there's 2 or more tabpages
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(Tabpage),
	TabpageClose,
}

return {
	init = function(self)
		self.colors = Utils.color.get_colors()
		self.palette = require("theme").get_palette()
	end,
	tabline.Offset,
	BufferLine,
	TabPages,
}
