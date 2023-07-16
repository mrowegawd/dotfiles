local highlight = as.highlight
local border, icons, api, fn, L = as.ui.border.rectangle, as.ui.icons, vim.api, vim.fn, vim.log.levels

local ufo_config_handler = require("r.utils").ufo_handler

local isUfoFold = true

return {
  -- INDENTBLANK
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "UIEnter",
    opts = {
      char = "│", -- ┆ ┊ 
      show_trailing_blankline_indent = false,
      show_current_context = false,
      filetype_exclude = {
        "dbout",
        "neo-tree-popup",
        "log",
        "gitcommit",
        "txt",
        "fzf",
        "help",
        "NvimTree",
        "git",
        "flutterToolsOutline",
        "undotree",
        "markdown",
        "norg",
        "org",
        "orgagenda",
        "fzflua",
        "", -- for all buffers without a file type
      },
    },
  },
  -- MINI.INDENTSCOPE (disabled)
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    version = false, -- wait till new 0.7.0 release to put it back on semver
    enabled = false,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "NvimTree",
          "Trouble",
          "fzf",
          "lazy",
          "aerial",
          "outline",
          "sagaoutline",
          "mason",
          "norg",
          "org",
          "orgagenda",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      symbol = "┊", --- "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
  -- DRESSING
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { relative = "editor" },
      select = {
        backend = { "telescope", "fzf", "builtin" },
      },
    },
  },
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>rD",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Misc(nvim-notify): dismiss all notifications",
      },
    },
    config = function()
      highlight.plugin("notify", {
        { NotifyERRORBorder = { bg = { from = "Pmenu" } } },
        { NotifyWARNBorder = { bg = { from = "Pmenu" } } },
        { NotifyINFOBorder = { bg = { from = "Pmenu" } } },
        { NotifyDEBUGBorder = { bg = { from = "Pmenu" } } },
        { NotifyTRACEBorder = { bg = { from = "Pmenu" } } },
        { NotifyERRORBody = { link = "Pmenu" } },
        { NotifyWARNBody = { link = "Pmenu" } },
        { NotifyINFOBody = { link = "Pmenu" } },
        { NotifyDEBUGBody = { link = "Pmenu" } },
        { NotifyTRACEBody = { link = "Pmenu" } },
      })

      local notify = require "notify"

      notify.setup {
        timeout = 5000,
        stages = "fade_in_slide_out",
        top_down = false,
        background_colour = "NormalFloat",
        max_width = function()
          return math.floor(vim.o.columns * 0.6)
        end,
        max_height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        on_open = function(win)
          if not api.nvim_win_is_valid(win) then
            return
          end
          api.nvim_win_set_config(win, { border = border })
        end,
        render = function(...)
          local notification = select(2, ...)
          local style = as.falsy(notification.title[1]) and "minimal" or "default"
          require("notify.render")[style](...)
        end,
      }
    end,
  },
  -- NOICE (disabled)
  {
    -- :nmap output got wrong linebreaks
    -- https://github.com/folke/noice.nvim/issues/259
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      {
        "<s-enter>",
        function()
          return require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Noice: redirect cmdline",
      },
    },
    init = function()
      highlight.plugin("notify", {
        { NoiceCmdlinePopupBorder = { fg = { from = "Directory" } } },
      })
    end,
    opts = {
      -- debug = true,
      -- popupmenu = {
      --   backend = "nui",
      -- },
      lsp = {
        documentation = {
          opts = {
            border = { style = "rounded" },
            position = { row = 2 },
          },
        },
        progress = {
          enabled = true,
        },
        signature = {
          auto_open = { enabled = false },
        },
        hover = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },

      -- views = {
      --   cmdline_popup = {
      --     position = {
      --       row = -5,
      --       col = "50%",
      --     },
      --     size = {
      --       width = "auto",
      --       height = "auto",
      --     },
      --   },
      -- },

      -- "Classic" command line
      cmdline = {
        view = "cmdline",
      },

      messages = {
        -- Using kevinhwang91/nvim-hlslens because virtualtext is hard to read
        view_search = false,
      },

      -- redirect = { view = "popup", filter = { event = "msg_show" } },

      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      routes = {
        {
          opts = { skip = true },
          filter = {
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { event = "msg_show", find = "written" },
              {
                event = "msg_show",
                find = "%d+ lines, %d+ bytes",
              },
              { event = "msg_show", kind = "search_count" },
              { event = "msg_show", find = "%d+L, %d+B" },
              { event = "msg_show", find = "^Hunk %d+ of %d" },
              { event = "msg_show", find = "%d+ change" },
              { event = "msg_show", find = "%d+ line" },
              { event = "msg_show", find = "%d+ more line" },
              -- TODO: investigate the source of this LSP message and disable it happens in typescript files
              {
                event = "notify",
                find = "No information available",
              },
            },
          },
        },
        -- {
        --   view = "vsplit",
        --   filter = { event = "msg_show", min_height = 20 },
        -- },
        {
          view = "notify",
          filter = {
            any = {
              { event = "msg_show", min_height = 10 },
              { event = "msg_show", find = "Treesitter" },
            },
          },
          opts = { timeout = 10000 },
        },
        {
          view = "notify",
          filter = { event = "notify", find = "Type%-checking" },
          opts = { replace = true, merge = true, title = "TSC" },
          stop = true,
        },
        {
          view = "mini",
          filter = {
            any = {
              { event = "msg_show", find = "^E486:" },
              { event = "notify", max_height = 1 },
            },
          }, -- minimise pattern not found messages
        },
        {
          view = "notify",
          filter = {
            any = {
              { warning = true },
              { event = "msg_show", find = "^Warn" },
              { event = "msg_show", find = "^W%d+:" },
              { event = "msg_show", find = "^No hunks$" },
            },
          },
          opts = {
            title = "Warning",
            level = L.WARN,
            merge = false,
            replace = false,
          },
        },
        {
          view = "notify",
          opts = {
            title = "Error",
            level = L.ERROR,
            merge = true,
            replace = false,
          },
          filter = {
            any = {
              { error = true },
              { event = "msg_show", find = "^Error" },
              { event = "msg_show", find = "^E%d+:" },
            },
          },
        },
        {
          view = "notify",
          opts = { title = "" },
          filter = { kind = { "emsg", "echo", "echomsg" } },
        },
      },
    },
  },
  -- STATUSCOL
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPre",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            sign = {
              name = { "GitSigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              -- fillcharhl = "StatusColumnSeparator",
            },
            click = "v:lua.ScSa",
          },
          { text = { "%s" } },
        },
        ft_ignore = {
          "NvimTree",
          "NeogitStatus",
          "NeogitCommitMessage",
          "toggleterm",
          "dapui_scopes",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_watches",
          "dapui_console",
          "dap-repl",
          "neotest-summary",
        },
        bt_ignore = {
          "terminal",
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
        "<a-o>",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold(fold-cycle): cycle fold",
      },
      -- {
      --   "<a-h>",
      --   function()
      --     require("fold-cycle").open()
      --   end,
      --   desc = "Fold(fold-cycle): cycle fold",
      -- },
      -- {
      --   "<a-a>",
      --   function()
      --     require("fold-cycle").close_all()
      --   end,
      --   desc = "Fold(fold-cycle): toggle all?",
      -- },
    },
  },
  -- NVIM-UVO (disabled)
  {
    -- NOTE ufo ini selalu jalan ketika buka ft apapun, seharusnya bisa di
    -- disable. Contoh ketika open AerialToggle, map zM harusnya milik Aerial bukan Ufo.
    -- Solusi lain mungkin dari issue ini:
    -- https://github.com/kevinhwang91/nvim-ufo/issues/33#issuecomment-1478102255
    "kevinhwang91/nvim-ufo",
    enabled = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    keys = {
      {
        "zC",
        function()
          return require("ufo").closeFoldsWith()
        end,
        desc = "Fold(ufo): close all fold",
      },
      {
        "zM",
        function()
          return require("ufo").closeFoldsWith()
        end,
        desc = "Fold(ufo): close all fold",
      },
      {
        "<a-u>",
        function()
          if isUfoFold then
            isUfoFold = false
            return require("ufo").closeFoldsWith()
          else
            isUfoFold = true
            return require("ufo").openAllFolds()
          end
        end,
        desc = "Fold(ufo): close fold",
      },
      {
        "zR",
        function()
          return require("ufo").openAllFolds()
        end,
        desc = "Fold(ufo): open all folds",
      },
      {
        "zP",
        function()
          return require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Fold(ufo): open peek folds",
      },
      {
        "<a-j>",
        "zj",
        desc = "Fold(ufo): go prev closed fold",
      },

      {
        "<a-k>",
        "zk",
        desc = "Fold(ufo): go prev closed fold",
      },

      {
        "<a-p>",
        function()
          return require("ufo").goPreviousClosedFold()
        end,
        desc = "Fold(ufo): go prev closed fold",
      },
      {
        "<a-n>",
        function()
          return require("ufo").goNextClosedFold()
        end,
        desc = "Fold(ufo): go next closed fold",
      },
    },

    init = function()
      as.augroup("UfoSettings", {
        event = "FileType",
        pattern = {
          "org",
          "alpha",
          "norg",
          "aerial",
          "Outline",
          "neo-tree",
          "DiffviewFileHistory",
        },
        command = function()
          local ufo = require "ufo"
          ufo.detach()
        end,
      })

      -- highlight.plugin("UfoNcolor", {
      --     {
      --         Folded = {
      --             bg = "NONE",
      --         },
      --     },
      -- })

      --     commands = {
      --         {
      --             ":UfoInspect",
      --             description = "Ufo: inspect",
      --         },
      --     },
      -- },
      -- }
    end,

    config = function()
      vim.o.foldlevel = 99 -- feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "1"

      local ufo = require "ufo"

      ufo.setup {
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = ufo_config_handler,
        close_fold_kinds = { "imports", "comment" },
        enable_get_fold_virt_text = true,
        ---@diagnostic disable-next-line: unused-local
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        preview = {
          win_config = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
          },
        },
      }
    end,
  },
  -- ORIGAMI (disabled)
  {
    "chrisgrieser/nvim-origami",
    enabled = false,
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = true, -- needed even when using default config
  },
  -- BUFFERLINE
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    keys = {
      { "gl", "<CMD>BufferLineCycleNext<CR>", desc = "Buffer(Bufferline): next buffer" },
      { "gh", "<CMD>BufferLineCyclePrev<CR>", desc = "Buffer(Bufferline): prev buffer" },
      { "<leader><BS>", "<CMD>BufferLineGroupToggle docs<CR>", desc = "Buffer(Bufferline): group close docs" },
    },
    config = function()
      local col_base_bg_attr = "Normal"
      local col_base_fg_attr = "Normal"

      local col_unselected_bg_attr = "bufferline_unselected"
      local col_unselected_fg_attr = "Normal"

      local col_selected_fg_attr = "Boolean"
      local col_selected_bg_attr = "PmenuSel"

      local col_selected_sp = "bufferline_unselected"

      local bufferline = require "bufferline"

      bufferline.setup {
        options = {
          mode = "tabs",
          modified_icon = "●",
          show_buffer_close_icon = false,
          buffer_close_icon = "",
          -- sort_by = "insert_after_current",
          show_close_icon = true,
          diagnostics = "nvim_lsp",
          max_name_length = 100,
          -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          -- truncate_names = true, -- whether or not tab names should be truncated
          -- max_prefix_length = 5,
          diagnostics_update_in_insert = false,
          hover = { enabled = true, reveal = { "close" } },
          separator_style = "thick",
          diagnostics_indicator = function(count, level)
            level = level:match "warn" and "warn" or level
            return (icons.diagnostics[level] or "?") .. count
          end,
          offsets = {
            {
              text = "EXPLORER",
              filetype = "NvimTree",
              highlight = "Directory",
              text_align = "left",
            },

            {
              text = " DIFF VIEW",
              filetype = "DiffviewFiles",
              highlight = "PanelHeading",
              separator = true,
            },

            {
              text = " DATABASE VIEWER",
              filetype = "dbui",
              highlight = "PanelHeading",
              separator = true,
            },

            {
              text = "EXPLORER",
              filetype = "neo-tree",
              highlight = "Directory",
              text_align = "left",
            },
          },
          groups = {
            options = { toggle_hidden_on_enter = true },
            items = {
              bufferline.groups.builtin.pinned:with {
                icon = "",
              },
              bufferline.groups.builtin.ungrouped,
              {
                name = "Dependencies",
                icon = "",
                highlight = { fg = "#ECBE7B" },
                matcher = function(buf)
                  return vim.startswith(buf.path, vim.env.VIMRUNTIME)
                end,
              },
              {
                name = "Terraform",
                matcher = function(buf)
                  return buf.name:match "%.tf" ~= nil
                end,
              },
              {
                name = "Kubernetes",
                matcher = function(buf)
                  return buf.name:match "kubernetes" and buf.name:match "%.yaml"
                end,
              },
              {
                name = "SQL",
                matcher = function(buf)
                  return buf.name:match "%.sql$"
                end,
              },
              {
                name = "tests",
                icon = "",
                matcher = function(buf)
                  local name = buf.name
                  return name:match "[_%.]spec" or name:match "[_%.]test"
                end,
              },
              {
                name = "docs",
                icon = "",
                matcher = function(buf)
                  if vim.bo[buf.id].filetype == "man" or buf.path:match "man://" then
                    return true
                  end
                  for _, ext in ipairs {
                    "md",
                    "txt",
                    "org",
                    "norg",
                    "wiki",
                  } do
                    if ext == fn.fnamemodify(buf.path, ":e") then
                      return true
                    end
                  end
                end,
              },
            },
          },
        },
        highlights = {
          fill = {
            fg = { attribute = "bg", highlight = col_base_fg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            italic = true,
          },
          background = {
            fg = { attribute = "fg", highlight = "Directory" },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            italic = true,
          },
          -- TAB ---------------------------------------------------
          tab = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          tab_close = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          tab_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            -- bg = { attribute = "bg", highlight = col_selected_bg_attr },
          },
          -- INDICATOR ----------------------------------------------
          indicator_visible = {
            fg = { attribute = "bg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
          },
          indicator_selected = {
            fg = { attribute = "bg", highlight = col_selected_bg_attr },
          },
          -- SEPARATOR ----------------------------------------------
          separator = {
            fg = { attribute = "bg", highlight = col_base_fg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          separator_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          separator_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            -- bg = { attribute = "bg", highlight = col_selected_bg_attr },
          },
          -- CLOSE --------------------------------------------------
          close_button = {
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          close_button_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          close_button_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
          },
          -- BUFFER -------------------------------------------------
          buffer = {
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          buffer_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          buffer_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = "ErrorMsg" },
            -- underline = true,
            italic = false,
          },
          -- PICK ---------------------------------------------------
          pick = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            italic = false,
          },
          pick_selected = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            -- bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          pick_visible = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            italic = false,
          },
          -- MODIFIED -----------------------------------------------
          modified = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            fg = { attribute = "fg", highlight = col_selected_sp },
          },
          modified_visible = {
            fg = { attribute = "fg", highlight = "ErrorMsg" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          modified_selected = {
            fg = { attribute = "fg", highlight = "ErrorMsg" },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
          },
          -- DUPLICATE ----------------------------------------------
          duplicate = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            italic = false,
          },
          duplicate_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          duplicate_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
          },
          -- OFFSET -------------------------------------------------
          offset_separator = {
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            fg = { attribute = "bg", highlight = col_selected_bg_attr },
          },
          -----------------------------------------------------------
          -- DIAGNOSTICS
          -----------------------------------------------------------
          diagnostic_visible = {
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          diagnostic_selected = {
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          -- WARNING ------------------------------------------------
          warning = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          warning_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          warning_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          warning_diagnostic = {
            fg = { attribute = "fg", highlight = "DiagnosticWarn" },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          warning_diagnostic_visible = {
            fg = { attribute = "fg", highlight = "DiagnosticWarn" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          warning_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticWarn" },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          -- ERROR --------------------------------------------------
          error = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          error_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          error_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          error_diagnostic = {
            fg = { attribute = "fg", highlight = "DiagnosticError" },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          error_diagnostic_visible = {
            fg = { attribute = "fg", highlight = "DiagnosticError" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          error_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticError" },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          -- HINT ---------------------------------------------------
          hint = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          hint_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          hint_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          hint_diagnostic = {
            fg = { attribute = "fg", highlight = "DiagnosticHint" },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          hint_diagnostic_visible = {
            fg = { attribute = "fg", highlight = "DiagnosticHint" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          hint_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticHint" },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          -- INFO ---------------------------------------------------
          info = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          info_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          info_selected = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
          info_diagnostic = {
            fg = { attribute = "fg", highlight = "DiagnosticInfo" },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          info_diagnostic_visible = {
            fg = { attribute = "fg", highlight = "DiagnosticInfo" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          info_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticInfo" },
            bg = { attribute = "bg", highlight = col_selected_bg_attr },
            -- sp = { attribute = "fg", highlight = col_selected_sp },
            -- underline = true,
            italic = false,
          },
        },
      }
    end,
  },
  -- SATELLITE (disabled)
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {
      current_only = true,
      excluded_filetypes = {
        "help",
        "alpha",
        "undotree",
        "neo-tree",
        "gitcommit",
        "gitrebase",
        "fzf",
        "qf",
      },
    },
  },
  -- NVIM-SCROLLBAR
  {
    "petertriho/nvim-scrollbar",
    event = "VimEnter",
    opts = {
      show = true,
      set_highlights = true,
      handle = {
        text = " ",
        color = "#3F4A5A",
        cterm = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
      },
      marks = {
        Search = {
          text = { "-", "=" },
          priority = 0,
          color = nil,
          cterm = nil,
          highlight = "Search",
        },
        Error = {
          text = { "-", "=" },
          priority = 1,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "-", "=" },
          priority = 2,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "-", "=" },
          priority = 3,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "-", "=" },
          priority = 4,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-", "=" },
          priority = 5,
          color = nil,
          cterm = nil,
          highlight = "Normal",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "lazy",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          -- "TextChanged",
          "VimResized",
          "WinScrolled",
        },
      },
      handlers = {
        diagnostic = true,
        search = true, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
      },
    },
    -- config = function(_, opts)
    --   require("scrollbar").setup(opts)
    -- end,
  },
  -- NEOSCROLL
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    -- enabled = false,
    opts = {
      hide_cursor = true,
      mappings = { "<C-d>", "<C-u>", "zt", "zz", "zb" },
    },
  },
  -- SMOOTHCURSOR (disabled)
  {
    "gen740/SmoothCursor.nvim",
    event = "BufReadPre",
    enabled = false,
    config = function()
      require("smoothcursor").setup {
        fancy = { enable = true },
        disabled_filetypes = { "fzf", "neo-tree", "lazy" }, -- this option will be skipped if enabled_filetypes is set. example: { "TelescopePrompt", "NvimTree" }
        disable_float_win = true, -- disable on float window
      }
      -- Always enable on `BufEnter`.
      vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "FocusGained", "InsertLeave" }, {
        pattern = "*",
        callback = function()
          vim.cmd "SmoothCursorStart"
        end,
      })
      -- Strangely, we can use `BufWinLeave` to detect filetype `lazy`.
      vim.api.nvim_create_autocmd({ "BufWinLeave", "FocusLost", "InsertEnter" }, {
        pattern = "*",
        callback = function()
          vim.cmd "SmoothCursorStop"
        end,
      })
    end,
  },
  -- BLOCK NVIM
  {
    "HampusHauffman/block.nvim",
    cmd = { "BlockOn", "BlockOff", "Block" },
    config = function()
      require("block").setup {}
    end,
  },
  -- SHADE (disabled)
  {
    "sunjon/shade.nvim",
    enabled = false,
    config = function()
      require("shade").setup()
      require("shade").toggle()
    end,
  },
  -- EDGY.NVIM (disabled)
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    enabled = false,
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
      {
        "<leader>uE",
        function()
          require("edgy").select()
        end,
        desc = "Edgy Select Window",
      },
    },
    opts = function()
      local opts = {
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            ---@diagnostic disable-next-line: unused-local
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "noice",
            size = { height = 0.4 },
            ---@diagnostic disable-next-line: unused-local
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "lazyterm",
            title = "LazyTerm",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          -- { ft = "spectre_panel", size = { height = 0.4 } },
          {
            title = "Neotest Output",
            ft = "neotest-output-panel",
            size = { height = 15 },
          },
        },
        left = {
          {
            title = "Neo-Tree",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            pinned = true,
            open = function()
              vim.api.nvim_input "<esc><space>e"
            end,
            size = { height = 0.5 },
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
          -- {
          --     title = "Neo-Tree Git",
          --     ft = "neo-tree",
          --     filter = function(buf)
          --         return vim.b[buf].neo_tree_source == "git_status"
          --     end,
          --     pinned = true,
          --     open = "Neotree position=right git_status",
          -- },
          -- {
          --     title = "Neo-Tree Buffers",
          --     ft = "neo-tree",
          --     filter = function(buf)
          --         return vim.b[buf].neo_tree_source == "buffers"
          --     end,
          --     pinned = true,
          --     open = "Neotree position=top buffers",
          -- },
          -- "neo-tree",
        },
        keys = {
          -- increase width
          ["<a-L>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<a-H>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<a-K>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<a-J"] = function(win)
            win:resize("height", -2)
          end,
        },
      }
      if as.has "symbols-outline.nvim" then
        table.insert(opts.left, {
          title = "Outline",
          ft = "Outline",
          pinned = true,
          open = "SymbolsOutline",
        })
      end
      return opts
    end,
  },
  -- CELLULARAUTOMATON
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
  },
  -- BEACON (disabled)
  {
    "rainbowhxch/beacon.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      minimal_jump = 20,
      ignore_buffers = { "terminal", "nofile", "neorg://Quick Actions" },
      ignore_filetypes = {
        "qf",
        "dap_watches",
        "dap_scopes",
        "neo-tree",
        "NeogitCommitMessage",
        "NeogitPopup",
        "NeogitStatus",
      },
    },
  },
}
