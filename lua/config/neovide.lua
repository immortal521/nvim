if vim.g.neovide then
  -- Neovide 基础设置
  vim.g.neovide_fullscreen = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.o.guifont = "Maple Mono Normal NF CN:h14"

  -- 性能和显示设置
  vim.g.neovide_refresh_rate = 165
  vim.g.neovide_refresh_rate_idle = 5

  -- 窗口标题栏颜色设置 (与 Neovim 主题保持一致)
  local normal_hl = vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") })
  local normal_bg_color = string.format("%x", normal_hl.bg)
  local normal_fg_color = string.format("%x", normal_hl.fg) -- 获取Normal组的前景色

  vim.g.neovide_title_background_color = normal_bg_color
  vim.g.neovide_title_text_color = normal_fg_color -- **修改为动态获取Normal组的前景色**

  -- 光标动画和特效设置
  vim.g.neovide_cursor_animation_length = 0.10
  vim.g.neovide_cursor_short_animation_length = 0.02
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_antialiasing = true
end
