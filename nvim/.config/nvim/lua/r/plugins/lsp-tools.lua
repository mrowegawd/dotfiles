local fn, fmt, icons, api = vim.fn, string.format, as.ui.icons, vim.api

local highlight, ui = as.highlight, as.ui
local r_utils = require "r.utils"

local set_icons = function(icons_name)
  return icons_name .. " "
end

return {
  -- TROUBLE.NVIM (disabled)
  {
    "folke/trouble.nvim",
    enabled = false,
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      {
        "<Leader>tt",
        "<CMD>TroubleToggle<CR>",
        desc = "Trouble: toggle",
      },
    },
    config = function()
      require("trouble").setup {
        auto_open = false,
        use_diagnostic_signs = true, -- en
        action_keys = {
          -- map to {} to remove a mapping, for example:
          -- close = {},
          close = { "q", "<leader><Tab>" }, -- close the list
          cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r", -- manually refresh
          jump = "<tab>", -- jump to the diagnostic or open / close folds
          open_split = { "<c-s>" }, -- open buffer in new split
          open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
          open_tab = { "<c-t>" }, -- open buffer in new tab
          jump_close = { "o", "<cr>" }, -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "P", -- toggle auto_preview
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          close_folds = { "zM", "zm" }, -- close all folds
          open_folds = { "zR", "zr" }, -- open all folds
          toggle_fold = { "zA", "za" }, -- toggle fold of current file
          previous = "k", -- previous item
          next = "j", -- next item
        },
      }
    end,
  },
  -- NVIM-GTD
  {
    "hrsh7th/nvim-gtd",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "neovim/nvim-lspconfig",
    keys = {
      {
        "gD",
        function()
          require("gtd").exec { command = "split" }
        end,
        desc = "LSP(nvim-gtd): goo to definition or file",
      },
    },
    opts = {
      sources = {
        { name = "findup" },
        {
          name = "walk",
          root_markers = {
            ".git",
            ".neoconf.json",
            "Makefile",
            "package.json",
            "tsconfig.json",
          },
          ignore_patterns = { "/node_modules", "/.git" },
        },
        { name = "lsp" },
      },
    },
  },
  -- LSPSAGA (disabled)
  {
    "glepnir/lspsaga.nvim",
    cmd = "Lspsaga",
    enabled = false,
    init = function()
      highlight.plugin("LspsagaCustomHi", {
        { SagaBorder = { link = "Directory" } },
        { SagaTitle = { fg = "cyan" } },
        { SagaFileName = { link = "Directory" } },
        { SagaFolderName = { link = "Directory" } },
        -- { SagaNormal = { link = "Pmenu" } },
      })
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      local lspsaga = require "lspsaga"

      lspsaga.setup {
        ui = {
          border = "single",
          title = true,
          winblend = 0,
          expand = "",
          collapse = "",
          code_action = "💡",
          incoming = " ",
          outgoing = " ",
          actionfix = " ",
          hover = " ",
          theme = "arrow",
          lines = { "┗", "┣", "┃", "━" },
          kind = {},
        },
        diagnostic = {
          on_insert = false,
          insert_winblend = 0,
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          max_width = 0.7,
          max_height = 0.6,
          max_show_width = 0.9,
          max_show_height = 0.6,
          text_hl_follow = false,
          border_follow = true,
          extend_relatedInformation = false,
          keys = {
            exec_action = "o",
            quit = "q",
            expand_or_jump = "<CR>",
            quit_in_show = { "q", "<ESC>" },
          },
        },
        code_action = {
          num_shortcut = true,
          show_server_name = false,
          extend_gitsigns = false,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        lightbulb = {
          enable = false,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },
        preview = {
          lines_above = 0,
          lines_below = 10,
        },
        scroll_preview = {
          scroll_down = "<C-d>",
          scroll_up = "<C-u>",
        },
        request_timeout = 2000,
        finder = {
          max_height = 0.5,
          min_width = 30,
          force_max_height = false,
          keys = {
            jump_to = "o",
            edit = { "e", "<CR>" },
            vsplit = "<c-v>",
            split = "<c-s>",
            tabe = "<c-t>",
            quit = {
              "q",
              "<ESC>",
              "<leader><TAB>",
              "<c-l>",
              "<c-h>",
            },
            close_in_preview = "<ESC>",
          },
        },
        definition = {
          width = 0.6,
          height = 0.5,
          edit = "e",
          vsplit = "<C-v>",
          split = "<C-s>",
          tabe = "<C-t>",
          quit = "q",
        },
        rename = {
          quit = "<C-c>",
          exec = "<CR>",
          mark = "x",
          confirm = "<CR>",
          in_select = true,
        },
        symbol_in_winbar = {
          enable = false,
          ignore_patterns = {},
          separator = " ",
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
          respect_root = false,
          color_mode = true,
        },
        outline = {
          win_position = "right",
          win_with = "",
          win_width = 30,
          auto_preview = true,
          auto_refresh = true,
          auto_close = true,
          custom_sort = nil,
          preview_width = 0.4,
          close_after_jump = false,
          keys = {
            expand_or_jump = "o",
            quit = "q",
          },
        },
        callhierarchy = {
          show_detail = false,
          keys = {
            edit = "e",
            vsplit = "s",
            split = "i",
            tabe = "t",
            jump = "o",
            quit = "q",
            expand_collapse = "u",
          },
        },
        beacon = {
          enable = true,
          frequency = 7,
        },
        server_filetype_map = {},
      }
    end,
  },
  -- GLANCE (disabled)
  {
    "DNLHC/glance.nvim",
    cmd = { "Glance" },
    enabled = false,
    opts = function()
      local actions = require("glance").actions
      return {
        -- height = 18, -- Height of the window
        zindex = 100,
        preview_win_opts = { relativenumber = false, wrap = false },
        theme = { enable = true, mode = "darken" },
        folds = {
          fold_closed = "",
          fold_open = "",
          folded = true, -- Automatically fold list on startup
        },
        -- Taken from https://github.com/DNLHC/glance.nvim#hooks
        -- Don't open glance when there is only one result and it is
        -- located in the current buffer, open otherwise
        hooks = {
          ---@diagnostic disable-next-line: unused-local
          before_open = function(results, open, jump, method)
            local uri = vim.uri_from_bufnr(0)
            if #results == 1 then
              local target_uri = results[1].uri or results[1].targetUri

              if target_uri == uri then
                jump(results[1])
              else
                open(results)
              end
            else
              open(results)
            end
          end,
        },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["<c-v>"] = actions.jump_vsplit,
            ["<c-s>"] = actions.jump_split,
            ["<c-t>"] = actions.jump_tab,
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["h"] = actions.close_fold,
            ["l"] = actions.open_fold,
            ["p"] = actions.enter_win "preview",
            ["<C-l>"] = "",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
          preview = {
            ["q"] = actions.close,
            ["p"] = actions.enter_win "list",
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["C-l"] = "",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
        },
      }
    end,
  },
  -- AERIAL
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    enabled = false,
    init = function()
      r_utils.disable_ctrl_i_and_o("NoAerial", { "aerial" })

      api.nvim_create_autocmd("FileType", {
        pattern = { "aerial" },
        callback = function()
          vim.keymap.set("n", "zM", function()
            local aerial = require "aerial"
            return aerial.tree_close_all()
          end, {
            buffer = api.nvim_get_current_buf(),
          })
          vim.keymap.set("n", "zO", function()
            local aerial = require "aerial"
            return aerial.tree_open_all()
          end, {
            buffer = api.nvim_get_current_buf(),
          })
        end,
      })
    end,
    keys = function(opts)
      return {
        {
          "<Localleader>oa",
          function()
            -- r_utils.force_win_close({ "Outline" }, false)
            -- print(vim.inspect(opts.opts))
            -- require("aerial").setup(opts.opts)
            require("aerial").open { opts.opts }
          end,
          desc = "Open(aerial): focus toggle",
        },
        {
          "<Localleader>oA",
          function()
            local selected = r_utils.select({
              "Class",
              "Constructor",
              "Object",
              "Enum",
              "Function",
              "Interface",
              "Module",
              "Method",
              "Struct",
              "all",
            }, { prompt = icons.kind.Package .. " Filter LSPkind" }, {})

            r_utils.nui_select(selected, function(choice)
              if choice == "all" then
                opts.opts["filter_kind"] = false
              else
                opts.opts["filter_kind"] = { choice }
              end
              require("aerial").setup(opts.opts)

              r_utils.Buf_only()
              -- vim.schedule(function()
              --   vim.cmd [[:e]]
              -- end)
            end)
          end,
          desc = "Open(aerial): change filter_kind",
        },
      }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28 },
      -- fold code from tree (overwrites treesitter foldexpr)
      manage_folds = false,
      show_guides = true,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│",
      },
      whitespace = "  ",
      filter_kind = false,
      icons = {
        Array = icons.kind.Array,
        Boolean = icons.kind.Boolean,
        Class = icons.kind.Class,
        Constant = icons.kind.Constant,
        Constructor = icons.kind.Constructor,
        Enum = icons.kind.Enum,
        EnumMember = icons.kind.EnumMember,
        Event = icons.kind.Event,
        Field = icons.kind.Field,
        File = icons.kind.File,
        Function = icons.kind.Function,
        Interface = icons.kind.Interface,
        Key = icons.kind.Keyword,
        Method = icons.kind.Method,
        Module = icons.kind.Module,
        Namespace = icons.kind.Namespace,
        Null = icons.kind.Null,
        Number = icons.kind.Number,
        Object = icons.kind.Object,
        Operator = icons.kind.Operator,
        Package = icons.kind.Package,
        Property = icons.kind.Property,
        String = icons.kind.String,
        Struct = icons.kind.Struct,
        TypeParameter = icons.kind.TypeParameter,
        Variable = icons.kind.Variable,
        Collapsed = " ",
      },

      keymaps = {
        ["O"] = "actions.jump",
        -- ["o"] = "actions.jump",
        ["o"] = "actions.scroll",
        -- ["]y"] = "actions.next",
        -- ["[y"] = "actions.prev",
        -- ["<c-p>"] = "actions.prev_up",
        -- ["<c-n>"] = "actions.next_up",
        ["<c-n>"] = "actions.next",
        ["<c-p>"] = "actions.prev",
        ["zM"] = "actions.tree_close_all",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
        -- ["zM"] = false,
        ["zO"] = false,
      },
    },
  },
  -- SYMBOLSOUTLINE
  {
    "enddeadroyal/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    branch = "bugfix/symbol-hover-misplacement",
    init = function()
      r_utils.disable_ctrl_i_and_o("NoOutline", { "Outline" })
    end,
    -- stylua: ignore
    keys = { { "<Localleader>oa", "<cmd>SymbolsOutline<CR>", desc = "Open(symbolsoutline): pick", }, },
    config = function()
      require("symbols-outline").setup {
        highlight_hovered_item = true,
        show_guides = false,
        position = "right",
        border = "single",
        relative_width = true,
        width = 30,
        auto_close = false,
        auto_preview = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = "Pmenu",
        winblend = 0,
        autofold_depth = nil,
        auto_unfold_hover = false,
        fold_markers = { "", "" },
        wrap = false,
        keymaps = { -- These keymaps can be a string or a table for multiple keys
          close = { "<Esc>", "q", "<leader><TAB>" },
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          toggle_preview = "P",
          rename_symbol = "r",
          code_actions = "a",
          show_help = "?",
          fold = "h",
          unfold = "l",
          fold_all = "zM",
          unfold_all = "zO",
          fold_reset = "R",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
          Module = { icon = icons.kind.Module, hl = "@namespace" },
          Class = { icon = icons.kind.Class, hl = "@type" },
          Method = { icon = icons.kind.Method, hl = "@method" },
          Property = { icon = icons.kind.Property, hl = "@method" },
          Field = { icon = icons.kind.Field, hl = "@field" },
          Constructor = { icon = icons.kind.Constructor, hl = "@constructor" },
          Enum = { icon = icons.kind.Enum, hl = "@type" },
          Interface = { icon = icons.kind.Interface, hl = "@type" },
          Function = { icon = icons.kind.Function, hl = "@function" },
          Variable = { icon = icons.kind.Variable, hl = "@constant" },
          Constant = { icon = icons.kind.Constant, hl = "@constant" },
          String = { icon = icons.kind.String, hl = "@string" },
          Number = { icon = icons.kind.Number, hl = "@number" },
          Boolean = { icon = icons.kind.Boolean, hl = "@boolean" },
          Array = { icon = icons.kind.Array, hl = "@constant" },
          Object = { icon = icons.kind.Object, hl = "@type" },
          Key = { icon = icons.kind.Keyword, hl = "@type" },
          EnumMember = { icon = icons.kind.EnumMember, hl = "@field" },
          Struct = { icon = icons.kind.Struct, hl = "@type" },
          Event = { icon = icons.kind.Event, hl = "@type" },
          Operator = { icon = icons.kind.Operator, hl = "@operator" },
          Null = { icon = icons.kind.Null, hl = "@type" },
          File = { icon = icons.kind.File, hl = "@text.uri" },
          Namespace = { icon = icons.kind.Namespace, hl = "@namespace" },
          Package = { icon = icons.kind.Package, hl = "@namespace" },
          TypeParameter = { icon = icons.kind.TypeParameter, hl = "@parameter" },
          Component = { icon = icons.kind.Component, hl = "@function" },
          Fragment = { icon = icons.kind.Fragment, hl = "@constant" },
        },
      }
    end,
  },
  -- DROPBAR
  {
    "Bekaboo/dropbar.nvim",
    event = "BufRead",
    -- stylua: ignore
    keys = { { "<Localleader>od", function() return require("dropbar.api").pick() end, desc = "Open(dropbar): pick" } },
    init = function()
      highlight.plugin("DropBar", {
        { DropBarIconUISeparator = { link = "Delimiter" } },
        { DropBarMenuNormalFloat = { inherit = "Pmenu" } },
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dropbar").setup {
        general = {
          update_interval = 100,
          enable = function(buf, win)
            local b, w = vim.bo[buf], vim.wo[win]
            local decor = ui.decorations.get { ft = b.ft, bt = b.bt, setting = "winbar" }
            return decor ~= nil
              and decor.ft ~= false
              and decor.bt ~= false
              and b.bt == ""
              and not w.diff
              and not api.nvim_win_get_config(win).zindex
              and api.nvim_buf_get_name(buf) ~= ""
          end,
        },
        icons = {
          kinds = {
            use_devicons = true,
            symbols = {
              Array = set_icons(icons.kind.Array),
              Boolean = set_icons(icons.kind.Boolean),
              BreakStatement = "󰙧 ",
              Call = "󰃷 ",
              CaseStatement = "󱃙 ",
              Class = set_icons(icons.kind.Class),
              Color = " ",
              Constant = set_icons(icons.kind.Constant),
              Constructor = set_icons(icons.kind.Constructor),
              ContinueStatement = "→ ",
              Copilot = " ",
              Declaration = "󰙠 ",
              Delete = "󰩺 ",
              DoStatement = "󰑖 ",
              Enum = set_icons(icons.kind.Enum),
              EnumMember = set_icons(icons.kind.Enum),
              Event = set_icons(icons.kind.Event),
              Field = set_icons(icons.kind.Field),
              File = set_icons(icons.kind.File),
              Folder = set_icons(icons.kind.Folder),
              ForStatement = "󰑖 ",
              Function = set_icons(icons.kind.Function),
              Identifier = "󰀫 ",
              IfStatement = "󰇉 ",
              Interface = set_icons(icons.kind.Interface),
              Keyword = set_icons(icons.kind.Keyword),
              List = " ",
              og = "󰦪 ",
              Lsp = " ",
              Macro = "󰁌 ",
              MarkdownH1 = "󰉫 ",
              MarkdownH2 = "󰉬 ",
              MarkdownH3 = "󰉭 ",
              MarkdownH4 = "󰉮 ",
              MarkdownH5 = "󰉯 ",
              MarkdownH6 = "󰉰 ",
              Method = set_icons(icons.kind.Method),
              Module = set_icons(icons.kind.Module),
              Namespace = set_icons(icons.kind.Namespace),
              Null = set_icons(icons.kind.Null),
              Number = set_icons(icons.kind.Number),
              Object = set_icons(icons.kind.Object),
              Operator = set_icons(icons.kind.Operator),
              Package = set_icons(icons.kind.Package),
              Property = set_icons(icons.kind.Property),
              Reference = set_icons(icons.kind.Reference),
              Regex = " ",
              Repeat = "󰑖 ",
              Scope = " ",
              Snippet = "󰩫 ",
              Specifier = "󰦪 ",
              Statement = " ",
              String = set_icons(icons.kind.String),
              Struct = set_icons(icons.kind.Struct),
              SwitchStatement = "󰺟 ",
              Text = set_icons(icons.kind.Text),
              Type = " ",
              TypeParameter = " ",
              Unit = set_icons(icons.kind.Unit),
              Value = set_icons(icons.kind.Value),
              Variable = set_icons(icons.kind.Variable),
              WhileStatement = "󰑖 ",
            },
          },
          ui = {
            bar = {
              separator = set_icons(icons.kind.arrow_right),
              extends = "…",
            },
            menu = {
              separator = " ",
              indicator = " ",
            },
          },
        },
        bar = {
          sources = function(_, _)
            local sources = require "dropbar.sources"
            return {
              sources.path,
            }
          end,
          padding = {
            left = 1,
            right = 1,
          },
          pick = {
            pivots = "abcdefghijklmnopqrstuvwxyz",
          },
          truncate = true,
        },
        menu = {
          -- When on, preview the symbol under the cursor on CursorMoved
          preview = true,
          -- When on, automatically set the cursor to the closest previous/next
          -- clickable component in the direction of cursor movement on CursorMoved
          quick_navigation = true,
          win_configs = {
            border = "shadow",
            col = function(menu)
              return menu.prev_menu and menu.prev_menu._win_configs.width + 1 or 0
            end,
          },
          entry = {
            padding = {
              left = 1,
              right = 1,
            },
          },
          ---@type table<string, string|function|table<string, string|function>>
          keymaps = {
            ["<LeftMouse>"] = function()
              local dropbar_api = require "dropbar.api"
              local menu = dropbar_api.get_current_dropbar_menu()
              if not menu then
                return
              end
              local mouse = vim.fn.getmousepos()
              if mouse ~= nil and mouse.winid ~= menu.win then
                local parent_menu = dropbar_api.get_dropbar_menu(mouse.winid)
                if parent_menu and parent_menu.sub_menu then
                  parent_menu.sub_menu:close()
                end
                if dropbar_api.nvim_win_is_valid(mouse.winid) then
                  dropbar_api.nvim_set_current_win(mouse.winid)
                end
                return
              end
              if mouse ~= nil then
                menu:click_at({ mouse.line, mouse.column }, nil, 1, "l")
              end
            end,
            ["<CR>"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end
              local cursor = api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["<c-c>"] = function()
              local dropbar_api = require "dropbar.api"
              local menu = dropbar_api.get_current_dropbar_menu()
              if not menu then
                return
              end
              vim.cmd "q"
            end,
            ["<esc>"] = function()
              local dropbar_api = require "dropbar.api"
              local menu = dropbar_api.get_current_dropbar_menu()
              if not menu then
                return
              end
              vim.cmd "q"
            end,
            ["l"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end
              local cursor = api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                vim.cmd "silent noautocmd update"
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["h"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end
              vim.cmd "q"
            end,
            ["P"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end

              -- vim.notify "not yet implemented"

              local cursor = api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component ~= nil then
                local row = component.entry.idx
                local col = component.entry.padding.left + 1

                col = col + component:bytewidth() + component.entry.separator:bytewidth()

                print(tostring(row) .. " " .. tostring(col))
                print(vim.inspect(component))
              end
            end,
          },
        },
      }
    end,
  },
  -- INCRENAME (disabled)
  {
    "smjonas/inc-rename.nvim",
    enabled = false,
    opts = { hl_group = "Visual", preview_empty_name = true },
    keys = {
      {
        "<leader>gR",
        function()
          return fmt(":IncRename %s", fn.expand "<cword>")
        end,
        expr = true,
        silent = false,
        desc = "lsp: incremental rename",
      },
    },
  },
  -- ILLUMINATE
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
    -- stylua: ignore
    keys = {
      { "<a-q>", function() require("illuminate").goto_next_reference(nil) end, desc = "LSP(vim-illuminate): go next reference", },
      { "<a-Q>", function() require("illuminate").goto_prev_reference(nil) end, desc = "LSP(vim-illuminate): go prev reference", },
    },
    config = function()
      require("illuminate").configure {
        filetypes_denylist = {
          "NeogitStatus",
          "Outline",
          "TelescopePrompt",
          "Trouble",
          "alpha",
          "dirvish",
          "fugitive",
          "gitcommit",
          "lazy",
          "neo-tree",
          "orgagenda",
          "aerial",
          "outline",
          "sagafinder",
          "qf",
        },
      }
    end,
  },
  -- NEOGEN
  {
    "danymat/neogen",
    cmd = "Neogen",
    opts = {
      snippet_engine = "luasnip",
    },
  },
  -- NVIM-DEVDOCS
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    keys = {
      { "<Leader>fd", "<CMD>DevdocsOpen<CR>", desc = "Misc(devdocs): open" },
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
  },
  -- HLARGS (disabled)
  {
    "m-demare/hlargs.nvim",
    enabled = false,
    event = "VeryLazy", --  "UIEnter"
    opts = {
      color = "#ef9062",
      use_colorpalette = true,
      colorpalette = {
        { fg = "#ef9062" },
        { fg = "#3AC6BE" },
        { fg = "#35D27F" },
        { fg = "#EB75D6" },
        { fg = "#E5D180" },
        { fg = "#8997F5" },
        { fg = "#D49DA5" },
        { fg = "#7FEC35" },
        { fg = "#F6B223" },
        { fg = "#F67C1B" },
        { fg = "#DE9A4E" },
        { fg = "#BBEA87" },
        { fg = "#EEF06D" },
        { fg = "#8FB272" },
      },
    },
  },
}
