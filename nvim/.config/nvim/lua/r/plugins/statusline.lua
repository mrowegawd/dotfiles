return {
  -- NOUGAT
  {
    "MunifTanjim/nougat.nvim",
    event = "BufEnter",
    config = function()
      local core = require "nougat.core"
      local Bar = require "nougat.bar"
      local bar_util = require "nougat.bar.util"
      local Item = require "nougat.item"
      local sep = require "nougat.separator"

      local nut = {
        buf = {
          diagnostic_count = require("nougat.nut.buf.diagnostic_count").create,
          filename = require("nougat.nut.buf.filename").create,
          filestatus = require("nougat.nut.buf.filestatus").create,
          filetype = require("nougat.nut.buf.filetype").create,
        },
        git = {
          branch = require("nougat.nut.git.branch").create,
          status = require "nougat.nut.git.status",
        },
        tab = {
          tablist = {
            tabs = require("nougat.nut.tab.tablist").create,
            close = require("nougat.nut.tab.tablist.close").create,
            icon = require("nougat.nut.tab.tablist.icon").create,
            label = require("nougat.nut.tab.tablist.label").create,
            modified = require("nougat.nut.tab.tablist.modified").create,
          },
        },
        mode = require("nougat.nut.mode").create,
        spacer = require("nougat.nut.spacer").create,
        truncation_point = require("nougat.nut.truncation_point").create,
      }

      local color = {
        bg = "#1d2021",
        bg0_h = "#1d2021",
        bg0 = "#282828",
        bg0_s = "#32302f",
        bg1 = "#3c3836",
        bg2 = "#504945",
        bg3 = "#665c54",
        bg4 = "#7c6f64",

        gray = "#928374",

        fg = "#ebdbb2",
        fg0 = "#fbf1c7",
        fg1 = "#ebdbb2",
        fg2 = "#d5c4a1",
        fg3 = "#bdae93",
        fg4 = "#a89984",

        lightgray = "#a89984",

        red = "#fb4934",
        green = "#b8bb26",
        yellow = "#fabd2f",
        blue = "#83a598",
        purple = "#d3869b",
        aqua = "#8ec07c",
        orange = "#f38019",

        accent = {
          red = "#cc241d",
          green = "#98971a",
          yellow = "#d79921",
          blue = "#458588",
          purple = "#b16286",
          aqua = "#689d6a",
          orange = "#d65d0e",
        },
      }

      local mode = nut.mode {
        prefix = " ",
        suffix = " ",
        sep_right = sep.right_chevron_solid(true),
        config = {
          highlight = {
            normal = {
              bg = "fg",
              fg = color.bg,
            },
            visual = {
              bg = color.orange,
              fg = color.bg,
            },
            insert = {
              bg = color.blue,
              fg = color.bg,
            },
            replace = {
              bg = color.purple,
              fg = color.bg,
            },
            commandline = {
              bg = color.green,
              fg = color.bg,
            },
            terminal = {
              bg = color.accent.green,
              fg = color.bg,
            },
            inactive = {},
          },
        },
      }

      local stl = Bar "statusline"
      stl:add_item(mode)
      stl:add_item(nut.git.branch {
        hl = { bg = color.purple, fg = color.bg },
        prefix = "  ",
        suffix = " ",
        sep_right = sep.right_chevron_solid(true),
      })
      stl:add_item(nut.git.status.create {
        hl = { bg = color.bg1 },
        content = {
          nut.git.status.count("added", {
            hl = { fg = color.green },
            prefix = " +",
          }),
          nut.git.status.count("changed", {
            hl = { fg = color.blue },
            prefix = " ~",
          }),
          nut.git.status.count("removed", {
            hl = { fg = color.red },
            prefix = " -",
          }),
        },
        suffix = " ",
        sep_right = sep.right_chevron_solid(true),
      })
      local filename = stl:add_item(nut.buf.filename {
        hl = { bg = color.bg3 },
        prefix = " ",
        suffix = " ",
      })
      local filestatus = stl:add_item(nut.buf.filestatus {
        hl = { bg = color.bg3 },
        suffix = " ",
        sep_right = sep.right_chevron_solid(true),
        config = {
          modified = "",
          nomodifiable = "",
          readonly = "",
          sep = " ",
        },
      })
      stl:add_item(nut.spacer())
      stl:add_item(nut.truncation_point())
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.red, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.ERROR,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.yellow, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.WARN,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.blue, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.INFO,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hl = { bg = color.green, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.HINT,
        },
      })
      stl:add_item(nut.buf.filetype {
        hl = { bg = color.bg1 },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        suffix = " ",
      })
      stl:add_item(Item {
        hl = { bg = color.bg2, fg = color.blue },
        sep_left = sep.left_chevron_solid(true),
        prefix = "  ",
        content = core.group {
          core.code "l",
          ":",
          core.code "c",
        },
        suffix = " ",
      })
      stl:add_item(Item {
        hl = { bg = color.blue, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        content = core.code "P",
        suffix = " ",
      })

      local stl_inactive = Bar "statusline"
      stl_inactive:add_item(mode)
      stl_inactive:add_item(filename)
      stl_inactive:add_item(filestatus)
      stl_inactive:add_item(nut.spacer())

      bar_util.set_statusline(function(ctx)
        return ctx.is_focused and stl or stl_inactive
      end)

      local tal = Bar "tabline"

      tal:add_item(nut.tab.tablist.tabs {
        active_tab = {
          hl = { bg = color.bg0_h, fg = color.blue },
          prefix = " ",
          suffix = " ",
          content = {
            nut.tab.tablist.icon { suffix = " " },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = " ", config = { text = "●" } },
            nut.tab.tablist.close { prefix = " ", config = { text = "󰅖" } },
          },
          sep_right = sep.right_chevron_solid(true),
        },
        inactive_tab = {
          hl = { bg = color.bg2, fg = color.fg2 },
          prefix = " ",
          suffix = " ",
          content = {
            nut.tab.tablist.icon { suffix = " " },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = " ", config = { text = "●" } },
            nut.tab.tablist.close { prefix = " ", config = { text = "󰅖" } },
          },
          sep_right = sep.right_chevron_solid(true),
        },
      })

      bar_util.set_tabline(tal)
    end,
  },
  -- STTUSLINE
  {
    "sontungexpt/sttusline",
    enabled = false,
    event = "BufEnter",
    de1endencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local component = require "r.plugins.colorthemes.sttusline.components"
      return {
        -- 0 | 1 | 2 | 3
        -- recommended: 3
        laststatus = 3,
        disabled = {
          filetypes = {
            "alpha",
            "dashboard",
            -- "NvimTree",
            -- "lazy",
          },
          buftypes = {
            -- "terminal",
          },
        },
        components = {
          component.mode(),
          component.filename(),
          component.filereadonly(),
          component.branch(),
          component.gitdiff(),
          "%=",
          component.trailing(),
          component.mixindent(),
          "diagnostics",
          component.rootdir(),
          component.lsp_notify(),
          "copilot",
          "encoding",
          "pos-cursor",
          component.linecount(),
          "pos-cursor-progress",
          component.datetime(),
        },
      }
    end,
  },
  -- LUALINE
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local themes = require "r.plugins.colorthemes.lualine.themes"
      local component = require "r.plugins.colorthemes.lualine.components"
      return {
        options = {
          -- theme = "auto",
          theme = themes,

          -- Remove any separators icons
          component_separators = { left = "", right = "" }, -- "", "", "", "", "", ""
          section_separators = { left = "", right = "" },

          disabled_filetypes = {
            statusline = { "alpha", "lazy", "dashboard" },
            winbar = { "help", "alpha", "lazy", "dashboard" },
          },
        },
        sections = {
          lualine_a = { component.mode() },
          lualine_b = {},
          lualine_c = {
            component.filename(),
            component.file_modified(),
            component.branch(),
            component.diff(),
            component.debugger(),
          },
          lualine_x = {
            component.term_akinsho(),
            component.lazy_updates(),
            component.trailing(),
            component.mixindent(),
            component.diagnostics(),
            component.python_env(),
            component.cmp_source(),
            component.get_lsp_client_notify(),
            -- components.noice_status(),
            component.rmux(),
            component.check_loaded_buf(),
            component.overseer(),
            -- components.vmux()
            component.sessions(),
            component.root_dir(),
            component.filetype(),
            component.location_mod(),
            -- components.clock()
          },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "misc" },
      }
    end,
  },
  -- HEIRLINE (disabled)
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    enabled = false,
    priority = 500,
    config = function()
      -- Filetypes where certain elements of the statusline will not be shown
      local filetypes = {
        "^git.*",
        "fugitive",
        "alpha",
        "^neo--tree$",
        "^neotest--summary$",
        "^neo--tree--popup$",
        "^NvimTree$",
        "^toggleterm$",
      }

      -- Buftypes which should cause elements to be hidden
      local buftypes = {
        "nofile",
        "prompt",
        "help",
        "quickfix",
        "norg",
        "org",
      }

      -- Filetypes which force the statusline to be inactive
      local force_inactive_filetypes = {
        "^aerial$",
        "^alpha$",
        "^chatgpt$",
        "^DressingInput$",
        "^frecency$",
        "^lazy$",
        "^netrw$",
        "^oil$",
        "^TelescopePrompt$",
        "^undotree$",
      }

      local align = { provider = "%=" }
      local spacer = { provider = " " }

      local heirline = require "heirline"
      local conditions = require "heirline.conditions"

      -- local winbar =
      --     require(config_namespace .. ".plugins.heirline.winbar")
      -- local bufferline =
      --     require(config_namespace .. ".plugins.heirline.bufferline")
      local statusline = require "r.plugins.colorthemes.heirline.statusline"
      local statuscolumn = require "r.plugins.colorthemes.heirline.statuscol"

      heirline.setup {
        statusline = {
          static = {
            filetypes = filetypes,
            buftypes = buftypes,
            force_inactive_filetypes = force_inactive_filetypes,
          },
          condition = function(self)
            return not conditions.buffer_matches {
              filetype = self.force_inactive_filetypes,
            }
          end,
          statusline.VimMode,
          statusline.GitBranch,
          statusline.FileNameBlock,
          align,
          statusline.LspDiagnostics,
          statusline.Lazy,
          statusline.LspAttached,
          -- statusline.Overseer,
          -- statusline.Dap,
          -- statusline.FileEncoding,
          -- statusline.Session,
          -- statusline.MacroRecording,
          -- statusline.SearchResults,
          statusline.FileType,
          statusline.Ruler,
          -- statusline.Clock,
        },
        statuscolumn = {
          condition = function()
            -- TODO: Update this when 0.9 is released
            return not conditions.buffer_matches {
              buftype = buftypes,
              filetype = force_inactive_filetypes,
            }
          end,
          static = statuscolumn.static,
          init = statuscolumn.init,
          statuscolumn.signs,
          align,
          statuscolumn.line_numbers,
          spacer,
          statuscolumn.folds,
          statuscolumn.git_signs,
        },
      }
    end,
  },
}
