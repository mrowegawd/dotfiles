return {
  -- OVERLOOK.NVIM
  {
    "MadKuntilanak/overlook.nvim",
    branch = "feat/allow-customize-ui-adapter",
    opts = {
      ui = {
        size_ratio = 0.70,
        min_width = 40,
        min_height = 20,
      },
      adapters = {
        peek_fzflua = {
          get = function(selection)
            local path = RUtils.fzflua.__strip_str(selection[1])
            if not path then
              return
            end

            local lnum = 1
            local col = 1

            if path:match ":" then
              path = vim.split(path, ":")

              local str_path = path[1]
              local _lnum = tonumber(path[2])
              local _col = tonumber(path[3])

              path = str_path

              if _lnum then
                lnum = _lnum
              end

              if _col then
                col = _col
              end
            end

            if path:match "~" then
              path = path:gsub("~", "")
              path = RUtils.config.path.home .. path
            end

            local bufnr = vim.fn.bufadd(path)
            if not vim.api.nvim_buf_is_loaded(bufnr) then
              vim.fn.bufload(bufnr)
            end

            local opts = {
              target_bufnr = bufnr,
              lnum = lnum,
              col = col,
              title = path,

              win_col = 50,
              win_row = 5,

              win_width = 80,
              win_height = 25,
            }

            return opts
          end,
        },
        peek_qf = {
          get = function()
            local lnum = vim.api.nvim_win_get_cursor(0)[1]
            local is_loc = RUtils.qf.is_loclist()
            local qflist = RUtils.qf.get_list_qf(is_loc)
            local item = qflist.items[lnum]

            local opts = {}

            if item.bufnr then
              opts.target_bufnr = item.bufnr

              if item.text then
                if #item.text == 0 then
                  local path = vim.api.nvim_buf_get_name(item.bufnr)
                  opts.title = vim.fn.fnameescape(path)
                else
                  opts.title = item.text
                end
              end
            end

            if item.col then
              opts.col = item.col
            end

            if item.lnum then
              opts.lnum = item.lnum
            end

            opts.win_height = 20
            opts.win_width = 80

            opts.win_col = 1
            opts.win_row = -24

            return opts
          end,
        },
        peek_file_source = {
          get = function()
            if vim.bo.filetype ~= "orgagenda" then
              return
            end

            local item_headline

            local Orgmode = require "orgmode.api.agenda"

            ---@type any
            item_headline = Orgmode.get_headline_at_cursor()

            if not item_headline then
              return
            end

            local opts = {
              lnum = 0,
              col = 0,
            }

            local item_section = item_headline._section

            if item_section and item_section.file then
              local path = item_section.file.filename

              if path:match "~" then
                path = path:gsub("~", "")
                path = RUtils.config.path.home .. path
              end

              local bufnr = vim.fn.bufadd(path)
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.fn.bufload(bufnr)
              end

              opts.target_bufnr = bufnr
              opts.title = path

              opts.lnum = item_headline.position.start_line
              opts.col = item_headline.position.end_col
            end

            local columns = vim.api.nvim_get_option_value("columns", { scope = "global" })
            local win_width = math.ceil(columns / 2)

            local ui = vim.api.nvim_list_uis()[1]
            local col = math.floor((ui.width - win_width) / 2)

            opts.win_row = -10
            opts.win_col = col

            opts.win_width = 80
            opts.win_height = 30

            return opts
          end,
        },
      },
    },
    keys = {
      {
        "K",
        function()
          local P = require "overlook.peek"
          P.peek_qf()
        end,
        ft = "qf",
        desc = "Peek: peek on qf item [overlook]",
      },
      {
        "P",
        function()
          local P = require "overlook.peek"
          P.peek_qf()
        end,
        ft = "qf",
        desc = "Peek: peek on qf item (alternatif) [overlook]",
      },
      {
        "<Leader>cpp",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Peek: peek definition [overlook]",
      },
      {
        "<Leader>cpC",
        function()
          require("overlook.api").close_all()
        end,
        desc = "Peek: close all popup [overlook]",
      },
      {
        "<Leader>cpr",
        function()
          require("overlook.api").restore_popup()
        end,
        desc = "Peek: restore popup [overlook]",
      },
      {
        "<Leader>cpR",
        function()
          require("overlook.api").restore_all_popups()
        end,
        desc = "Peek: restore all popup [overlook]",
      },
      {
        "<Leader>cpv",
        function()
          require("overlook.api").open_in_vsplit()
        end,
        desc = "Peek: open in vsplit [overlook]",
      },
      {
        "<Leader>cps",
        function()
          require("overlook.api").open_in_split()
        end,
        desc = "Peek: open in split [overlook]",
      },
      {
        "<Leader>cpt",
        function()
          require("overlook.api").open_in_tab()
        end,
        desc = "Peek: open in tab [overlook]",
      },
      {
        "<Leader>cpw",
        function()
          require("overlook.api").switch_focus()
        end,
        desc = "Peek: switch focus [overlook]",
      },
      {
        "P",
        function()
          local P = require "overlook.peek"
          P.peek_file_source()
        end,
        ft = "orgagenda",
        desc = "Peek: note file [overlook]",
      },
    },
  },
  -- GOTO-PREVIEW (disabled)
  {
    "rmagatti/goto-preview",
    enabled = false,
    dependencies = { "rmagatti/logger.nvim" },
    event = "LspAttach",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  },
  -- INCRENAME
  {
    "smjonas/inc-rename.nvim",
    event = "LazyFile",
    opts = {
      show_message = false,
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancel
    },
  },
  -- INCRENAME KEYMAP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<Leader>cr",
              function()
                local inc_rename = require "inc_rename"
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
              end,
              expr = true,
              desc = "Action: rename [inc_rename]",
              has = "rename",
            },
          },
        },
      },
    },
  },
  -- SYMBOL-USAGE (disabled)
  {
    "MadKuntilanak/symbol-usage.nvim",
    -- dir = "~/.local/src/nvim_plugins/symbol-usage.nvim",
    branch = "depcreated",
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    enabled = false,
    keys = {
      {
        "<Leader>us",
        function()
          require("symbol-usage").refresh()
        end,
        desc = "Toggle: symbol usage refresh [symbol-usage]",
      },
    },
    opts = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("MyCodeUsage").bg, italic = true })
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageContent",
        { fg = h("MyCodeUsage").fg, bg = h("MyCodeUsage").bg, italic = true }
      )
      vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Normal").fg, bg = h("MyCodeUsage").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("MyCodeUsage").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("Normal").bg, bg = h("MyCodeUsage").bg, italic = true })

      -- vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
      -- vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
      -- vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
      -- vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
      -- vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

      local function text_format(symbol)
        local res = {}

        local round_start = { "", "SymbolUsageRounding" }
        local round_end = { "", "SymbolUsageRounding" }

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { "󰌹 ", "SymbolUsageRef" })
          table.insert(res, { string.format("%s %s", num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰳽 ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end
      return {
        hl = { link = "MyCodeUsage" },
        text_format = text_format,
        disable = {
          filetypes = { "dockerfile", "markdown", "org", "neorg" },
          cond = {
            function()
              if vim.wo.diff or vim.api.nvim_win_get_config(0).relative ~= "" then
                return true
              end
              return false
            end,
          },
        },
        ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn' `above` by default
        vt_position = "end_of_line",
      }
    end,
  },
  -- LENSLINE (disabled)
  {
    "oribarilan/lensline.nvim",
    enabled = false,
    event = "LspAttach",
    keys = {
      {
        "<Leader>l<C-l>",
        "<cmd>LenslineToggleView<CR>",
        desc = "LSP | Toggle Lens",
        silent = true,
      },
    },
    opts = {
      -- style = {
      --   prefix = "",
      --   placement = "inline",
      -- },
    },
  },
  -- KULALA (disabled)
  {
    "mistweaverco/kulala.nvim",
    enabled = false,
    ft = "http",
    --stylua: ignore
    keys = {
      { "<Leader>R", "", desc = "Kulala: rest", ft = "http" },
      { "<Leader>Rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Kulala: open scratchpad [kulala]", ft = "http" },
      { "<Leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Kulala: copy as cURL [kulala]", ft = "http" },
      { "<leader>RC", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Kulala: paste from curl [kulala]", ft = "http" },
      { "<leader>Re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Kulala: set environment [kulala]", ft = "http" },
      {
        "<Leader>Rg",
        "<cmd>lua require('kulala').download_graphql_schema()<cr>",
        desc = "Kulala: download GraphQL schema [kulala]",
        ft = "http",
      },

      { "<Leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Kulala: inspect current request [kulala]", ft = "http" },
      { "<Leader>Rq", "<cmd>lua require('kulala').close()<cr>", desc = "Kulala: close window [kulala]", ft = "http" },
      { "<Leader>RL", "<cmd>lua require('kulala').replay()<cr>", desc = "Kulala: replay the last request [kulala]", ft ="http" },
      { "<Leader>Rr", "<cmd>lua require('kulala').run()<cr>", desc = "Kulala: send the request [kulala]", ft = "http" },
      { "<Leader>RS", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Kulala: show stats [kulala]", ft = "http" },
      { "<Leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Kulala: toggle headers/body [kulala]", ft = "http" },
    },
  },
  -- TINY-INLINE-DIAGNOSTIC
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LazyFile",
    config = true,
  },
  -- TINY-CODE-ACTION
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {
      backend = "delta",
      picker = "fzf-lua",
      backend_opts = {
        delta = { header_lines_to_remove = 4 },
        difftastic = {
          header_lines_to_remove = 1,
          args = {
            "--color=always",
            "--display=inline",
            "--syntax-highlight=on",
          },
        },
        diffsofancy = {
          header_lines_to_remove = 4,
        },
      },
      signs = {
        quickfix = { "", { link = "DiagnosticWarn" } },
        others = { "", { link = "DiagnosticWarn" } },
        refactor = { "", { link = "DiagnosticInfo" } },
        ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
        ["refactor.extract"] = { "", { link = "DiagnosticError" } },
        ["source.organizeImports"] = { "", { link = "DiagnosticWarn" } },
        ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
        ["source"] = { "", { link = "DiagnosticError" } },
        ["rename"] = { "󰑕", { link = "DiagnosticWarn" } },
        ["codeAction"] = { "", { link = "DiagnosticWarn" } },
      },
    },
  },
  -- LOG SYNTAX-HIGHLIGHT
  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
  -- TASKWARRIOR SYNTAX
  {
    "framallo/taskwarrior.vim",
    ft = "taskrc",
  },
  -- GARBAGE-DAY (disabled)
  {
    "zeioth/garbage-day.nvim",
    enabled = false,
    event = "LspAttach",
    opts = {},
  },
  -- MEOWYARN
  {
    "retran/meow.yarn.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<Leader>chT",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "supertypes")
        end,
        desc = "LSP: check supertypes hierarchy",
      },
      {
        "<Leader>cht",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "subtypes")
        end,
        desc = "LSP: check subtype hierarchy",
      },
      {
        "<Leader>chH",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callers")
        end,
        desc = "LSP: check who-call-this-func hierarchy",
      },
      {
        "<Leader>chh",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callees")
        end,
        desc = "LSP: check what-call-from-this-func hierarchy",
      },
    },
    opts = {
      mappings = {
        jump = "<CR>",
        toggle = "<Tab>",
        expand = "<S-Right",
        expand_alt = "<Right>",
        collapse = "<S-Left>",
        collapse_alt = "<Left>",
        show_super_hierarchy = "H",
        show_sub_hierarchy = "J",
        quit = "q",
      },
      hierarchies = {
        type_hierarchy = {
          icons = {
            class = RUtils.config.icons.kinds.Class,
            struct = RUtils.config.icons.kinds.Struct,
            interface = RUtils.config.icons.kinds.Interface,
            default = "",
          },
        },
        call_hierarchy = {
          icons = {
            method = RUtils.config.icons.kinds.Method,
            func = RUtils.config.icons.kinds.Function,
            variable = RUtils.config.icons.kinds.Variable,
            default = "",
          },
        },
      },
    },
    config = function(_, opts)
      require("meow.yarn").setup(opts)
    end,
  },
}
