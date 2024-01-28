local fn = vim.fn
local Highlight = require "r.config.highlights"
local Util = require "r.utils"

return {
  -- MINI.INDENTSCOPE
  {
    "echasnovski/mini.indentscope",
    version = "*",
    main = "mini.indentscope",
    event = { "VeryLazy" },
    config = function(_, opts)
      Highlight.plugin("mini.indentscopeUi", {
        { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
      })
      require("mini.indentscope").setup(opts)

      Util.cmd.augroup("DetachMiniIndentScope", {
        event = { "FileType" },
        pattern = {
          "NeogitCommitMessage",
          "NeogitPopup",
          "NeogitStatus",
          "NvimTree",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
          "checkhealth",
          "dashboard",
          "fzf",
          "gitcommit",
          "help",
          "lazy",
          "lspinfo",
          "make",
          "man",
          "markdown",
          "mason",
          "neorg",
          "norg",
          "org",
          "orgagenda",
          "Outline",
          "sagafinder",
        },
        command = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      symbol = "┊",
      mappings = {
        goto_top = "<leader>k",
        goto_bottom = "<leader>j",
      },
      options = {
        try_as_border = true,
      },
      draw = {
        animation = function()
          return 0
        end,
      },
    },
  },
  -- INDENT-BLANKLINE
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "ColorScheme" },
    main = "ibl",
    opts = {
      scope = { enabled = false },
      indent = {
        char = "┊", -- │, ┊, │, ▏, ┆, ┊, , ┊
        tab_char = "┊", -- │, ┊, │, ▏, ┆, ┊, , ┊
        repeat_linebreak = false,
      },
      exclude = {
        filetypes = {
          "NvimTree",
          "dashboard",
          "dbout",
          "flutterToolsOutline",
          "fzf",
          "fzflua",
          "git",
          "gitcommit",
          "help",
          "log",
          "markdown",
          "neo-tree",
          "man",
          "neo-tree-popup",
          "norg",
          "org",
          "orgagenda",
          "sagafinder",
          "txt",
          "undotree",
        },
      },
    },
    config = function(_, opts)
      Highlight.plugin("ibl_indentline", {
        { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
        { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
      })
      require("ibl").setup(opts)
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        -- event = "VeryLazy",
        -- init = function()
        --   vim.notify = require "notify"
        -- end,
        opts = function()
          vim.notify = require "notify"

          return {
            timeout = 5000,
            max_width = function()
              return math.floor(vim.o.columns * 0.6)
            end,
            top_down = false,
            max_height = function()
              return math.floor(vim.o.lines * 0.8)
            end,

            -- on_open = function(win)
            --   if not vim.api.nvim_win_is_valid(win) then
            --     return
            --   end
            --   vim.api.nvim_win_set_config(win, { border = require("r.config").icons.border.line })
            -- end,
            render = function(...)
              local notification = select(2, ...)
              local style = Util.cmd.falsy(notification.title[1]) and "minimal" or "default"
              require("notify.render")[style](...)
            end,
            on_open = function(win)
              vim.api.nvim_win_set_config(win, { zindex = 175 })
              if not vim.g.notifications_enabled then
                vim.api.nvim_win_close(win, true)
              end
              if not package.loaded["nvim-treesitter"] then
                pcall(require, "nvim-treesitter")
              end
              vim.wo[win].conceallevel = 3
              local buf = vim.api.nvim_win_get_buf(win)
              if not pcall(vim.treesitter.start, buf, "markdown") then
                vim.bo[buf].syntax = "markdown"
              end
              vim.wo[win].spell = false
            end,
          }
        end,
        -- config = function(_, opts)
        --   -- require("r.config.highlights").plugin("notify", {
        --   --   { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
        --   --   { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
        --   --   { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
        --   --   { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
        --   --   { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
        --   --   { NotifyERRORBody = { link = "NormalFloat" } },
        --   --   { NotifyWARNBody = { link = "NormalFloat" } },
        --   --   { NotifyINFOBody = { link = "NormalFloat" } },
        --   --   { NotifyDEBUGBody = { link = "NormalFloat" } },
        --   --   { NotifyTRACEBody = { link = "NormalFloat" } },
        --   -- })
        --   require("notify").setup(opts)
        -- end,
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        ---@diagnostic disable-next-line: param-type-mismatch
        function() require("noice").redirect(fn.getcmdline()) end,
        mode = "c",
        desc =
        "Redirect Cmdline"
      },
      { "<leader>rD", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    },
    opts = function()
      require("r.config.highlights").plugin("notify", {
        { NoiceCmdlinePopupBorder = { fg = { from = "Directory" } } },
        { NotifyBackground = { bg = { from = "Normal", attr = "fg", alter = 1 } } },
      })

      return {
        -- debug = true,
        lsp = {
          documentation = {
            opts = {
              border = { style = "rounded" },
              position = { row = 2 },
            },
          },
          progress = {
            enabled = false,
          },
          signature = { auto_open = { enabled = true }, enabled = false },
          hover = { enabled = true },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
          },
        },
        cmdline = {
          view = "cmdline",
        },
        messages = {
          -- Using kevinhwang91/nvim-hlslens because virtualtext is hard to read
          view_search = false,
        },
        popupmenu = {
          backend = "cmp",
        },
        routes = {
          {
            opts = { skip = true },
            filter = {
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
                { event = { "msg_showmode", "msg_showcmd", "msg_ruler" } },
                { event = "msg_show", find = "written" },
                { event = "msg_show", find = "%d+ lines, %d+ bytes" },
                { event = "msg_show", kind = "search_count" },
                { event = "msg_show", find = "%d+L, %d+B" },
                { event = "msg_show", find = "^Hunk %d+ of %d" },
                { event = "msg_show", find = "%d+ change" },
                { event = "msg_show", find = "%d+ line" },
                { event = "msg_show", find = "%d+ more line" },
                -- TODO: investigate the source of this LSP message and disable it happens in typescript files
                -- https://github.com/nvimdev/lspsaga.nvim/issues/1295
                { event = "notify", find = "No information available" },
              },
            },
            view = "mini",
          },
        },
        presets = {
          command_palette = true, -- position the cmdline and popupmenu together
          bottom_search = true, -- use a classic bottom cmdline for search
          inc_rename = true, -- enables an input dialog for inc-rename.nvim
          long_message_to_split = true, -- long messages will be sent to a split
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  -- FOLD CYCLE
  {
    "jghauser/fold-cycle.nvim",
    opts = {},
    keys = {
      {
        "<Leader>z",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold(fold-cycle): cycle fold",
      },
      {
        "z<Leader>",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold(fold-cycle): cycle fold",
      },
    },
  },
  -- INCLINE.NVIM
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    opts = function()
      return {
        highlight = {
          groups = {
            InclineNormal = {
              guifg = Highlight.tint(Highlight.get("Normal", "bg"), -0.5),
              guibg = Highlight.tint(Highlight.get("Normal", "fg"), 1),
              gui = "bold",
            },

            InclineNormalNC = {
              guifg = Highlight.tint(Highlight.get("LineNr", "fg"), 1),
              guibg = Highlight.tint(Highlight.get("Normal", "bg"), 0.5),
              gui = "bold",
            },
          },
        },
        window = { margin = { vertical = 0, horizontal = 2 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      }
    end,
  },
  -- SMOOTHCURSOR.NVIM
  {
    "gen740/SmoothCursor.nvim",
    event = "BufWinEnter",
    cond = vim.g.neovide == nil,
    opts = function()
      return {
        type = "default", -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".

        cursor = "", -- Cursor shape (requires Nerd Font). Disabled in fancy mode.
        texthl = "SmoothCursor", -- Highlight group. Default is { bg = nil, fg = "#FFD400" }. Disabled in fancy mode.
        linehl = nil, -- Highlights the line under the cursor, similar to 'cursorline'. "CursorLine" is recommended. Disabled in fancy mode.

        fancy = {
          enable = true, -- enable fancy mode
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
          body = {
            { cursor = "󰝥", texthl = "SmoothCursorRed" },
            { cursor = "󰝥", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" }, -- false to disable fancy tail
        },

        matrix = { -- Loaded when 'type' is set to "matrix"
          head = {
            -- Picks a random character from this list for the cursor text
            cursor = require "smoothcursor.matrix_chars",
            -- Picks a random highlight from this list for the cursor text
            texthl = {
              "SmoothCursor",
            },
            linehl = nil, -- No line highlight for the head
          },
          body = {
            length = 6, -- Specifies the length of the cursor body
            -- Picks a random character from this list for the cursor body text
            cursor = require "smoothcursor.matrix_chars",
            -- Picks a random highlight from this list for each segment of the cursor body
            texthl = {
              "SmoothCursorGreen",
            },
          },
          tail = {
            -- Picks a random character from this list for the cursor tail (if any)
            cursor = nil,
            -- Picks a random highlight from this list for the cursor tail
            texthl = {
              "SmoothCursor",
            },
          },
          unstop = false, -- Determines if the cursor should stop or not (false means it will stop)
        },

        autostart = true, -- Automatically start SmoothCursor
        always_redraw = true, -- Redraw the screen on each update
        flyin_effect = nil, -- Choose "bottom" or "top" for flying effect
        speed = 25, -- Max speed is 100 to stick with your current position
        intervals = 35, -- Update intervals in milliseconds
        priority = 1, -- Set marker priority
        timeout = 3000, -- Timeout for animations in milliseconds
        threshold = 3, -- Animate only if cursor moves more than this many lines
        disable_float_win = false, -- Disable in floating windows
        enabled_filetypes = nil, -- Enable only for specific file types, e.g., { "lua", "vim" }
        disabled_filetypes = { "fzf", "dashboard", "alpha", "rgflow", "orgagenda" },
      }
    end,
  },
  -- NVIM-TRANSPARENT
  {
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    cond = vim.g.neovide == nil,
    opts = {
      extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups

        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",

        "Normal",
      },
      exclude_groups = { "Folded" }, -- table: groups you don't want to clear
    },
    config = function(_, opts)
      require("transparent").setup(opts)
    end,
  },
}
