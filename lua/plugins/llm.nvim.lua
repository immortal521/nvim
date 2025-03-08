local function local_llm_streaming_handler(chunk, ctx, F)
  if not chunk then
    return ctx.assistant_output
  end
  local tail = chunk:sub(-1, -1)
  if tail:sub(1, 1) ~= "}" then
    ctx.line = ctx.line .. chunk
  else
    ctx.line = ctx.line .. chunk
    local status, data = pcall(vim.fn.json_decode, ctx.line)
    if not status or not data.message.content then
      return ctx.assistant_output
    end
    ctx.assistant_output = ctx.assistant_output .. data.message.content
    F.WriteContent(ctx.bufnr, ctx.winid, data.message.content)
    ctx.line = ""
  end
  return ctx.assistant_output
end

local function local_llm_parse_handler(chunk)
  local assistant_output = chunk.message.content
  return assistant_output
end

return {
  "Kurama622/llm.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
  config = function()
    local tools = require("llm.tools")
    require("llm").setup({

      url = "http://localhost:11434/api/chat",
      model = "qwen2.5-coder",

      prompt = "You are a helpful chinese assistant.",
      prefix = {
        user = { text = " ", hl = "Title" },
        assistant = { text = " ", hl = "Added" },
      },

      save_session = true,
      max_history = 15,
      max_history_name_length = 20,
      history_path = vim.fn.stdpath("cache") .. "/llm-history",

      streaming_handler = local_llm_streaming_handler,
      parse_handler = local_llm_parse_handler,
      display = {
        diff = {
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },
      app_handler = {
        OptimizeCode = {
          handler = tools.side_by_side_handler,
        },
        TestCode = {
          handler = tools.side_by_side_handler,
          prompt = [[ Write some test cases for the following code, only return the test cases.
                        Give the code content directly, do not use code blocks or other tags to wrap it. Reply with Chinese ]],
          opts = {
            right = {
              title = " Test Cases ",
            },
          },
        },
        Translate = {
          handler = tools.qa_handler,
          prompt = "Please translate the content after the newline character to Chinese, if it's already in Chinese, translate it to English. Only return the translated content.\n",
        },
        OptimCompare = {
          handler = tools.action_handler,
          opts = {
            language = "Chinese",
          },
        },
        WordTranslate = {
          handler = tools.flexi_handler,
          prompt = "Please translate the content after the newline character to Chinese, if it's already in Chinese, translate it to English. Only return the translated content.\n",
          opts = {
            exit_on_move = true,
            enter_flexible_window = false,
          },
        },
        CodeExplain = {
          handler = tools.flexi_handler,
          prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
          opts = {
            enter_flexible_window = true,
          },
        },
        DocString = {
          prompt = [[You are an AI programming assistant. You need to write a really good docstring that follows a best practice for the given language.

Your core tasks include:
- parameter and return types (if applicable).
- any errors that might be raised or returned, depending on the language.

You must:
- Place the generated docstring before the start of the code.
- Follow the format of examples carefully if the examples are provided.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.]],
          handler = tools.action_handler,
          opts = {
            only_display_diff = true,
            templates = {
              lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".
]],
            },
          },
        },
      },
      CommitMsg = {
        handler = tools.flexi_handler,
        prompt = function()
          -- Source: https://andrewian.dev/blog/ai-git-commits
          return string.format(
            [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
      1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.)
      2. Optional bullet points if more context helps:
        - Keep the second line blank
        - Keep them short and direct
        - Focus on what changed
        - Always be terse
        - Don't overly explain
        - Drop any fluffy or formal language

      Return ONLY the commit message - no introduction, no explanation, no quotes around it.

      Examples:
      feat: add user auth system

      - Add JWT tokens for API auth
      - Handle token refresh for long sessions

      fix: resolve memory leak in worker pool

      - Clean up idle connections
      - Add timeout for stale workers

      Simple change example:
      fix: typo in README.md

      Very important: Do not respond with any of the examples. Your message must be based off the diff that is about to be provided, with a little bit of styling informed by the recent commits you're about to see.

      Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

      ```diff
      %s
      ```
      ]],
            vim.fn.system("git diff --no-ext-diff --staged")
          )
        end,

        opts = {
          enter_flexible_window = true,
          apply_visual_selection = false,
          win_opts = {
            relative = "editor",
            position = "50%",
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
      },

      keys = {
        -- The keyboard mapping for the input window.
        ["Input:Submit"] = { mode = { "i", "n" }, key = "<C-g>" },
        ["Input:Cancel"] = { mode = { "i", "n" }, key = "<C-c>" },
        ["Input:Resend"] = { mode = { "i", "n" }, key = "<C-r>" },

        -- only works when "save_session = true"
        ["Input:HistoryNext"] = { mode = { "i", "n" }, key = "<C-j>" },
        ["Input:HistoryPrev"] = { mode = { "i", "n" }, key = "<C-k>" },

        -- The keyboard mapping for the output window in "split" style.
        ["Output:Ask"] = { mode = "n", key = "i" },
        ["Output:Cancel"] = { mode = "n", key = "<C-c>" },
        ["Output:Resend"] = { mode = "n", key = "<C-r>" },

        -- The keyboard mapping for the output and input windows in "float" style.
        ["Session:Toggle"] = { mode = "n", key = "<leader>ac" },
        ["Session:Close"] = { mode = "n", key = "<esc>" },
      },
    })
  end,
  keys = {
    { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = "Start Chat" },
    -- { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>", desc = "Code Explain" },
    { "<leader>at", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>", desc = "Translate" },
    { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>", desc = "Translation Window" },
    -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>", desc = "Optimize" },
    { "<leader>tc", mode = "x", "<cmd>LLMAppHandler TestCode<cr>", desc = "Generate Test Code" },
    { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimCompare<cr>", desc = "Optimize Code" },
    { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>", desc = "Code Explain" },
    { "<leader>ag", mode = "n", "<cmd>LLMAppHandler CommitMsg<cr>", desc = "Generate Git Message" },
    { "<leader>ad", mode = "v", "<cmd>LLMAppHandler DocString<cr>", desc = "Generate Document" },
    -- { "<leader>at", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>", desc = "Translate" },
  },
}
