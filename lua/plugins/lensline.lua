vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("SetupLensline", { clear = true }),
  once = true,
  callback = function()
    require("lensline").setup({
      profiles = {
        {
          name = "default",
          providers = { -- Array format: order determines display sequence
            {
              name = "usages",
              enabled = true, -- enable usages provider by default (replaces references)
              include = { "refs" }, -- refs-only setup to match references provider behavior
              breakdown = true, -- false = aggregate count, true = breakdown by type
              show_zero = true, -- show zero counts when LSP supports the capability
              labels = {
                refs = "refs",
                impls = "impls",
                defs = "defs",
                usages = "usages",
              },
              icon_for_single = "󰌹 ", -- icon when only one attribute or aggregate display
              inner_separator = ", ", -- separator between breakdown items
            },
            {
              name = "last_author",
              enabled = true, -- enabled by default with caching optimization
              cache_max_files = 50, -- maximum number of files to cache blame data for (default: 50)
            },
          },
          style = {
            separator = " • ", -- separator between all lens attributes
            highlight = "Comment", -- highlight group for lens text
            prefix = "┃ ", -- prefix before lens content
            placement = "above", -- "above" | "inline" - where to render lenses (consider prefix = "" for inline)
            use_nerdfont = true, -- enable nerd font icons in built-in providers
            render = "all", -- "all" | "focused" (only active window's focused function)
          },
        },
      },
      limits = {
        -- exclude = {
        -- file patterns that lensline will not process for lenses
        -- see config.lua for extensive list of default patterns
        -- },
        exclude_append = {}, -- additional patterns to append to exclude list (empty by default)
        exclude_gitignored = true, -- respect .gitignore by not processing ignored files
        max_lines = 1000, -- process only first N lines of large files
        max_lenses = 70, -- skip rendering if too many lenses generated
      },
      debounce_ms = 500, -- unified debounce delay for all providers
      focused_debounce_ms = 150, -- debounce delay for focus tracking in focused mode
      silence_lsp = true, -- suppress noisy LSP log messages (e.g., Pyright reference spam)
      debug_mode = false, -- enable debug output for development, see CONTRIBUTE.md
    })
  end,
})
