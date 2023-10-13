local highlight = as.highlight
local icons, fn = as.ui.icons, vim.fn

local border = as.ui.border.rectangle

return {
  -- INDENTBLANKLINE
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      scope = { enabled = false },
      indent = {
        char = "┊", -- │, ┊, │, ▏, ┆, ┊, , ┊
      },
      exclude = {
        filetypes = {
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
        },
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      -- local hooks = require "ibl.hooks"
      -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },
  -- DRESSING
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
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
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
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
    init = function()
      highlight.plugin("notify", {
        { NoiceCmdlinePopupBorder = { fg = { from = "Directory" } } },
      })
    end,
    opts = {
      -- debug = true,
      lsp = {
        -- documentation = {
        --   opts = {
        --     border = { style = "rounded" },
        --     position = { row = 2 },
        --   },
        -- },
        progress = {
          enabled = false,
        },
        signature = { auto_open = { enabled = false } },
        hover = { enabled = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
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
      redirect = { view = "popup", filter = { event = "msg_show" } },
      views = {
        vsplit = { size = { width = "auto" } },
        split = { win_options = { winhighlight = { Normal = "Normal" } } },
        popup = {
          border = { style = border, padding = { 0, 1 } },
        },
        cmdline_popup = {
          position = {
            row = -5,
            col = "50%",
          },
          size = {
            width = "auto",
            height = "auto",
          },
        },
        confirm = {
          border = { style = border, padding = { 0, 1 }, text = { top = "" } },
        },
        popupmenu = {
          relative = "editor",
          position = { row = -5, col = "50%" },
          size = { width = 60, height = 10 },
          border = { style = border, padding = { 0, 1 } },
          win_options = { winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" } },
        },
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
              { event = "msg_show", find = "%d+ lines, %d+ bytes" },
              { event = "msg_show", kind = "search_count" },
              { event = "msg_show", find = "%d+L, %d+B" },
              { event = "msg_show", find = "^Hunk %d+ of %d" },
              { event = "msg_show", find = "%d+ change" },
              { event = "msg_show", find = "%d+ line" },
              { event = "msg_show", find = "%d+ more line" },
              -- TODO: investigate the source of this LSP message and disable it happens in typescript files
              { event = "notify", find = "No information available" },
            },
          },
          view = "mini",
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        -- bottom_search = true,         -- use a classic bottom cmdline for search
        -- command_palette = false,      -- position the cmdline and popupmenu together
        -- long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        -- lsp_doc_border = true,        -- add a border to hover docs and signature help

        inc_rename = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
  -- STATUSCOL
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPre",
    enabled = false,
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
    },
  },
  -- BUFFERLINE
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "gl", "<CMD>BufferLineCycleNext<CR>", desc = "Buffer(Bufferline): next buffer" },
      { "gh", "<CMD>BufferLineCyclePrev<CR>", desc = "Buffer(Bufferline): prev buffer" },
      { "<leader><BS>", "<CMD>BufferLineGroupToggle docs<CR>", desc = "Buffer(Bufferline): group close docs" },
    },
    opts = function()
      local col_base_bg_attr = "Normal"
      local col_base_fg_attr = "Pmenu"

      local col_unselected_bg_attr = "bufferline_unselected"
      local col_unselected_fg_attr = "Pmenu"

      local col_selected_fg_attr = "Boolean"
      local col_selected_bg_attr = "PmenuSel"

      local col_selected_sp = "bufferline_unselected"

      local bufferline = require "bufferline"

      return {
        options = {
          -- mode = "tabs",
          -- show_buffer_close_icon = false,
          -- buffer_close_icon = "",
          -- sort_by = "insert_after_current",
          -- show_close_icon = true,
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          -- max_name_length = 100,
          -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          -- truncate_names = true, -- whether or not tab names should be truncated
          -- max_prefix_length = 5,
          -- diagnostics_update_in_insert = false,
          -- hover = { enabled = true, reveal = { "close" } },
          -- separator_style = "thick",
          diagnostics_indicator = function(_, _, diag)
            local icons_diagnostic = icons.diagnostics
            local ret = (diag.error and icons_diagnostic.Error .. diag.error .. " " or "")
              .. (diag.warning and icons_diagnostic.Warn .. diag.warning or "")
            return vim.trim(ret)
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
            fg = { attribute = "bg", highlight = col_base_fg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          close_button_visible = {
            fg = { attribute = "fg", highlight = col_base_fg_attr },
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
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
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
          -- highlight = "Normal",
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
  -- BLOCK NVIM
  {
    "HampusHauffman/block.nvim",
    cmd = { "BlockOn", "BlockOff", "Block" },
    opts = {},
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
