if vim.loop.os_uname().sysname ~= "Linux" then
  return {}
end

return {
  "keaising/im-select.nvim",
  config = function()
    -- 定义一个函数来查找可用的输入法命令
    local function find_im_command()
      local commands = {
        "fcitx5-remote", -- 优先检测 fcitx5
        "fcitx-remote", -- 其次检测 fcitx
        "ibus", -- 最后检测 ibus
      }

      for _, cmd in ipairs(commands) do
        if vim.fn.executable(cmd) == 1 then
          return cmd -- 找到第一个可执行的就返回
        end
      end

      -- 如果都没有找到，可以返回一个默认值或者给出警告
      vim.notify(
        "未找到支持的输入法切换命令 (fcitx5-remote, fcitx-remote, ibus)。请检查输入法配置。",
        vim.log.levels.WARN
      )
      return "ibus" -- 或者返回一个你认为安全的默认值，比如 "ibus"
    end

    -- 调用函数获取默认命令
    local default_im_cmd = find_im_command()

    -- 只有当找到一个命令时才进行设置，避免插件报错
    if default_im_cmd then
      require("im_select").setup({
        default_command = default_im_cmd, -- 使用自动检测到的命令
        default_im_select = "2057",
        set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
        set_previous_events = { "InsertEnter" },
        keep_quiet_on_no_binary = false,
        async_switch_im = true,
      })
    else
      vim.notify(
        "im-select.nvim 未能自动配置输入法切换命令。请手动检查并设置。",
        vim.log.levels.ERROR
      )
      -- 即使未找到命令，im-select.nvim 也可以被 setup，但可能不会按预期工作
      -- 你可以选择在此处不调用 setup 或使用一个硬编码的 fallback
      -- require("im_select").setup({}) -- 如果你希望即使没有命令也初始化插件
    end
  end,
}
