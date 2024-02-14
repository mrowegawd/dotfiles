local api = vim.api

local Highlight = require "r.settings.highlights"
local Util = require "r.utils"
local Icons = require("r.config").icons

local fzf_lua = Util.cmd.reqcall "fzf-lua"

return {
  -- AERIAL (disabled)
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    enabled = false,
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
            Util.tiling.force_win_close({}, true)
            vim.cmd [[AerialToggle right]]
            -- if vim.bo[0].filetype == "aerial" then
            --   vim.cmd [[wincmd L]]
            -- end
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
            fzf_lua.fzf_exec(aerial_selected, {
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
                    local opts_aerial = Util.opts "aerial.nvim"
                    local aerial = get_aerial()
                    aerial.close()

                    local path = vim.fn.expand "%:p"
                    vim.cmd [[bd]]
                    vim.cmd("e " .. path)
                    if selection == "all" then
                      opts_aerial.filter_kind = false
                    else
                      opts_aerial.filter_kind = { selection }
                    end
                    aerial.setup(opts_aerial)
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
      -- Highlight.plugin("arials", {
      --   { AerialGuide = { fg = { from = "CodeComment1", attr = "fg" } } },
      -- })

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
        icons = Icons.kinds,
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
  -- VISTA.NVIM
  {
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    enabled = function()
      if require("r.config").lsp_style == "coc" then
        return true
      end
      return false
    end,
    config = function()
      vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }
    end,
  },
  -- GLANCE
  {
    "DNLHC/glance.nvim",
    enabled = false,
    event = { "LspAttach", "VeryLazy" },
    cmd = { "Glance" },
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
        -- -- Taken from https://github.com/DNLHC/glance.nvim#hooks
        -- -- Don't open glance when there is only one result and it is
        -- -- located in the current buffer, open otherwise
        -- hooks = {
        --   ---@diagnostic disable-next-line: unused-local
        --   before_open = function(results, open, jump, method)
        --     local uri = vim.uri_from_bufnr(0)
        --     if #results == 1 then
        --       local target_uri = results[1].uri or results[1].targetUri
        --
        --       if target_uri == uri then
        --         jump(results[1])
        --       else
        --         open(results)
        --       end
        --     else
        --       open(results)
        --     end
        --   end,
        -- },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["<c-v>"] = actions.jump_vsplit,
            ["<c-s>"] = actions.jump_split,
            ["<c-t>"] = actions.jump_tab,
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["<a-n>"] = actions.next_location,
            ["<a-p>"] = actions.previous_location,
            ["h"] = actions.close_fold,
            ["l"] = actions.open_fold,
            ["p"] = actions.enter_win "preview",
            ["<C-l>"] = "",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
          preview = {
            ["ql"] = actions.close,
            ["p"] = actions.enter_win "list",
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["<a-n>"] = actions.next_location,
            ["<a-p>"] = actions.previous_location,
            ["C-l"] = "",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
        },
      }
    end,
  },
  -- LSPSAGA
  {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function(_, opts)
      Highlight.plugin("LspsagaCustomHi", {
        -- { SagaBorder = { link = "NormalFloat" } },
        { SagaTitle = { bg = "red" } },
        { SagaFileName = { link = "Directory" } },
        -- { SagaFinderFName = { bg = { from = "Boolean", attr = "fg" }, fg = { from = "Normal", attr = "bg" } } },
        -- { SagaFolderName = { link = "Directory" } },
        -- { SagaNormal = { link = "Pmenu" } },
      })

      require("lspsaga").setup(opts)
    end,
    opts = {
      ui = {
        expand = "",
        collapse = "",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        actionfix = " ",
        hover = " ",
        theme = "arrow",
        lines = { "┗", "┣", "┃", "━" },
      },
      diagnostic = {
        keys = {
          exec_action = "o",
          quit = "q",
          expand_or_jump = "<CR>",
          quit_in_show = { "q", "<ESC>" },
        },
      },
      code_action = {
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
      scroll_preview = {
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
      finder = {
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
            "<c-c>",
            "<c-l>",
            "<c-h>",
          },
        },
      },
      definition = {
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
        auto_preview = false,
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
    },
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
  -- NVIM-GTD
  {
    "hrsh7th/nvim-gtd",
    -- enabled = false,
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
          "NvimTree",
          "gitcommit",
          "lazy",
          "neo-tree",
          "dashboard",
          "orgagenda",
          "aerial",
          "outline",
          "sagafinder",
          "qf",
        },
      }
    end,
  },
  -- SYMBOL-USAGE
  {
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    opts = {
      disable = { filetypes = { "dockerfile" } },
    },
  },
  -- GENTAGS
  {
    "linrongbin16/gentags.nvim",
    event = "VeryLazy",
    cond = vim.fn.executable "ctags" == 1,
    opts = {},
  },
}
