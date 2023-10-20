return {
  -- STTUSLINE
  {
    "sontungexpt/sttusline",
    event = "VeryLazy",
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
          component.diagnostics(),
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
