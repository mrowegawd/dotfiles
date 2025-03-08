local Highlight = require "r.settings.highlights"

return {
  -- FLASH.NVIM
  {
    "folke/flash.nvim",
    opts = function()
      Highlight.plugin("flash.nvim", {
        {
          FlashMatch = {
            fg = "white",
            bg = "red",
            bold = true,
          },
        },
        {
          FlashLabel = {
            bg = "black",
            fg = "yellow",
            bold = true,
            strikethrough = false,
          },
        },
        { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },
      })
      return {
        modes = {
          char = {
            keys = { "F", "T", ";" }, -- remove "," from keys
          },
          search = { enabled = false },
        },
        jump = { nohlsearch = true },
      }
    end,
    -- stylua: ignore
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash: jump" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash: treesiter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash: remote" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },
  -- GRUG-FAR.NVIM
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    keys = {
      {
        "<Leader>uF",
        "<CMD>GrugFar<CR>",
        desc = "Misc: open grug [grugfar]",
      },
      {
        "<Leader>uF",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "v" },
        desc = "Misc: open grug (visual) [grugfar]",
      },
    },
    opts = function()
      local norm = Highlight.get("Directory", "fg")
      local bg = Highlight.tint(norm, -0.6)
      local fg = Highlight.tint(norm, 0.5)
      Highlight.plugin("grugfarHiCo", {
        {
          GrugFarResultsPath = {
            bg = bg,
            fg = fg,
            bold = true,
          },
        },
      })
      return {
        keymaps = {
          replace = { n = "<c-c>" },
          qflist = { n = "<c-q>" },
          syncLocations = { n = "<Localleader>s" },
          syncLine = { n = "<Localleader>l" },
          close = { n = "q" },
          historyOpen = { n = "<Leader>h" },
          historyAdd = { n = "<Leader>A" },
          refresh = { n = "R" },
          gotoLocation = { n = "<enter>" },
          pickHistoryEntry = { n = "<enter>" },
        },
      }
    end,
  },
  -- TODOCOMMENTS
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
      {
        "<Leader>fT",
        function()
          RUtils.todocomments.search_global {
            title = "Global",
          }
          vim.cmd "normal! zz"
        end,
        desc = "TODOCOMMENTS: todo global dir (fzflua)",
      },
      {
        "<Leader>ft",
        function()
          RUtils.todocomments.search_local {
            title = "Curbuf",
          }
          vim.cmd "normal! zz"
        end,
        desc = "TODOCOMMENTS: todo local dir (fzflua)",
      },
      -- { "<Leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      keywords = {
        FIX = {
          icon = RUtils.config.icons.misc.tools,
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        WARN = {
          icon = RUtils.config.icons.misc.bug,
          color = "warning",
          alt = { "WARNING", "WARN" },
        },
        TODO = { icon = RUtils.config.icons.misc.check_big, color = "info" },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      -- merge_keywords = false,
      highlight = {
        before = "", -- "fg", "bg", or empty
        keyword = "wide", -- "fg", "bg", "wide", or empty
        after = "fg", -- "fg", "bg", or empty
        pattern = [[.*<(KEYWORDS)*:]],
        comments_only = true, -- highlight only inside comments using treesitter
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      colors = {
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
      },
      search = {
        command = "rg",
        pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
        args = {
          "--color=never",
          "--no-heading",
          "--follow",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "-g",
          "!node_modules/**",
          "-g",
          "!.git/**",
        },
      },
    },
  },
  -- TROUBLE.NVIM
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<Leader>xr",
        "<cmd>Trouble lsp_references toggle focus=true auto_refresh=false<cr>",
        desc = "LSP: references [trouble]",
      },
      {
        "<c-q>",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end

          vim.cmd "Trouble quickfix toggle focus=true"
        end,
        ft = "qf",
        desc = "QF: open in trouble [trouble]",
      },
      -- {
      --   "gi",
      --   "<cmd>Trouble lsp_implementations toggle focus=true win.position=right<cr>",
      --   desc = "LSP: implementations [trouble]",
      -- },
      -- {
      --   "gO",
      --   "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=right<cr>",
      --   desc = "LSP: outgoing calls [trouble]",
      -- },
      -- {
      --   "gI",
      --   "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=right<cr>",
      --   desc = "LSP: incomming calls [trouble]",
      -- },
      -- {
      --   "gt",
      --   "<cmd>Trouble lsp_type_definitions<CR>",
      --   desc = "LSP: type definitions [trouble]",
      -- },
      {
        "<Leader>xt",
        function()
          vim.cmd [[TodoTrouble]]
        end,
        desc = "Trouble: todo trouble [trouble]",
      },
      {
        "<Leader>xD",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end

          vim.cmd [[Trouble diagnostics toggle]]
        end,
        desc = "Diagnostic: workspaces diagnostics [trouble]",
      },
      {
        "<Leader>xd",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd [[Trouble diagnostics toggle filter.buf=0]]
        end,
        desc = "Diagnostic: document diagnostisc [trouble]",
      },
      {
        "<Leader>xl",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble loclist toggle"
        end,
        desc = "Qf: open location list with [trouble]",
      },
      {
        "<Leader>xq",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble qflist toggle"
        end,
        desc = "Qf: open quickfix list with [trouble]",
      },
    },
    opts = function()
      local icons_lsp = RUtils.config.icons.kinds
      Highlight.plugin("troubleColHi", {
        theme = {
          ["*"] = {
            { TroubleNormal = { inherit = "Normal" } },
            { TroubleNormalNC = { inherit = "Normal" } },

            { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn" } } },
            { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError" } } },
            { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint" } } },
            { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
            { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
            { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },

            { TroubleIndent = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.25 } } },

            -- Directory
            { TroubleDirectory = { bg = "NONE" } },
            {
              TroubleFsCount = {
                fg = { from = "GitSignsChange", attr = "fg", alter = -0.1 },
                bg = "NONE",
                italic = true,
              },
            },

            -- LSP
            { TroubleLspFilename = { bg = "NONE" } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleLspCount = {
                fg = { from = "GitSignsChange", attr = "fg", alter = -0.1 },
                bg = "NONE",
                italic = true,
              },
            },

            -- Diagnostics
            { TroubleDiagnosticsBasename = { bg = "NONE" } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleDiagnosticsCount = {
                fg = { from = "GitSignsChange", attr = "fg", alter = -0.1 },
                bg = "NONE",
                italic = true,
              },
            },

            -- Todo
            { TroubleTodoFilename = { bg = "NONE" } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleTodoCount = {
                fg = { from = "GitSignsChange", attr = "fg", alter = -0.1 },
                bg = "NONE",
                italic = true,
              },
            },

            -- QF
            { TroubleQfFilename = { bg = "NONE" } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleQfCount = {
                fg = { from = "GitSignsChange", attr = "fg", alter = -0.1 },
                bg = "NONE",
                italic = true,
              },
            },

            -- Dunno
            {
              TroubleCode = {
                bg = "NONE",
                fg = { from = "ErrorMsg", attr = "fg" },
                underline = false,
              },
            },
          },
          ["jellybeans"] = {
            { TroubleIndent = { fg = { from = "WinSeparator", attr = "fg", alter = 0.4 } } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
          },
          ["lackluster"] = {
            { TroubleIndent = { fg = { from = "WinSeparator", attr = "fg", alter = 0.5 } } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
          },
          ["midnight"] = {
            { TroubleIndent = { fg = { from = "WinSeparator", attr = "fg", alter = 0.5 } } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
          },
          ["ashen"] = {
            { TroubleIndent = { fg = { from = "WinSeparator", attr = "fg", alter = 0.8 } } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
          },
        },
      })
      return {
        icons = {
          kinds = {
            Array = icons_lsp.Array,
            Boolean = icons_lsp.Boolean,
            Class = icons_lsp.Classs,
            Constant = icons_lsp.Constant,
            Constructor = icons_lsp.Constructor,
            Enum = icons_lsp.Enum,
            EnumMember = icons_lsp.EnumMember,
            Event = icons_lsp.Event,
            Field = icons_lsp.Field,
            File = icons_lsp.File,
            Function = icons_lsp.Function,
            Interface = icons_lsp.Interface,
            Key = icons_lsp.Interface,
            Method = icons_lsp.Key,
            Module = icons_lsp.Method,
            Namespace = icons_lsp.Namespace,
            Null = icons_lsp.Null,
            Number = icons_lsp.Number,
            Object = icons_lsp.Object,
            Operator = icons_lsp.Operator,
            Package = icons_lsp.Package,
            Property = icons_lsp.Property,
            String = icons_lsp.String,
            Struct = icons_lsp.Struct,
            TypeParameter = icons_lsp.TypeParameter,
            Variable = icons_lsp.Variable,
          },
        },
        keys = {
          ["<esc>"] = "cancel",
          ["q"] = "close",
          ["o"] = "jump",
          ["<c-n>"] = "next",
          ["<c-p>"] = "prev",
        },
      }
    end,
  },
}
