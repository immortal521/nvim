return {
  "immortal521/llm.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  cmd = { "LLMSesionToggle", "LLMSelectedTextHandler" },
  config = function()
    require("llm").setup({
      prompt = "请用中文回答",
      url = "http://localhost:11434/api/chat", -- your url
      model = "qwen2.5-coder",
      LLM_KEY = "NONE",
      prefix = {
        user = { text = " ", hl = "Title" },
        assistant = { text = " ", hl = "Added" },
      },
      save_session = true,
      max_history = 15,
      history_path = vim.fn.stdpath("cache") .. "/ai_history",

      streaming_handler = function(chunk, line, assistant_output, bufnr, winid, F)
        if not chunk then
          return assistant_output
        end
        local tail = chunk:sub(-1, -1)
        if tail:sub(1, 1) ~= "}" then
          line = line .. chunk
        else
          line = line .. chunk
          local status, data = pcall(vim.fn.json_decode, line)
          if not status or not data.message.content then
            return assistant_output
          end
          assistant_output = assistant_output .. data.message.content
          F.WriteContent(bufnr, winid, data.message.content)
          line = ""
        end
        return assistant_output
      end,
      keys = {
        -- The keyboard mapping for the input window.
        ["Input:Submit"] = { mode = "n", key = "<cr>" },
        ["Input:Cancel"] = { mode = "n", key = "<C-c>" },
        ["Input:Resend"] = { mode = "n", key = "<C-r>" },

        -- only works when "save_session = true"
        ["Input:HistoryNext"] = { mode = "n", key = "<C-j>" },
        ["Input:HistoryPrev"] = { mode = "n", key = "<C-k>" },

        -- The keyboard mapping for the output window in "split" style.
        ["Output:Ask"] = { mode = "n", key = "i" },
        ["Output:Cancel"] = { mode = "n", key = "<C-c>" },
        ["Output:Resend"] = { mode = "n", key = "<C-r>" },

        -- The keyboard mapping for the output and input windows in "float" style.
        ["Session:Toggle"] = { mode = "n", key = "<leader>ac" },
        ["Session:Close"] = { mode = "n", key = "<esc>" },
      },
    })
    require("which-key").add({
    })
  end,
}
