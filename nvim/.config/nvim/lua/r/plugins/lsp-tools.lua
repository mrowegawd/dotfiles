local api = vim.api

local highlight = require "r.config.highlights"
local Util = require "r.utils"

local set_icons = function(icons_name)
  return icons_name .. " "
end

return {
  -- FIDGET
  {
    "j-hui/fidget.nvim",
    event = "LazyFile",
    opts = {},
  },
  -- TROUBLE.NVIM
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = { { "<Localleader>tr", "<CMD>TroubleToggle<CR>", desc = "Misc(trouble): toggle" } },
    opts = function()
      highlight.plugin("trouble", {
        { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn" } } },
        { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError" } } },
        { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint" } } },
        { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleIndent = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
        { TroubleLocation = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg" } } },
        { TroubleFoldIcon = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
        {
          TroubleCount = {
            bg = { from = "WinSeparator", attr = "fg", alter = 0.8 },
            fg = { from = "DiagnosticSignError", attr = "fg", alter = 0.1 },
          },
        },
      })
      return {
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
          jump_close = "<cr>", -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "o", -- toggle auto_preview
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
      highlight.plugin("lspsaga", {
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
    -- enabled = false,
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
    keys = function()
      local function get_aerial()
        local ok_aerial, aerial = pcall(require, "aerial")
        return ok_aerial and aerial or {}
      end

      local height = vim.o.lines - vim.o.cmdheight
      if vim.o.laststatus ~= 0 then
        height = height - 1
      end

      local vim_width = vim.o.columns
      local vim_height = height

      local widthc = math.floor(vim_width / 2 + 8)
      local heightc = math.floor(vim_height / 2 - 5)

      return {
        {
          "<Localleader>oa",
          function()
            Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, true)
            vim.cmd [[AerialToggle]]
          end,
          desc = "Misc(aerial): toggle",
        },
        {
          "<Localleader>oA",
          function()
            if vim.bo[0].filetype == "norg" then
              return
            end

            local aerial_selected = {
              "Class",
              "Constructor",
              "Object",
              "Enum",
              "Function",
              "Interface",
              "Variable",
              "Module",
              "Method",
              "Struct",
              "all",
            }
            require("fzf-lua").fzf_exec(aerial_selected, {
              prompt = "  ",
              no_esc = true,
              fzf_opts = { ["--layout"] = "reverse" },
              winopts_fn = {
                width = widthc,
                height = heightc,
              },
              winopts = {
                title = "[Aerial] Change filter kind",
                row = 1,
                relative = "cursor",
                height = 0.33,
                width = widthc / (widthc + vim_width - 10),
              },
              actions = {
                ["default"] = function(selected, _)
                  local selection = selected[1]
                  if selection ~= nil and type(selection) == "string" then
                    local plugin = require("lazy.core.config").plugins["aerial.nvim"]
                    local Plugin = require "lazy.core.plugin"
                    local optsc = Plugin.values(plugin, "opts", false)
                    local aerial = get_aerial()
                    aerial.close()

                    local path = vim.fn.expand "%:p"
                    vim.cmd [[bd]]
                    vim.cmd("e " .. path)
                    if selection == "all" then
                      optsc.filter_kind = false
                    else
                      optsc.filter_kind = { selection }
                    end
                    aerial.setup(optsc)
                    aerial.open()
                  end
                end,
              },
            })
          end,
          desc = "Misc(aerial): change filter kind",
        },
      }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      highlight.plugin("arials", {
        { AerialGuide = { fg = { from = "CodeComment1", attr = "fg" } } },
      })

      ---@diagnostic disable-next-line: undefined-field
      require("telescope").load_extension "aerial"

      local vim_width = vim.o.columns
      vim_width = math.floor(vim_width / 2 - 30)
      return {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = { min_width = vim_width },
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
          -- ["o"] = "actions.jump",
          ["o"] = "actions.scroll",
          -- ["]y"] = "actions.next",
          -- ["[y"] = "actions.prev",
          ["<a-n>"] = "actions.down_and_scroll",
          ["<a-p>"] = "actions.up_and_scroll",
          -- ["<a-n>"] = "actions.next",
          -- ["<a-p>"] = "actions.prev",
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
    "hedyhli/outline.nvim",
    enabled = false,
    cmd = "Outline",
    init = function()
      Util.disable_ctrl_i_and_o("NoOutline", { "Outline" })
    end,
    keys = function()
      local function get_outline()
        local ok_aerial, aerial = pcall(require, "outline")
        return ok_aerial and aerial or {}
      end

      local height = vim.o.lines - vim.o.cmdheight
      if vim.o.laststatus ~= 0 then
        height = height - 1
      end

      local vim_width = vim.o.columns
      local vim_height = height

      local widthc = math.floor(vim_width / 2 + 8)
      local heightc = math.floor(vim_height / 2 - 5)
      return {

        { "<Localleader>oa", "<cmd>Outline<CR>", desc = "Misc(outline): toggle" },
        {
          "<Localleader>oA",
          function()
            if vim.bo[0].filetype == "norg" then
              return
            end

            local aerial_selected = {
              "Class",
              "Constructor",
              "Object",
              "Enum",
              "Function",
              "Interface",
              "Variable",
              "Module",
              "Method",
              "Struct",
              "all",
            }
            require("fzf-lua").fzf_exec(aerial_selected, {
              prompt = "  ",
              no_esc = true,
              fzf_opts = { ["--layout"] = "reverse" },
              winopts_fn = {
                width = widthc,
                height = heightc,
              },
              winopts = {
                title = "[Outline] filter symbols",
                row = 1,
                relative = "cursor",
                height = 0.33,
                width = widthc / (widthc + vim_width - 10),
              },
              actions = {
                ["default"] = function(selected, _)
                  local selection = selected[1]
                  if selection ~= nil and type(selection) == "string" then
                    local plugin = require("lazy.core.config").plugins["outline.nvim"]
                    local Plugin = require "lazy.core.plugin"
                    local optsc = Plugin.values(plugin, "opts", false)
                    local outline = get_outline()
                    if outline.is_open then
                      outline.close_outline()
                    end

                    local path = vim.fn.expand "%:p"
                    vim.cmd [[bd]]
                    vim.cmd("e " .. path)
                    if selection == "all" then
                      optsc.symbols.blacklist = {}
                    else
                      optsc.symbols.blacklist = { selection }
                    end
                    outline.setup(optsc)
                    outline.open_outline()
                  end
                end,
              },
            })
          end,
          desc = "Misc(aerial): change filter kind",
        },
      }
    end,
    config = function(_, opts)
      require("outline").setup(opts)
    end,
    opts = {
      symbols = {
        blacklist = {},
      },
      keymaps = {
        show_help = "?",
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        peek_location = "o",
        goto_and_close = "<S-Cr>",
        restore_location = "<C-g>",
        hover_symbol = "K",
        toggle_preview = "P",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        fold_toggle = "<tab>",
        fold_toggle_all = "<S-tab>",
        unfold = "l",
        fold_all = "zM",
        unfold_all = "E",
        fold_reset = "R",
        down_and_goto = "<a-n>",
        up_and_goto = "<a-p>",
      },
    },
  },
  -- DROPBAR
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    -- enabled = false,
    keys = {
      {
        "<Localleader>od",
        function()
          return require("dropbar.api").pick()
        end,
        desc = "Open(dropbar): pick",
      },
    },
    init = function()
      highlight.plugin("DropBar", {
        { DropBarMenuNormalFloat = { inherit = "ColorColumn" } },
        { DropBarIconKindArray = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindBoolean = { bg = { from = "ColorColumn" }, fg = { from = "@booleanj" } } },
        { DropBarIconKindBreakStatement = { bg = { from = "ColorColumn" }, fg = { from = "@error" } } },
        { DropBarIconKindCall = { bg = { from = "ColorColumn" }, fg = { from = "Function" } } },
        { DropBarIconKindCaseStatement = { bg = { from = "ColorColumn" }, fg = { from = "@conditional" } } },
        { DropBarIconKindClass = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindConstant = { bg = { from = "ColorColumn" }, fg = { from = "Constant" } } },
        { DropBarIconKindConstructor = { bg = { from = "ColorColumn" }, fg = { from = "Special" } } },
        { DropBarIconKindContinueStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindDeclaration = { bg = { from = "ColorColumn" }, fg = { from = "CmpItemKindSnippet" } } },
        { DropBarIconKindDelete = { bg = { from = "ColorColumn" }, fg = { from = "@error" } } },
        { DropBarIconKindDoStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindElseStatement = { bg = { from = "ColorColumn" }, fg = { from = "@conditional" } } },
        { DropBarIconKindEnum = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindEnumMember = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindEvent = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindField = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindFile = { bg = { from = "ColorColumn" }, fg = { from = "Directory" } } },
        { DropBarIconKindFolder = { bg = { from = "ColorColumn" }, fg = { from = "Directory" } } },
        { DropBarIconKindForStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindFunction = { bg = { from = "ColorColumn" }, fg = { from = "Function" } } },
        { DropBarIconKindH1Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH1" } } },
        { DropBarIconKindH2Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH2" } } },
        { DropBarIconKindH3Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH3" } } },
        { DropBarIconKindH4Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH4" } } },
        { DropBarIconKindH5Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH5" } } },
        { DropBarIconKindH6Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH6" } } },
        { DropBarIconKindIdentifier = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindIfStatement = { bg = { from = "ColorColumn" }, fg = { from = "Conditional" } } },
        { DropBarIconKindInterface = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindKeyword = { bg = { from = "ColorColumn" }, fg = { from = "Keyword" } } },
        { DropBarIconKindList = { bg = { from = "ColorColumn" }, fg = { from = "SpecialChar" } } },
        { DropBarIconKindMacro = { bg = { from = "ColorColumn" }, fg = { from = "Macro" } } },
        { DropBarIconKindMarkdownH1 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH1" } } },
        { DropBarIconKindMarkdownH2 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH2" } } },
        { DropBarIconKindMarkdownH3 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH3" } } },
        { DropBarIconKindMarkdownH4 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH4" } } },
        { DropBarIconKindMarkdownH5 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH5" } } },
        { DropBarIconKindMarkdownH6 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH6" } } },
        { DropBarIconKindMethod = { bg = { from = "ColorColumn" }, fg = { from = "Function" } } },
        { DropBarIconKindModule = { bg = { from = "ColorColumn" }, fg = { from = "LspKindModule" } } },
        { DropBarIconKindNamespace = { bg = { from = "ColorColumn" }, fg = { from = "Include" } } },
        { DropBarIconKindNull = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindNumber = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNumber" } } },
        { DropBarIconKindObject = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindOperator = { bg = { from = "ColorColumn" }, fg = { from = "Identifiern" } } },
        { DropBarIconKindPackage = { bg = { from = "ColorColumn" }, fg = { from = "LspKindModule" } } },
        { DropBarIconKindPair = { bg = { from = "ColorColumn" }, fg = { from = "LspKindString" } } },
        { DropBarIconKindProperty = { bg = { from = "ColorColumn" }, fg = { from = "LspKindProperty" } } },
        { DropBarIconKindReference = { bg = { from = "ColorColumn" }, fg = { from = "LspKindReference" } } },
        { DropBarIconKindRepeat = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindScope = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNameSpace" } } },
        { DropBarIconKindSpecifier = { bg = { from = "ColorColumn" }, fg = { from = "Specifier" } } },
        { DropBarIconKindStatement = { bg = { from = "ColorColumn" }, fg = { from = "Statement" } } },
        { DropBarIconKindString = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindStruct = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindSwitchStatement = { bg = { from = "ColorColumn" }, fg = { from = "Conditional" } } },
        { DropBarIconKindTerminal = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNumber" } } },
        { DropBarIconKindType = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindTypeParameter = { bg = { from = "ColorColumn" }, fg = { from = "LspKindTypeParameter" } } },
        { DropBarIconKindUnit = { bg = { from = "ColorColumn" }, fg = { from = "LspKindUnit" } } },
        { DropBarIconKindValue = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNumber" } } },
        { DropBarIconKindVariable = { bg = { from = "ColorColumn" }, fg = { from = "LspKindVariable" } } },
        { DropBarIconKindWhileStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconUIIndicator = { bg = { from = "ColorColumn" }, fg = { from = "SpecialChar" } } },
        { DropBarIconUIPickPivot = { bg = { from = "ColorColumn" }, fg = { from = "Error" } } },
        { DropBarIconUISeparator = { bg = { from = "ColorColumn" }, fg = { from = "SpecialChar" } } },
        { DropBarIconUISeparatorMenu = { bg = { from = "ColorColumn" }, fg = { from = "DropBarIconUISeparator" } } },
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
            use_devicons = false,
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
              sources.lsp,
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
    -- stylua: ignore
    keys = {
      { "<a-q>", function() require("illuminate").goto_next_reference(nil) end, desc = "LSP(vim-illuminate): go next reference" },
      { "<a-Q>", function() require("illuminate").goto_prev_reference(nil) end, desc = "LSP(vim-illuminate): go prev reference" },
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
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "LazyFile",
  },
  -- LSP_SIGNATURE.NVIM (disabled)
  {
    -- lsp_signature.nvim [auto params help]
    -- https://github.com/ray-x/lsp_signature.nvim
    "ray-x/lsp_signature.nvim",
    enabled = false,
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
      hl_group = "MyQuickFixLineEnter", -- the highlight group used for highlighting the identifier's new name
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancell
    },
  },
}
