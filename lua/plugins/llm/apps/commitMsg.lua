local tools = require("llm.tools")
local prompts = require("plugins.llm.prompts")

return {
  handler = tools.flexi_handler,
  prompt = prompts.CommitMsg,

  opts = {
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
        vim.api.nvim_command(string.format('!git commit -m "%s"', table.concat(contents, '" -m "')))

        -- just for lazygit
        vim.schedule(function()
          vim.api.nvim_command("LazyGit")
        end)
      end,
    },
  },
}
