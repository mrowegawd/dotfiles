local fn = vim.fn

return {
  -- INDENTBLANKLINE
  {
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
    lazy = false, -- butuh seperti ini? Karena setup indent-blankline terbaru harus diload sebelum colorscheme
    priority = 900,
    -- event = "LazyFile",
    main = "ibl",
    opts = {
      scope = { enabled = false },
      indent = {
        char = "┊", -- │, ┊, │, ▏, ┆, ┊, , ┊
      },
      exclude = {
        filetypes = {
          "dbout",
          "dashboard",
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
      require("r.config.highlights").plugin("ibl_indentline", {
        { ["@ibl.indent.char.1"] = { fg = { from = "ColorColumn", attr = "bg", alter = 0.15 } } },
      })
      require("ibl").setup(opts)
    end,
  },
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    init = function()
      vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
      vim.notify = require "notify"
    end,
    opts = {
      timeout = 3000,
      max_width = function()
        return math.floor(vim.o.columns * 0.6)
      end,
      max_height = function()
        return math.floor(vim.o.lines * 0.8)
      end,

      on_open = function(win)
        if not vim.api.nvim_win_is_valid(win) then
          return
        end
        vim.api.nvim_win_set_config(win, { border = require("r.config").icons.border.rectangle })
      end,
      -- render = function(...)
      --   local notification = select(2, ...)
      --   local style = falsy(notification.title[1]) and 'minimal' or 'default'
      --   require('notify.render')[style](...)
      -- end,
      -- on_open = function(win)
      --   vim.api.nvim_win_set_config(win, { zindex = 175 })
      --   if not vim.g.notifications_enabled then
      --     vim.api.nvim_win_close(win, true)
      --   end
      --   if not package.loaded["nvim-treesitter"] then
      --     pcall(require, "nvim-treesitter")
      --   end
      --   vim.wo[win].conceallevel = 3
      --   local buf = vim.api.nvim_win_get_buf(win)
      --   if not pcall(vim.treesitter.start, buf, "markdown") then
      --     vim.bo[buf].syntax = "markdown"
      --   end
      --   vim.wo[win].spell = false
      -- end,
    },
    config = function(_, opts)
      require("r.config.highlights").plugin("notify", {
        { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
        { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
        { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
        { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
        { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
        { NotifyERRORBody = { link = "NormalFloat" } },
        { NotifyWARNBody = { link = "NormalFloat" } },
        { NotifyINFOBody = { link = "NormalFloat" } },
        { NotifyDEBUGBody = { link = "NormalFloat" } },
        { NotifyTRACEBody = { link = "NormalFloat" } },
      })
      require("notify").setup(opts)
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
      "MunifTanjim/nui.nvim",
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
      require("r.config.highlights").plugin("notify", {
        { NoiceCmdlinePopupBorder = { fg = { from = "Directory" } } },
      })
    end,
    opts = {
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
    },
  },
  -- STATUSCOL
  {
    "luukvbaal/statuscol.nvim",
    event = "LazyFile",
    enabled = false,
    opt = function()
      local builtin = require "statuscol.builtin"
      return {
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
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Buffer(bufferline): toggle pin" },
      {
        "<leader>bc",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Buffer(bufferline): delete non-pinned buffers",
      },
      { "<leader>bO", "<Cmd>BufferLineCloseOthers<CR>", desc = "Buffer(bufferline): delete other buffers" },
      { "<leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Buffer(bufferline): delete buffers to the right" },
      { "<leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Buffer(bufferline): delete buffers to the left" },
    },
    opts = function()
      local col_base_bg_attr = "ColorColumn"
      local col_base_fg_attr = "Comment"

      local col_unselected_bg_attr = "bufferline_unselected"
      local col_unselected_fg_attr = "Boolean"

      local col_sp_fg_attr = "ErrorMsg"

      local col_selected_fg_attr = "PmenuSel"
      local col_selected_bg_attr = "@field"

      if require("r.config").colorscheme == "material" then
        col_selected_bg_attr = "PmenuSel"
        col_selected_fg_attr = "PmenuSel"
      end

      local col_selected_sp = "bufferline_unselected"

      local bufferline = require "bufferline"

      return {
        options = {
          mode = "buffers",
          buffer_close_icon = "",
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          separator_style = "thin",
          indicator = { style = "underline" },
          diagnostics_indicator = function(_, _, diag)
            local icons = require("r.config").icons.diagnostics
            local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
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
          },
          background = {
            fg = { attribute = "fg", highlight = col_base_fg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ TAB                                                      ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          tab = {
            bg = { attribute = "bg", highlight = "ColorColumn" },
          },
          tab_close = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          tab_selected = {
            bg = { attribute = "fg", highlight = col_selected_bg_attr },
            fg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          tab_separator = {
            fg = { attribute = "bg", highlight = col_base_bg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          tab_separator_selected = {
            bg = { attribute = "fg", highlight = col_selected_bg_attr },
            fg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ INDICATOR                                                ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          indicator_visible = {
            fg = { attribute = "bg", highlight = col_base_fg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          indicator_selected = {
            fg = { attribute = "bg", highlight = col_base_fg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ SEPARATOR                                                ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          separator = {
            fg = { attribute = "bg", highlight = col_base_bg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          separator_visible = {
            fg = { attribute = "bg", highlight = col_base_bg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          separator_selected = {
            fg = { attribute = "bg", highlight = col_base_bg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ CLOSE                                                    ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          close_button = {
            fg = { attribute = "bg", highlight = col_base_bg_attr },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          close_button_visible = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          close_button_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ BUFFER                                                   ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          buffer = {
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          buffer_visible = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          buffer_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ PICK                                                     ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
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
            bg = { attribute = "fg", highlight = col_selected_bg_attr },
            italic = false,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ MODIFIED                                                 ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          modified = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            fg = { attribute = "fg", highlight = col_selected_sp },
          },
          modified_visible = {
            fg = { attribute = "fg", highlight = "ErrorMsg" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          modified_selected = {
            fg = { attribute = "fg", highlight = "ErrorMsg" },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ DUPLICATE                                                ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          duplicate = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            italic = false,
          },
          duplicate_visible = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          duplicate_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ OFFSET                                                   ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          offset_separator = {
            fg = { attribute = "bg", highlight = col_selected_bg_attr },
            bg = { attribute = "fg", highlight = col_selected_bg_attr },
          },
          --  ┍━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑
          --  │ DIAGNOSTICS                                              │
          --  ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙
          diagnostic_visible = {
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          diagnostic_selected = {
            bg = { attribute = "fg", highlight = col_selected_bg_attr },
          },
          --  ╒══════════════════════════════════════════════════════════╕
          --  │ WARNING                                                  │
          --  ╘══════════════════════════════════════════════════════════╛
          warning = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          warning_visible = {
            fg = { attribute = "fg", highlight = col_selected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = false,
          },
          warning_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
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
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ╒══════════════════════════════════════════════════════════╕
          --  │ ERROR                                                    │
          --  ╘══════════════════════════════════════════════════════════╛
          error = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          error_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
          },
          error_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
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
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ╒══════════════════════════════════════════════════════════╕
          --  │ HINT                                                     │
          --  ╘══════════════════════════════════════════════════════════╛
          hint = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          hint_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          hint_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
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
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
          --  ╒══════════════════════════════════════════════════════════╕
          --  │ INFO                                                     │
          --  ╘══════════════════════════════════════════════════════════╛
          info = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
          },
          info_visible = {
            fg = { attribute = "fg", highlight = col_unselected_fg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            italic = true,
          },
          info_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
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
            bg = { attribute = "bg", highlight = col_unselected_bg_attr },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
        },
      }
    end,
  },
  -- NVIM-SCROLLBAR (disabled)
  {
    "petertriho/nvim-scrollbar",
    enabled = false,
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
  -- BLOCK NVIM (disabled)
  {
    "HampusHauffman/block.nvim",
    enabled = false,
    cmd = { "BlockOn", "BlockOff", "Block" },
    opts = {},
  },
  -- SCROLLEOF (disabled)
  {
    "Aasim-A/scrollEOF.nvim",
    enabled = false,
    opts = {
      pattern = "*",
    },
    config = function(_, opts)
      require("scrollEOF").setup(opts)
    end,
  },
}
