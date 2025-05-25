if vim.g.neovide then
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_fullscreen = false
  vim.o.guifont = "JetBrainsMono Nerd Font:h14"
  vim.g.neovide_refresh_rate = 165
  vim.g.neovide_title_background_color =
    string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)
  vim.g.neovide_title_text_color = "pink"
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_cursor_short_animation_length = 0.02
  vim.g.neovide_cursor_animation_length = 0.10
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_antialiasing = true
end
