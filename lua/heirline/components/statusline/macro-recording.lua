local conditions = require("heirline.conditions")
local colors = Utils.colors()

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
			hl = { fg = colors.magenta },
		},
		{
			provider = function(self)
				return self.reg_recording
			end,
			hl = { fg = colors.magenta, italic = false, bold = true },
		},
	},
	update = { "RecordingEnter", "RecordingLeave" },
}
