local Util = require "r.utils"

return {
  -- NOUGAT
  {
    "MunifTanjim/nougat.nvim",
    event = "LazyFile",
    enabled = false,
    config = function()
      local highlight = require "r.config.highlights"

      local nougat = require "nougat"

      local core = require "nougat.core"
      local Bar = require "nougat.bar"
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
        base_fg = highlight.tint(highlight.get("Normal", "fg"), -0.1) or "#1d2021",
        base_bg = highlight.tint(highlight.get("Normal", "bg"), 0) or "#1d2021",

        base_fg_2 = highlight.tint(highlight.get("LineNr", "fg"), 5) or "#1d2021",

        base_bg_1 = highlight.tint(highlight.get("Normal", "bg"), 0.2) or "#1d2021",
        base_bg_2 = highlight.tint(highlight.get("Normal", "bg"), 0.4) or "#1d2021",
        base_bg_3 = highlight.tint(highlight.get("Normal", "bg"), 0.6) or "#1d2021",
        base_bg_4 = highlight.tint(highlight.get("Normal", "bg"), 0.8) or "#1d2021",

        base_fg_tabline = highlight.tint(highlight.get("Normal", "bg"), 2) or "#1d2021",
        base_bg_tabline = highlight.get("Normal", "bg") or "#1d2021",

        bg = highlight.get("Normal", "bg") or "#1d2021",

        red = "#fb4934",
        green = "#b8bb26",
        yellow = "#fabd2f",

        purple = highlight.tint(highlight.get("@field", "fg"), 0.2) or "#d3869b",
        visual = highlight.tint(highlight.get("Visual", "bg"), 0.8) or "#d3869b",

        insert_bg = highlight.tint(highlight.get("Error", "fg"), -0.1) or "#b8bb26",

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

      -- local mode = nut.mode {
      --   prefix = " ",
      --   suffix = " ",
      --   sep_right = sep.right_lower_triangle_solid(true),
      --   config = {
      --     highlight = {
      --       normal = {
      --         -- bg = color.base_bg,
      --         fg = color.base_fg,
      --       },
      --       visual = {
      --         bg = color.visual,
      --         fg = color.base_fg,
      --       },
      --       insert = {
      --         bg = color.insert_bg,
      --         fg = color.bg,
      --       },
      --       replace = {
      --         bg = color.purple,
      --         fg = color.bg,
      --       },
      --       commandline = {
      --         bg = color.green,
      --         fg = color.bg,
      --       },
      --       terminal = {
      --         bg = color.accent.green,
      --         fg = color.bg,
      --       },
      --       inactive = {},
      --     },
      --   },
      -- }

      local stl = Bar "statusline"
      -- stl:add_item(mode)
      stl:add_item(nut.git.branch {
        hl = { bg = color.base_bg_3, fg = color.base_fg, bold = true },
        prefix = "  ",
        suffix = " ",
        sep_right = sep.right_lower_triangle_solid(true),
      })
      stl:add_item(nut.git.status.create {
        hl = { bg = color.base_bg_4 },
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
        sep_right = sep.right_lower_triangle_solid(true),
      })
      stl:add_item {
        content = function()
          local basename = vim.fn.fnamemodify(vim.fn.expand "%:h", ":p:~:.")
          if basename == "" or basename == "." then
            return ""
          else
            return basename:gsub("/$", "")
          end
        end,
        hl = { fg = color.base_fg, bold = false },
        prefix = " ",
        -- suffix = " ",
      }
      stl:add_item {
        content = function()
          local filename = vim.fn.expand "%:p:t"
          if #filename > 0 then
            return "/" .. filename
          end
        end,
        hl = { fg = color.base_fg_2, bold = true },
        suffix = " ",
      }
      stl:add_item(nut.buf.filestatus {
        hl = { fg = color.base_fg },
        suffix = " ",
        sep_right = sep.right_lower_triangle_solid(true),
        config = {
          modified = "",
          nomodifiable = "",
          readonly = "",
          sep = " ",
        },
      })
      stl:add_item(nut.spacer())
      stl:add_item {
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

          local language_servers = string.format("%s", client_names_str)

          return language_servers
        end,
        hl = { fg = color.base_fg },
        suffix = " ",
        prefix = " LSP(s): ",
        -- sep_right = sep.right_chevron_solid(true),
      }
      -- stl:add_item(nut.truncation_point())
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.red, fg = color.base_bg },
        sep_left = sep.left_lower_triangle_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.ERROR,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.yellow, fg = color.base_bg },
        sep_left = sep.left_lower_triangle_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.WARN,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = "fg", fg = color.base_fg },
        sep_left = sep.left_lower_triangle_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.INFO,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hl = { bg = color.green, fg = color.bg },
        sep_left = sep.left_lower_triangle_solid(true),
        prefix = " ",
        suffix = " ",
        config = {
          severity = vim.diagnostic.severity.HINT,
        },
      })
      -- stl:add_item(nut.git.branch {
      --   hl = { bg = color.base_bg_3, fg = color.base_fg, bold = true },
      --   prefix = "  ",
      --   suffix = " ",
      --   sep_right = sep.left_lower_triangle_solid(true),
      --   sep_left = sep.left_lower_triangle_solid(true),
      -- })
      -- stl:add_item(nut.git.status.create {
      --   hl = { bg = color.base_bg_4 },
      --   content = {
      --     nut.git.status.count("added", {
      --       hl = { fg = color.green },
      --       prefix = " +",
      --     }),
      --     nut.git.status.count("changed", {
      --       hl = { fg = color.yellow },
      --       prefix = " ~",
      --     }),
      --     nut.git.status.count("removed", {
      --       hl = { fg = color.red },
      --       prefix = " -",
      --     }),
      --   },
      --   suffix = " ",
      --   prefix = "",
      --   sep_right = sep.left_lower_triangle_solid(true),
      --   -- sep_left = sep.left_lower_triangle_solid(true),
      -- })
      stl:add_item(nut.buf.filetype {
        hl = { bg = color.base_bg_3, fg = color.base_fg },
        -- sep_right = sep.left_lower_triangle_solid(true),
        sep_left = sep.left_lower_triangle_solid(true),
        prefix = " ",
        suffix = " ",
      })
      stl:add_item(Item {
        hl = { bg = color.base_bg_2, fg = color.base_fg },
        content = core.group {
          core.code "l",
          ":",
          core.code "c",
        },
        sep_left = sep.left_lower_triangle_solid(true),
        prefix = "  ",
        suffix = " ",
      })
      stl:add_item(Item {
        hl = { bg = color.base_bg, fg = color.base_fg },
        sep_left = sep.left_lower_triangle_solid(true),
        content = core.code "P",
        prefix = " ",
        suffix = " ",
      })

      local stl_inactive = Bar "statusline"
      -- stl_inactive:add_item(mode)
      -- stl_inactive:add_item {
      --   content = function()
      --     local filename = vim.fn.expand "%:p:t"
      --     if #filename > 0 then
      --       return " " .. filename
      --     end
      --   end,
      --   hl = { fg = color.base_fg_2, bold = true, bg = color.base_bg_3 },
      --   suffix = " ",
      -- }
      stl_inactive:add_item(nut.spacer())

      -- stl_inactive:add_item(filename)
      -- stl_inactive:add_item(filename2)
      -- stl_inactive:add_item(filename3)
      -- stl_inactive:add_item(filestatus)
      -- stl_inactive:add_item(nut.spacer())
      -- stl_inactive:add_item(lsp_notify)

      nougat.set_statusline(function(ctx)
        return ctx.is_focused and stl or stl_inactive
      end)

      local tal = Bar "tabline"

      tal:add_item(nut.tab.tablist.tabs {
        active_tab = {
          -- hl = { bg = color.bg0_h, fg = color.blue },
          hl = { bg = color.base_bg_4, fg = color.base_fg_2, bold = true },
          prefix = " ",
          suffix = " ",
          content = {
            nut.tab.tablist.icon { suffix = " " },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = " ", config = { text = "●" } },
            nut.tab.tablist.close { prefix = " ", config = { text = "󰅖" } },
          },
          sep_right = sep.right_lower_triangle_solid(true),
        },
        inactive_tab = {
          hl = { bg = color.base_bg_tabline, fg = color.base_fg_tabline, bold = true },
          prefix = " ",
          suffix = " ",
          content = {
            nut.tab.tablist.icon { suffix = " " },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = " ", config = { text = "●" } },
            nut.tab.tablist.close { prefix = " ", config = { text = "󰅖" } },
          },
          sep_right = { " " },
        },
      })

      nougat.set_tabline(tal)
    end,
  },
  -- HEIRLINE
  {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LazyFile",
    config = function()
      local comp = require "r.plugins.colorthemes.heirline.components"
      require("heirline").setup {
        statusline = {
          comp.Mode,
          -- comp.Branch,
          comp.Git,
          comp.FilePath,
          comp.FileIcon,
          comp.FileFlags,
          { provider = "%=" },
          comp.LSPActive,
          comp.Diagnostics,
          comp.SearchCount,
          comp.Sessions,
          comp.BufferCwd,
          comp.Ruler,
        },
      }

      local group = vim.api.nvim_create_augroup("Heirline", { clear = true })
      -- vim.cmd [[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function()
          local bh = vim.bo.bufhidden
          if bh == "wipe" or bh == "delete" then
            vim.bo.buflisted = false
          end
        end,
      })
    end,
  },
}
