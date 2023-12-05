local Util = require "r.utils"

return {
  -- NOUGAT
  {
    "MunifTanjim/nougat.nvim",
    event = "LazyFile",
    config = function()
      local highlight = require "r.config.highlights"

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
        bg = highlight.get("Normal", "bg") or "#1d2021",
        bg0_h = "#1d2021",
        bg0 = "#282828",
        bg0_s = "#32302f",
        bg1 = highlight.tint(highlight.get("@field", "fg"), -0.7) or "#3c3836",
        bg2 = highlight.tint(highlight.get("@attribute", "fg"), -0.25) or "#504945",
        bg3 = highlight.tint(highlight.get("ColorColumn", "bg"), 0.8) or "#665c54",
        bg4 = "#7c6f64",

        bg5 = highlight.tint(highlight.get("ColorColumn", "bg"), 0.2) or "#665c54",
        bg5_ft = highlight.tint(highlight.get("ColorColumn", "bg"), -0.2) or "#665c54",

        gray = "#928374",

        fg = highlight.tint(highlight.get("ColorColumn", "bg"), -0.4) or "#665c54",

        fg0 = "#fbf1c7",
        fg1 = "#ebdbb2",
        fg2 = "#d5c4a1",
        fg3 = "#bdae93",
        fg4 = "#a89984",

        lightgray = "#a89984",

        red = "#fb4934",
        green = "#b8bb26",
        yellow = "#fabd2f",
        blue = highlight.tint(highlight.get("@attribute", "fg"), -0.8) or "#83a598",

        purple = highlight.tint(highlight.get("@field", "fg"), 0.2) or "#d3869b",
        aqua = "#8ec07c",
        orange = "#f38019",
        visual = highlight.tint(highlight.get("Visual", "bg"), 0.8) or "#d3869b",

        ft_bg = highlight.tint(highlight.get("ColorColumn", "bg"), 0.5) or "#d3869b",
        insert_bg = highlight.tint(highlight.get("Error", "fg"), -0.1) or "#b8bb26",

        sectionlast_bg = highlight.tint(highlight.get("Function", "fg"), -0.1) or "#b8bb26",
        sectionlineNum_bg = highlight.tint(highlight.get("@field", "fg"), -0.1) or "#b8bb26",
        sectionFiletype_bg = highlight.tint(highlight.get("ColorColumn", "bg"), 0.8) or "#b8bb26",
        sectionFilename_bg = highlight.tint(highlight.get("ColorColumn", "bg"), 0.7) or "#b8bb26",
        sectionGitstatus_bg = highlight.tint(highlight.get("ColorColumn", "bg"), 0.2) or "#b8bb26",

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
              bg = color.visual,
              fg = color.bg,
            },
            insert = {
              bg = color.insert_bg,
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
        hl = { bg = color.sectionGitstatus_bg },
        content = {
          nut.git.status.count("added", {
            hl = { fg = color.green },
            prefix = " +",
          }),
          nut.git.status.count("changed", {
            hl = { fg = color.yellow },
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
      -- local filename = stl:add_item(nut.buf.filename {
      --   hl = { bg = color.sectionFilename_bg, fg = color.bg, bold = true },
      --   prefix = " ",
      --   suffix = " ",
      -- })
      local filename2 = stl:add_item {
        content = function()
          local basename = vim.fn.fnamemodify(vim.fn.expand "%:h", ":p:~:.")
          if basename == "" or basename == "." then
            return ""
          else
            return basename:gsub("/$", "") .. "/"
          end
        end,
        hl = { bg = color.sectionFilename_bg, fg = color.bg, bold = false },
        prefix = " ",
        -- suffix = " ",
      }
      local filename3 = stl:add_item {
        content = function()
          return vim.fn.expand "%:p:t"
        end,
        hl = { bg = color.sectionFilename_bg, fg = color.purple, bold = true },
        suffix = " ",
      }
      local filestatus = stl:add_item(nut.buf.filestatus {
        hl = { bg = color.sectionFilename_bg, fg = color.bg },
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
      local lsp_notify = stl:add_item {
        hidden = function()
          return vim.fn.winwidth(0) < 120
        end,
        content = function()
          local clients = vim.lsp.get_active_clients { bufnr = 0 }

          if Util.cmd.falsy(clients) then
            return { "No LSP clients available" }
          end

          local buf_ft = vim.bo.filetype
          local buf_client_names = {}

          local lint_s, lint = pcall(require, "lint")
          if lint_s then
            for ft_k, ft_v in pairs(lint.linters_by_ft) do
              if type(ft_v) == "table" then
                for _, linter in ipairs(ft_v) do
                  if buf_ft == ft_k then
                    table.insert(buf_client_names, linter)
                  end
                end
              elseif type(ft_v) == "string" then
                if buf_ft == ft_k then
                  table.insert(buf_client_names, ft_v)
                end
              end
            end
          end
          -- This needs to be a string only table so we can use concat below
          local unique_client_names = {}
          for _, client_name_target in ipairs(buf_client_names) do
            local is_duplicate = false
            for _, client_name_compare in ipairs(unique_client_names) do
              if client_name_target == client_name_compare then
                is_duplicate = true
              end
            end
            if not is_duplicate then
              table.insert(unique_client_names, client_name_target)
            end
          end

          for _, server in pairs(clients) do
            table.insert(unique_client_names, server.name)
          end

          local client_names_str = table.concat(unique_client_names, ", ")

          local language_servers = string.format("[%s]", client_names_str)

          return language_servers
        end,
        hl = { fg = color.bg4 },
        suffix = " ",
        prefix = " LSP(s): ",
        -- sep_right = sep.right_chevron_solid(true),
      }
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
        hl = { bg = "fg", fg = color.bg },
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
        hl = { bg = color.sectionFiletype_bg, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        suffix = " ",
      })
      stl:add_item(Item {
        hl = { bg = color.sectionlineNum_bg, fg = color.fg },
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
        hl = { bg = color.sectionlast_bg, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = " ",
        content = core.code "P",
        suffix = " ",
      })

      local stl_inactive = Bar "statusline"
      stl_inactive:add_item(mode)
      -- stl_inactive:add_item(filename)
      stl_inactive:add_item(filename2)
      stl_inactive:add_item(filename3)
      stl_inactive:add_item(filestatus)
      stl_inactive:add_item(nut.spacer())
      stl_inactive:add_item(lsp_notify)

      bar_util.set_statusline(function(ctx)
        return ctx.is_focused and stl or stl_inactive
      end)

      local tal = Bar "tabline"

      tal:add_item(nut.tab.tablist.tabs {
        active_tab = {
          -- hl = { bg = color.bg0_h, fg = color.blue },
          hl = { bg = color.bg3, fg = color.bg },
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
          hl = { bg = color.bg5, fg = color.bg5_ft },
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
}
