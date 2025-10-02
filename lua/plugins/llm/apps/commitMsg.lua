local tools = require("llm.tools")
local prompts = require("plugins.llm.prompts")

return {
  handler = tools.flexi_handler,
  prompt = prompts.CommitMsg,

  opts = {
    max_tokens = 8000,
    api_type = "openai",
    fetch_key = function()
      return vim.env.OpenRouter
    end,
    enter_flexible_window = true,
    apply_visual_selection = false,
    win_opts = {
      relative = "editor",
      position = "50%",
      zindex = 100,
    },
    accept = {
      mapping = {
        mode = "n",
        keys = "<cr>",
      },

      action = function()
        local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

        local cmd = string.format('!git commit -m "%s"', table.concat(contents, '" -m "'))
        cmd = (cmd:gsub(".", {
          ["#"] = "\\#",
        }))
        vim.api.nvim_command(cmd)

        -- 打开 LazyGit（可选）
        vim.schedule(function()
          Snacks.lazygit({ cwd = LazyVim.root.git() })
        end)
      end,
    },
  },
}
