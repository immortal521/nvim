vim.lsp.config('lua_ls', {
  -- 初始化回调函数，在 LSP 启动时调用
  on_init = function(client)
    -- 检查工作区文件夹配置
    if client.workspace_folders then
      -- 获取工作区第一个文件夹的路径
      local path = client.workspace_folders[1].name
      -- 如果路径不是 Neovim 配置路径，并且路径下包含 .luarc.json 或 .luarc.jsonc 文件，则跳过
      if path ~= vim.fn.stdpath('config') and
         (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end

    -- 合并 Lua 语言服务器配置
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      -- 配置 Lua 运行时
      runtime = {
        -- 设置 Lua 版本为 LuaJIT（通常 Neovim 使用 LuaJIT）
        version = 'LuaJIT',
        -- 设置 Lua 模块的路径，确保语言服务器能正确加载模块
        path = {
          'lua/?.lua',         -- 查找 lua/?.lua 文件
          'lua/?/init.lua',    -- 查找 lua/?/init.lua 文件
        },
      },
      -- 配置工作区设置
      workspace = {
        -- 设置是否检查第三方库，设为 false 以避免不必要的检查
        checkThirdParty = false,
        -- 配置 Lua 语言服务器的库路径
        library = {
          -- 将 Neovim 的运行时路径添加到 Lua 语言服务器的库路径中
          vim.env.VIMRUNTIME,
          -- 如果需要，还可以添加其他路径（例如 luv、busted 库等）
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
      },
    })
  end,

  -- 配置 Lua 语言服务器的其他设置
  settings = {
    -- Lua 设置
    Lua = {
      -- 可以在此处加入其他自定义设置，具体可以参考 lua-language-server 的文档
      -- 例如，启用/禁用某些规则、修改诊断级别等
    },
  },
})