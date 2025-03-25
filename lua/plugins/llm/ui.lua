local Text = require("nui.text")
return {
  -- style = "right",

  chat_ui_opts = {
    relative = "editor",
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:String,FloatBorder:Float",
    },
    input = {
      float = {
        border = {
          text = {
            top = Text("  Enter Your Question ", "LlmYellowNormal"),
            top_align = "center",
          },
        },
        win_options = {
          winblend = 0,
          winhighlight = "Normal:String,FloatBorder:LlmYellowLight",
        },
        size = { height = "10%", width = "80%" },
        order = 2,
      },
      -- for split style
      split = {
        relative = "win",
        position = {
          row = "80%",
          col = "50%",
        },
        border = {
          text = {
            top = Text("  Enter Your Question ", "LlmYellowNormal"),
            top_align = "center",
          },
        },
        win_options = {
          winblend = 0,
          winhighlight = "Normal:String,FloatBorder:LlmYellowLight",
        },
        size = { height = "5%", width = "80%" },
      },
    },
    output = {
      float = {
        size = { height = "90%", width = "80%" },
        order = 1,
        win_options = {
          winblend = 0,
          winhighlight = "Normal:Normal,FloatBorder:Title",
        },
      },
    },
    history = {
      float = {
        size = { height = "100%", width = "20%" },
        win_options = {
          winblend = 0,
          winhighlight = "Normal:LlmBlueNormal,FloatBorder:Title",
        },
        order = 3,
      },
      split = {
        relative = "win",
        size = { height = "30%", width = "60%" },
      },
    },
  },

  -- popup window options
  popwin_opts = {
    relative = "cursor",
    enter = true,
    focusable = true,
    zindex = 50,
    position = { row = -7, col = 15 },
    size = { height = 15, width = "50%" },
    border = { style = "single", text = { top = " Explain ", top_align = "center" } },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  },
}
