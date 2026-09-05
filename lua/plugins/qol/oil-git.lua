---@type LazyPluginSpec
return {
	"malewicz1337/oil-git.nvim",
	ft = "oil",
	opts = {
		show_file_highlights = true,
		show_directory_highlights = false,
		show_ignored_files = true,

		highlights = {
			OilGitAdded = { link = "ExtraGreen" },

			OilGitModifiedStaged = { link = "ExtraYellow" },
			OilGitModifiedUnstaged = { link = "ExtraOrange" },

			OilGitRenamed = { link = "ExtraPurple" },
			OilGitDeleted = { link = "ExtraRed" },
			OilGitCopied = { link = "ExtraPurple" },

			OilGitConflict = { link = "ExtraOrange" },
			OilGitUntracked = { link = "ExtraPink" },
			OilGitIgnored = { link = "Comment" },
		},
	},
}
