local fn = vim.fn
local Highlight = require "r.settings.highlights"
local Config = require "r.config"

return {
  -- MINI.INDENTSCOPE
  {
    "echasnovski/mini.indentscope",
    version = "*",
    main = "mini.indentscope",
    event = { "VeryLazy" },
    config = function(_, opts)
      Highlight.plugin("mini.indentscopeUi", {
        theme = {
          ["*"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["catppuccin-latte"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = -0.3 } } },
          },
          ["farout"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
          },
          ["ayu"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
          },
          ["nord"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
          },
          ["vscode_modern"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
          },
          ["flexoki"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 2 } } },
          },
        },
      })
      require("mini.indentscope").setup(opts)

      RUtils.cmd.augroup("DetachMiniIndentScope", {
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
          "",
        },
      },
    },
    config = function(_, opts)
      Highlight.plugin("ibl_indentline", {
        theme = {
          ["*"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["catppuccin-latte"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -1 } } },
          },
          ["farout"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
          },
          ["ayu"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["solarized-osaka"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["flexoki"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.1 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.1 } } },
          },
        },
      })
      require("ibl").setup(opts)
    end,
  },
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    -- init = function()
    --   vim.notify = require "notify"
    -- end,
    -- TODO: nanti hapus ini,
    -- kalau ini sudah di merge
    -- https://github.com/rcarriga/nvim-notify/pull/253
    -- pin = true,
    opts = function()
      vim.notify = require "notify"

      return {
        stages = "static",
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
          local style = RUtils.cmd.falsy(notification.title[1]) and "minimal" or "default"
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
    config = function(_, opts)
      Highlight.plugin("NotifyCol", {
        -- { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyERRORBody = { link = "NormalFloat" } },
        -- { NotifyWARNBody = { link = "NormalFloat" } },
        -- { NotifyDEBUGBody = { link = "NormalFloat" } },
        -- { NotifyTRACEBody = { link = "NormalFloat" } },
        { NotifyINFOBody = { bg = { from = "NotifyINFOIcon", attr = "bg" } } },
        { NotifyHINTBody = { bg = { from = "NotifyHINTIcon", attr = "bg" } } },
        { NotifyWARNBody = { bg = { from = "NotifyWARNIcon", attr = "bg" } } },
        { NotifyERRORBody = { bg = { from = "NotifyERRORIcon", attr = "bg" } } },
        { NotifyDEBUGBody = { bg = { from = "NotifyDEBUGIcon", attr = "bg" } } },
        { NotifyTRACEBody = { bg = { from = "NotifyTRACEIcon", attr = "bg" } } },
      })
      require("notify").setup(opts)
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<a-o>",
        ---@diagnostic disable-next-line: param-type-mismatch
        function()
          require("noice").redirect(fn.getcmdline())
        end,
        mode = "c",
        desc = "Misc(noice): redirect cmdline",
      },
    },
    opts = function()
      Highlight.plugin("notify", {
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
          signature = { auto_open = { enabled = true }, enabled = true },
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
          -- view_search = false,
          enabled = true, -- enables the Noice messages UI
          view = "notify", -- default view for messages
          view_error = "notify", -- view for errors
          view_warn = "notify", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        popupmenu = {
          enabled = false,
          backend = "cmp",
        },
        redirect = { view = "popup", filter = { event = "msg_show" } },
        routes = {
          {
            opts = { skip = true },
            filter = {
              any = {
                -- { find = "%d+L, %d+B" },
                -- { find = "; after #%d+" },
                -- { find = "; before #%d+" },
                { event = "msg_show", find = "written" },
                { event = "msg_show", find = "%d+ lines, %d+ bytes" },
                { event = "msg_show", kind = "search_count" },
                { event = "msg_show", find = "%d+L, %d+B" },
                { event = "msg_show", find = "^Hunk %d+ of %d" },
                { event = "msg_show", find = "%d+ change" },
                { event = "msg_show", find = "%d+ line" },
                { event = "msg_show", find = "%d+ more line" },
                -- { event = "msg_show", find = "error list" },
              },
            },
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
  -- INCLINE.NVIM (disabled)
  {
    "b0o/incline.nvim",
    enabled = false,
    event = "LazyFile",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return {
        highlight = {
          groups = {
            InclineNormal = {
              guifg = RUtils.colortbl.norm_bg,
            },
            InclineNormalNC = {
              guifg = RUtils.colortbl.separator_fg_alt,
              guibg = RUtils.colortbl.norm_bg,
            },
          },
        },
        window = { margin = { vertical = 0, horizontal = 0 } },
        hide = {
          cursorline = true,
          focused_win = false,
          only_win = false,
        },
        ignore = {
          buftypes = "special",
          filetypes = { "alpha", "dashboard", "fzf" },
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = "special",
        },

        render = function(props)
          local function file_modified()
            if props.focused then
              if vim.bo[props.buf].modified then
                return {
                  " " .. Config.icons.misc.boldclose,
                  guifg = Highlight.get("DiagnosticSignError", "fg"),
                  gui = "bold",
                  guibg = RUtils.colortbl.separator_fg,
                }
              end
            else
              if vim.bo[props.buf].modified then
                return {
                  " " .. Config.icons.misc.boldclose,
                  guifg = Highlight.get("DiagnosticSignError", "fg"),
                  gui = "bold",
                  guibg = RUtils.colortbl.separator_fg_alt,
                }
              end
            end
          end

          local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":h:t")
          local fnc = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local filename = dirname .. "/" .. fnc

          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          if ft_icon == nil then
            ft_icon = ""
          end

          local modified = vim.api.nvim_get_option_value("modified", { buf = props.buf }) and "bold,italic" or "bold"

          if props.focused then
            return {
              {
                guibg = RUtils.colortbl.separator_fg,
                guifg = RUtils.colortbl.norm_bg,
                Config.icons.misc.separator_up,
              },
              {
                file_modified(),
              },
              {
                " " .. ft_icon .. " ",
                guifg = ft_color,
                guibg = RUtils.colortbl.separator_fg,
              },
              {
                filename .. " ",
                guibg = RUtils.colortbl.separator_fg,
                gui = modified,
              },
              {
                guifg = RUtils.colortbl.separator_fg,
                Config.icons.misc.separator_up,
              },
            }
          else
            return {
              {
                guifg = RUtils.colortbl.norm_bg,
                guibg = RUtils.colortbl.separator_fg_alt,
                Config.icons.misc.separator_up,
              },
              {
                file_modified(),
              },
              {
                " " .. ft_icon .. " ",
                guifg = ft_color,
                guibg = RUtils.colortbl.separator_fg_alt,
              },
              {
                filename .. " ",
                -- guifg = Highlight.tint(Highlight.get("Normal", "fg"), -0.9),
                guifg = RUtils.colortbl.norm_fg,
                guibg = RUtils.colortbl.separator_fg_alt,
                gui = modified,
              },
              {
                guifg = RUtils.colortbl.separator_fg_alt,
                guibg = RUtils.colortbl.norm_bg,
                Config.icons.misc.separator_up,
              },
            }
          end
        end,
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
  -- BEACON
  {
    "rainbowhxch/beacon.nvim",
    event = "LazyFile",
    cond = vim.g.neovide == nil,
    opts = function()
      Highlight.plugin("beaconHiC", {
        { ["BeaconDefault"] = { bg = "red" } },
      })

      return {
        minimal_jump = 50,
        ignore_buffers = { "terminal", "nofile", "neorg://Quick Actions" },
        ignore_filetypes = {
          "qf",
          "dap_watches",
          "dap_scopes",
          -- "neo-tree",
          "fzf",
          "lazy",
          "NeogitCommitMessage",
          "NeogitPopup",
          "NeogitStatus",
        },
      }
    end,
  },
  -- BUFFERLINE
  {
    "akinsho/bufferline.nvim",
    event = "LazyFile",
    -- keys = {
    --   { "gl", "<CMD>BufferLineCycleNext<CR>", desc = "Buffer(Bufferline): next buffer" },
    --   { "gh", "<CMD>BufferLineCyclePrev<CR>", desc = "Buffer(Bufferline): prev buffer" },
    --   -- { "<Leader><Left>", "<cmd>BufferLineMovePrev<cr>", desc = "Buffer(bufferline): move buffer prev" },
    --   -- { "<Leader><Right>", "<cmd>BufferLineMoveNext<cr>", desc = "Buffer(bufferline): move buffer next" },
    --
    --   -- { "spp", "<Cmd>BufferLineTogglePin<CR>", desc = "Buffer(bufferline): toggle pin" },
    --   -- {
    --   --   "<Leader>bc",
    --   --   "<Cmd>BufferLineGroupClose ungrouped<CR>",
    --   --   desc = "Buffer(bufferline): delete non-pinned buffers",
    --   -- },
    --   -- { "sO", "<Cmd>BufferLineCloseOthers<CR>", desc = "Buffer(bufferline): delete other buffers" },
    --   -- { "s#", "<Cmd>BufferLineCloseRight<CR>", desc = "Buffer(bufferline): delete buffers to the right" },
    --   -- { "s@", "<Cmd>BufferLineCloseLeft<CR>", desc = "Buffer(bufferline): delete buffers to the left" },
    -- },
    opts = function()
      local col_base_bg_attr = "bufferline_fill_bg"
      local col_base_fg_attr = "Comment"

      local buffer_selected_bg = "bufferline_selected_bg"
      local buffer_selected_fg = "Boolean"

      local col_sp_fg_attr = "ErrorMsg"

      local col_selected_fg_attr = "PmenuSel"
      local col_selected_bg_attr = "Boolean"

      local col_selected_fg = Highlight.tint(Highlight.get("Boolean", "fg"), 2)
      local col_select_visible_fg = Highlight.tint(Highlight.get("Boolean", "fg"), 0.2)

      if Config.colorscheme == "catppuccin-latte" then
        col_selected_fg = Highlight.tint(Highlight.get("Boolean", "fg"), -0.1)
        col_select_visible_fg = Highlight.tint(Highlight.get("Boolean", "fg"), -0.2)
        col_selected_bg_attr = "PmenuSel"
        col_selected_fg_attr = "PmenuSel"
      end

      local col_selected_sp = "bufferline_unselected"

      local bufferline = require "bufferline"

      return {
        options = {
          mode = "tabs",
          buffer_close_icon = "󰒲",
          modified_icon = Config.icons.misc.boldclose,
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          separator_style = "slant", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },

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
                    if ext == vim.fn.fnamemodify(buf.path, ":e") then
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
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            fg = { attribute = "fg", highlight = col_base_fg_attr },
          },
          background = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            fg = { attribute = "fg", highlight = col_base_fg_attr },
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
            fg = { attribute = "bg", highlight = buffer_selected_bg },
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
            fg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
          },
          close_button_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ BUFFER                                                   ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          buffer = {
            bg = { attribute = "bg", highlight = buffer_selected_bg },
          },
          buffer_visible = {
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          buffer_selected = {
            fg = col_selected_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            -- bold = true,
          },
          --  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
          --  ╎ PICK                                                     ╎
          --  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
          pick = {
            bg = { attribute = "bg", highlight = col_base_bg_attr },
            italic = false,
          },
          pick_selected = {
            fg = { attribute = "fg", highlight = buffer_selected_fg },
            -- bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          modified_selected = {
            fg = { attribute = "fg", highlight = "ErrorMsg" },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            -- fg = { attribute = "fg", highlight = col_selected_fg_attr },
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          duplicate_selected = {
            fg = col_selected_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            -- fg = { attribute = "fg", highlight = col_selected_fg_attr },
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          warning_selected = {
            -- fg = { attribute = "fg", highlight = col_selected_bg_attr },
            fg = col_selected_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          warning_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticWarn" },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          error_selected = {
            fg = col_selected_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          error_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticError" },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          hint_selected = {
            fg = col_selected_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          hint_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticHint" },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          info_selected = {
            fg = col_selected_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
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
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          info_diagnostic_selected = {
            fg = { attribute = "fg", highlight = "DiagnosticInfo" },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
            bold = true,
          },
        },
      }
    end,
  },
  -- NUI-COMPONENTS
  {
    "grapp-dev/nui-components.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
}
