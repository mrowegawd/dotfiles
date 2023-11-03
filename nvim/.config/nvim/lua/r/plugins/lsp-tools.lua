local api = vim.api

local highlight = require "r.config.highlights"
local Util = require "r.utils"

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
    config = {
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
    },
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
    event = "LazyFile",
    init = function()
      Util.disable_ctrl_i_and_o("NoAerial", { "aerial" })

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
            local selected = Util.plugin.select({
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
            }, { prompt = require("r.config").icons.kinds.Package .. " Filter LSPkind" }, {})

            Util.plugin.nui_select(selected, function(choice)
              if choice == "all" then
                opts.opts["filter_kind"] = false
              else
                opts.opts["filter_kind"] = { choice }
              end

              require("aerial").setup(opts.opts)

              Util.buf._only()
            end)
          end,
          desc = "Open(aerial): change filter_kind",
        },
      }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local hg = require "r.config.highlights"
      hg.plugin("arials", {
        { ArialGuide = { fg = { from = "ColorColumn", attr = "bg", alter = -0.1 } } },
        { ArialGuide1 = { fg = { from = "ColorColumn", attr = "bg", alter = -0.1 } } },
      })

      return {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = { min_width = 28 },
        -- fold code from tree (overwrites treesitter foldexpr)
        manage_folds = false,
        show_guides = true,
        guides = {
          mid_item = "├╴",
          last_item = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
        whitespace = "  ",
        filter_kind = false,
        icons = require("r.config").icons.kinds,
        keymaps = {
          ["o"] = "actions.jump",
          -- ["o"] = "actions.jump",
          ["O"] = "actions.scroll",
          -- ["]y"] = "actions.next",
          -- ["[y"] = "actions.prev",
          -- ["<c-p>"] = "actions.prev_up",
          -- ["<c-n>"] = "actions.next_up",
          ["<a-n>"] = "actions.next",
          ["<a-p>"] = "actions.prev",
          -- ["zM"] = "actions.tree_close_all",
          ["{"] = false,
          ["}"] = false,
          ["[["] = false,
          ["]]"] = false,
          ["zM"] = false,
          ["zO"] = false,
        },
      }
    end,
  },
  -- SYMBOLSOUTLINE (disabled)
  {
    "simrat39/symbols-outline.nvim",
    enabled = false,
    cmd = "SymbolsOutline",
    init = function()
      Util.disable_ctrl_i_and_o("NoOutline", { "Outline" })
    end,
    -- stylua: ignore
    keys = { { "<Localleader>oa", "<cmd>SymbolsOutline<CR>", desc = "Open(symbolsoutline): pick", }, },
    opts = function()
      local Config = require "r.config"
      local defaults = require("symbols-outline.config").defaults
      local opts = {
        symbols = {},
        symbol_blacklist = {},
        keymaps = { -- These keymaps can be a string or a table for multiple keys
          close = { "<Esc>", "q", "<leader><TAB>" },
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "K",
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
      }

      for kind, symbol in pairs(defaults.symbols) do
        opts.symbols[kind] = {
          icon = Config.icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
        if not vim.tbl_contains(Config.kind_filter.default, kind) then
          table.insert(opts.symbol_blacklist, kind)
        end
      end
      return opts
    end,
  },
  -- DROPBAR
  {
    "Bekaboo/dropbar.nvim",
    event = "LazyFile",
    -- stylua: ignore
    keys = { { "<Localleader>od", function() return require("dropbar.api").pick() end, desc = "Open(dropbar): pick" } },
    init = function()
      highlight.plugin("DropBar", {
        { DropBarIconUISeparator = { bg = { from = "ColorColumn" } } },
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
            local decor = Util.uisec.decoration_get { ft = b.ft, bt = b.bt, setting = "winbar" }
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
            symbols = require("r.config").icons.kinds,
          },
          ui = {
            bar = {
              separator = set_icons(require("r.config").icons.misc.arrow_right),
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
  -- ILLUMINATE
  {
    "RRethy/vim-illuminate",
    event = "LazyFile",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    keys = {
      {
        "<a-q>",
        function()
          require("illuminate").goto_next_reference(nil)
        end,
        desc = "LSP(vim-illuminate): go next reference",
      },
      {
        "<a-Q>",
        function()
          require("illuminate").goto_prev_reference(nil)
        end,
        desc = "LSP(vim-illuminate): go prev reference",
      },
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
      { "<Localleader>fd", "<CMD>DevdocsOpen<CR>", desc = "Misc(devdocs): open" },
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
  -- LSP-TIMEOUT.NVIM
  {
    --  lsp-timeout [lsp garbage collector]
    --  https://github.com/hinell/lsp-timeout.nvim
    --  Stop inactive lsp servers until the buffer recover the focus.
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "LazyFile",
    init = function()
      vim.g["lsp-timeout-config"] = {
        stopTimeout = 1000 * 60 * 10, -- Stop unused lsp servers after 10 min.
        startTimeout = 2000, -- Force server restart if nvim can't in 2s.
        silent = true, -- Notifications disabled
      }
    end,
  },
  -- LSP_SIGNATURE.NVIM
  {
    -- lsp_signature.nvim [auto params help]
    -- https://github.com/ray-x/lsp_signature.nvim
    "ray-x/lsp_signature.nvim",
    event = "LazyFile",
    opts = function()
      -- Apply globals from 1-options.lua
      local is_enabled = vim.g.lsp_signature_enabled
      local round_borders = { border = "rounded" }
      return {

        -- Window mode
        floating_window = is_enabled, -- Dislay it as floating window.
        hi_parameter = "IncSearch", -- Color to highlight floating window.
        handler_opts = round_borders, -- Window style

        -- Hint mode
        hint_enable = false, -- Display it as hint.
        hint_prefix = "👈 ",

        -- Aditionally, you can use <space>ui to toggle inlay hints.
      }
    end,
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  -- INCRENAME
  {
    "smjonas/inc-rename.nvim",
    opts = {
      show_message = false,
      hl_group = "Substitute", -- the highlight group used for highlighting the identifier's new name
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancell
    },
  },
}
