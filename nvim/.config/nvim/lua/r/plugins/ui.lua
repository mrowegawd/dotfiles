local fn = vim.fn
local Highlight = require "r.settings.highlights"

return {
  -- INDENT-BLANKLINE
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "ColorScheme" },
    main = "ibl",
    opts = function()
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
      return {
        scope = { show_start = false, show_end = false },
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
            "man",
            "markdown",
            "neo-tree",
            "neo-tree-popup",
            "norg",
            "calendar",
            "org",
            "orgagenda",
            "sagafinder",
            "trouble",
            "txt",
            "undotree",
            "",
          },
        },
      }
    end,
  },
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      if not RUtils.has "noice.nvim" then
        RUtils.on_very_lazy(function()
          vim.notify = require "notify"
        end)
      end
    end,
    opts = function()
      Highlight.plugin("NotifyCol", {
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
        render = function(...)
          local notification = select(2, ...)
          local style = RUtils.cmd.falsy(notification.title[1]) and "minimal" or "default"
          require("notify.render")[style](...)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 175 })
        end,
      }
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<S-CR>",
        ---@diagnostic disable-next-line: param-type-mismatch
        function()
          require("noice").redirect(fn.getcmdline())
        end,
        mode = "c",
        desc = "Noice: redirect cmdline",
      },
      {
        "<Localleader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Noice: dismiss all",
      },
      {
        "<Localleader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Noice: last message",
      },
      {
        "<Localleader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice: history",
      },
      {
        "<Localleader>np",
        function()
          require("noice").cmd "pick"
        end,
        desc = "Noice: picker (telescope/fzflua)",
      },
    },
    opts = function()
      Highlight.plugin("notify", {
        { NoiceCmdlinePopupBorder = { fg = { from = "Directory" } } },
        { NoiceCmdlinePopup = { bg = "NONE" } },
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
          progress = { enabled = false },
          hover = { enabled = false },
          signature = { auto_open = { enabled = true }, enabled = false },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        cmdline = {
          view = "cmdline_popup",
        },
        redirect = { view = "popup", filter = { event = "msg_show" } },
        views = {
          cmdline_popup = {
            position = {
              row = -2,
              col = "1%",
            },
          },
          cmdline_popupmenu = {
            position = {
              row = -5,
              col = "1%",
            },
          },
          popupmenu = {
            border = {},
            relative = "editor",
            position = {
              row = "55%",
              col = "50%",
            },
            size = {
              width = 60,
              height = 12, --you can set this to any height, even "auto", depending on your preference
            },
            win_options = {
              winblend = 0,
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "DiagnosticInfo",
              },
            },
          },
        },
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
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      }
    end,
  },
  -- FOLD CYCLE
  {
    "jghauser/fold-cycle.nvim",
    opts = true,
    keys = {
      {
        "tt",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold: cycle fold [fold-cycle]",
      },
    },
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
  -- BUFDELETE
  {
    "famiu/bufdelete.nvim",
    lazy = true,
  },
  -- BUFFERLINE
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
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
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    opts = function()
      local col_base_bg_attr = "bufferline_fill_bg"
      local col_base_fg_attr = "Comment"

      local buffer_selected_bg = "bufferline_selected_bg"
      local buffer_selected_fg = "Boolean"

      local col_sp_fg_attr = "ErrorMsg"

      local col_selected_fg_attr = "PmenuSel"
      local col_selected_bg_attr = "Directory"

      -- local col_selected_fg = Highlight.tint(Highlight.get("Boolean", "fg"), 2)
      local col_select_visible_fg = Highlight.tint(Highlight.get("Boolean", "fg"), 0.2)

      if RUtils.config.colorscheme == "catppuccin-latte" then
        -- col_selected_fg = Highlight.tint(Highlight.get("Boolean", "fg"), -0.1)
        col_select_visible_fg = Highlight.tint(Highlight.get("Boolean", "fg"), -0.2)
        col_selected_bg_attr = "PmenuSel"
        col_selected_fg_attr = "PmenuSel"
      end

      -- local col_selected_sp = "bufferline_unselected"

      local bufferline = require "bufferline"

      return {
        options = {
          mode = "tabs",
          buffer_close_icon = "󰒲",
          modified_icon = RUtils.config.icons.misc.boldclose,
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          separator_style = "slant", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },

          diagnostics_indicator = function(_, _, diag)
            local icons = RUtils.config.icons.diagnostics
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
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            sp = { attribute = "fg", highlight = col_sp_fg_attr },
            italic = true,
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
            fg = { attribute = "fg", highlight = "ErrorMsg" },
            bg = { attribute = "bg", highlight = col_base_bg_attr },
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
            fg = col_select_visible_fg,
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          duplicate_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
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
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          warning_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
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
            fg = { attribute = "fg", highlight = "DiagnosticError" },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          error_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
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
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
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
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
            bg = { attribute = "bg", highlight = buffer_selected_bg },
            italic = true,
          },
          info_selected = {
            fg = { attribute = "fg", highlight = col_selected_bg_attr },
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
}
