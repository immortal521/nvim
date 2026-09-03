local conditions = require("heirline.conditions")

return {
	condition = conditions.is_active,
	init = function(self)
		self.reg_recording = vim.fn.reg_recording()
	end,
	{
		condition = function(self)
			return self.reg_recording ~= ""
		end,
		{
			provider = " 󰻃 ",
			hl = function(self)
				return { fg = self.palette.pink }
			end,
		},
		{
			provider = function(self)
				return self.reg_recording
			end,
			hl = function(self)
				return { fg = self.palette.bg_highlight, italic = false, bold = true }
			end,
		},
	},
	update = { "RecordingEnter", "RecordingLeave" },
}
