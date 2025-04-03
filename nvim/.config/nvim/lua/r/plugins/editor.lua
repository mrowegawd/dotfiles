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
    cmd = { "GrugFar", "GrugFarWithin" },
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
      Highlight.plugin("grugfarHiCo", {
        theme = {
          ["*"] = {
            {
              GrugFarResultsPath = {
                fg = { from = "GrugFarHelpHeaderKey", attr = "fg" },
                bg = { from = "GrugFarHelpHeaderKey", attr = "fg", alter = -0.65 },
                -- bg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
                bold = true,
                underline = false,
              },
            },
            {
              GrugFarResultsLineNo = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
              },
            },
            { GrugFarResultsLineColumn = { link = "GrugFarResultsLineNo" } },

            {
              GrugFarResultsMatch = {
                fg = { from = "CurSearch", attr = "bg", alter = 0.5 },
                bg = { from = "CurSearch", attr = "bg", alter = -0.6 },
                bold = true,
              },
            },
            {
              GrugFarResultsNumberLabel = {
                fg = { from = "CurSearch", attr = "bg", alter = -0.2 },
              },
            },
          },
          ["oxocarbon"] = {
            {
              GrugFarResultsLineNo = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
                bg = { from = "Normal", attr = "bg", alter = 0.4 },
              },
            },
            { GrugFarResultsLineColumn = { link = "GrugFarResultsLineNo" } },
            {
              GrugFarResultsMatch = {
                fg = { from = "CurSearch", attr = "bg", alter = 0.2 },
                bg = { from = "CurSearch", attr = "bg", alter = -0.7 },
                bold = true,
              },
            },
          },
          ["ashen"] = {
            {
              GrugFarResultsLineNo = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
              },
            },
            {
              GrugFarResultsMatch = {
                fg = { from = "CurSearch", attr = "bg", alter = -0.2 },
                bg = { from = "CurSearch", attr = "bg", alter = -0.7 },
                bold = true,
              },
            },
          },
          ["ef-eagle"] = {
            {
              GrugFarResultsPath = {
                fg = { from = "GrugFarHelpHeaderKey", attr = "fg" },
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
                -- bg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
                bold = true,
                underline = false,
              },
            },
          },
          ["nord"] = {
            {
              GrugFarResultsLineNo = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
              },
            },
            {
              GrugFarResultsMatch = {
                fg = { from = "CurSearch", attr = "bg", alter = 0.8 },
                bg = { from = "CurSearch", attr = "bg", alter = -0.6 },
                bold = true,
              },
            },
          },
          ["lackluster"] = {
            {
              GrugFarResultsLineNo = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
              },
            },
            {
              GrugFarResultsMatch = {
                fg = { from = "Directory", attr = "fg", alter = 0.8 },
                bg = { from = "Directory", attr = "fg", alter = -0.5 },
                bold = true,
              },
            },
            {
              GrugFarResultsNumberLabel = {
                fg = { from = "Directory", attr = "fg" },
              },
            },
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
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
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

      local rose_pine = {
        ["rose-pine-dawn"] = {
          {
            TroubleIndentFoldClosed = {
              fg = { from = "LineNr", attr = "fg", alter = -0.1 },
              bg = "NONE",
            },
          },
          { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },
          {
            TroubleIndent = {
              fg = { from = "IndentGuides", attr = "fg", alter = -0.08 },
            },
          },

          { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
          {
            TroubleQfCount = {
              fg = { from = "Directory", attr = "fg", alter = 0.5 },
              bg = { from = "Directory", attr = "fg" },
              italic = true,
            },
          },

          { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
          {
            TroubleTodoCount = {
              fg = { from = "TodoBgTODO", attr = "bg", alter = 1 },
              bg = { from = "TodoBgTODO", attr = "bg" },
              italic = true,
            },
          },

          { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
          {
            TroubleDiagnosticsCount = {
              fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 },
              bg = { from = "GitSignsChange", attr = "fg", alter = 0.5 },
              italic = true,
            },
          },

          { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
          {
            TroubleLspCount = {
              fg = { from = "Normal", attr = "fg", alter = -0.2 },
              bg = { from = "Normal", attr = "fg", alter = 0.6 },
              italic = true,
            },
          },

          {
            TroubleFsCount = {
              fg = { from = "Comment", attr = "fg", alter = 0.5 },
              bg = { from = "Comment", attr = "fg", alter = 0.05 },
              italic = true,
            },
          },
        },
        -- ["rose-pine-main"] = {
        --   { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.25 } } },
        -- },
      }
      Highlight.plugin("troubleColHi", {
        theme = {
          ["*"] = {
            { TroubleNormal = { inherit = "Normal" } },
            { TroubleNormalNC = { inherit = "Normal" } },

            { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn", alter = -0.1 } } },
            { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError", alter = -0.1 } } },
            { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint", alter = -0.1 } } },
            { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
            { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
            { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },

            {
              TroubleIndentFoldClosed = {
                fg = { from = "IndentGuidesFolded", attr = "fg", alter = 0.5 },
                bg = "NONE",
              },
            },
            { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },
            {
              TroubleIndent = {
                fg = { from = "IndentGuides", attr = "fg", alter = 0.5 },
              },
            },

            -- ──────────────────────────────────────────────────────────────────────
            -- DIRECTORY
            -- ──────────────────────────────────────────────────────────────────────
            { TroubleDirectory = { bg = "NONE" } },
            {
              TroubleFsCount = {
                fg = { from = "Comment", attr = "fg" },
                bg = { from = "Comment", attr = "fg", alter = -0.6 },
                italic = true,
              },
            },

            -- ──────────────────────────────────────────────────────────────────────
            -- LSP
            -- ──────────────────────────────────────────────────────────────────────
            { TroubleLspFilename = { bg = "NONE" } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleLspCount = {
                fg = { from = "Normal", attr = "fg" },
                bg = { from = "Normal", attr = "fg", alter = -0.6 },
                italic = true,
              },
            },

            -- ──────────────────────────────────────────────────────────────────────
            -- DIAGNOSTICS
            -- ──────────────────────────────────────────────────────────────────────
            { TroubleDiagnosticsBasename = { bg = "NONE" } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleDiagnosticsCount = {
                fg = { from = "GitSignsChange", attr = "fg" },
                bg = { from = "GitSignsChange", attr = "fg", alter = -0.6 },
                italic = true,
              },
            },

            -- ──────────────────────────────────────────────────────────────────────
            -- TODO
            -- ──────────────────────────────────────────────────────────────────────
            { TroubleTodoFilename = { bg = "NONE" } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleTodoCount = {
                fg = { from = "TodoBgTODO", attr = "bg" },
                bg = { from = "TodoBgTODO", attr = "bg", alter = -0.5 },
                italic = true,
              },
            },

            -- ──────────────────────────────────────────────────────────────────────
            -- QUICKFIX
            -- ──────────────────────────────────────────────────────────────────────
            { TroubleQfFilename = { bg = "NONE" } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            {
              TroubleQfCount = {
                fg = { from = "Directory", attr = "fg" },
                bg = { from = "Directory", attr = "fg", alter = -0.5 },
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
            {
              TroubleTodoCount = {
                fg = { from = "TodoFgTodo", attr = "fg", alter = 0.5 },
                bg = { from = "TodoFgTodo", attr = "fg", alter = -0.2 },
                italic = true,
              },
            },
          },
          ["ashen"] = {
            { TroubleIndent = { fg = { from = "WinSeparator", attr = "fg", alter = 0.8 } } },
            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.07 } } },
          },
          ["rose-pine"] = rose_pine[RUtils.config.colorscheme],
          ["ef-eagle"] = {
            {
              TroubleIndentFoldClosed = {
                fg = { from = "IndentGuidesFolded", attr = "fg", alter = -0.1 },
                bg = "NONE",
              },
            },
            { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },
            {
              TroubleIndent = {
                fg = { from = "IndentGuides", attr = "fg", alter = -0.08 },
              },
            },

            { TroubleQfPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
            {
              TroubleQfCount = {
                fg = { from = "Directory", attr = "fg", alter = 5 },
                bg = { from = "Directory", attr = "fg", alter = 1 },
                italic = true,
              },
            },

            { TroubleTodoPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
            {
              TroubleTodoCount = {
                fg = { from = "TodoBgTODO", attr = "bg", alter = 1 },
                bg = { from = "TodoBgTODO", attr = "bg", alter = 0.1 },
                italic = true,
              },
            },

            { TroubleDiagnosticsPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
            {
              TroubleDiagnosticsCount = {
                fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 },
                bg = { from = "GitSignsChange", attr = "fg", alter = 0.5 },
                italic = true,
              },
            },

            { TroubleLspPos = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.07 } } },
            {
              TroubleLspCount = {
                fg = { from = "Normal", attr = "fg", alter = -0.2 },
                bg = { from = "Normal", attr = "fg", alter = 0.6 },
                italic = true,
              },
            },

            {
              TroubleFsCount = {
                fg = { from = "Comment", attr = "fg", alter = 0.5 },
                bg = { from = "Comment", attr = "fg", alter = 0.05 },
                italic = true,
              },
            },
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
