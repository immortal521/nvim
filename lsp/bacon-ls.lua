--- init_options = {
---     -- Bacon export filename (default: .bacon-locations).
---     locationsFile = ".bacon-locations",
---     -- Try to update diagnostics every time the file is saved (default: true).
---     updateOnSave = true,
---     --  How many milliseconds to wait before updating diagnostics after a save (default: 1000).
---     updateOnSaveWaitMillis = 1000,
---     -- Try to update diagnostics every time the file changes (default: true).
---     updateOnChange = true,
---     -- Try to validate that bacon preferences are setup correctly to work with bacon-ls (default: true).
---     validateBaconPreferences = true,
---     -- f no bacon preferences file is found, create a new preferences file with the bacon-ls job definition (default: true).
---     createBaconPreferencesFile = true,
---     -- Run bacon in background for the bacon-ls job (default: true)
---     runBaconInBackground = true,
---     -- Command line arguments to pass to bacon running in background (default "--headless -j bacon-ls")
---     runBaconInBackgroundCommandArguments = "--headless -j bacon-ls",
---     -- How many milliseconds to wait between background diagnostics check to synchronize all open files (default: 2000).
---     synchronizeAllOpenFilesWaitMillis = 2000,
--- }

---@type vim.lsp.Config
return {
  cmd = { "bacon-ls" },
  filetypes = { "rust" },
  root_markers = { ".bacon-locations", "Cargo.toml" },
  init_options = {},
}
