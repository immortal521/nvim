vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/malewicz1337/oil-git.nvim" },
})

function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

local detail = false

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event and event.data and event.data.actions and #event.data.actions > 0 then
      local action = event.data.actions[1]
      if action.type == "move" then
        require("snacks").rename.on_rename_file(action.src_url, action.dest_url)
      end
    end
  end,
})

require("oil").setup({
  default_file_explorer = true,
  columns = { "icon" },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  delete_to_trash = false,
  skip_confirm_for_simple_edits = true,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = false,
  },
  constrain_cursor = "editable",
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-k>"] = false,
    ["<C-j>"] = false,
    ["<C-r>"] = "actions.refresh",
    ["<leader>y"] = "actions.yank_entry",
    ["g."] = false,
    ["zh"] = "actions.toggle_hidden",
    ["\\"] = { "actions.select", opts = { horizontal = true } },
    ["|"] = { "actions.select", opts = { vertical = true } },
    ["-"] = "actions.close",
    ["<leader>e"] = "actions.close",
    ["<BS>"] = "actions.parent",
    ["td"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
  },
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
})

require("oil-git").setup({
  show_file_highlights = true,
  show_directory_highlights = false,
  show_ignored_files = true,
})

Utils.keymap.add({
  { "-", "<cmd>Oil<CR>" },
})
