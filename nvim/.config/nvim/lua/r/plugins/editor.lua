local alts = {
  FIX = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR" },
  DONE = { "DONE", "DONE!", "DONE.", "FIXED", "WONTFIX" },
  TODO = { "PLAN", "TODO", "TASK", "START", "BEGIN" },
  WARN = { "WARNING", "WARN", "HACK" },
  PREF = { "PERF", "OPTIM", "OPTIMIZE", "PERFORMANCE" },
  INFO = { "INFO" },
}

return {
  -- FLASH.NVIM
  {
    "folke/flash.nvim",
    opts = {
      modes = { char = { keys = { "F", ";" } }, search = { enabled = false } },
      jump = { nohlsearch = true },
      highlight = { backdrop = false },
    },
    -- stylua: ignore
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash: jump (visual, operator)" },
      { "gs", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash: treesiter (visual , operator)" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash: remote (operator)" },
      -- Kegunaan: ini akan menselect semua function, tekan v, lalu R
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash: treesitter search (visual, operator)" },
      { "<c-s>",
        function()
          require("flash").treesitter({
            actions = {
              ["<c-j>"] = "next",
              ["<c-k>"] = "prev"
            }
          })
        end,
        mode = { "n", "o", "x" },
        desc = "Flash: treesitter incremental selection (visual, oprator)"
      },
    },
  },
  -- CANDELA: HIGHLIGHTS FOR STRING REGEX IN LOG FILE
  {
    "KieranCanter/candela.nvim",
    cmd = "Candela",
    opts = {},
  },
  -- GRUG-FAR.NVIM
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    dependencies = { "mrjones2014/smart-splits.nvim" },
    keys = {
      {
        "<Localleader>gb",
        function()
          local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
          local grug = require "grug-far"
          grug.open {
            prefills = {
              search = "",
              replacement = "",
              filesFilter = "",
              flags = "-i",
              paths = path,
            },
            staticTitle = "Find and Replace",
          }
        end,
        desc = "GrepEnchanted: grug far current path [grugfar]",
      },
      {
        "<Localleader>gb",
        function()
          local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
          local grug = require "grug-far"
          local _str = RUtils.get_visual_selection()
          if not _str then
            return
          end
          grug.open {
            prefills = {
              search = _str.selection,
              replacement = "",
              filesFilter = "",
              paths = path,
              flags = "--hidden -i",
            },
            staticTitle = "Find and Replace",
          }
        end,
        mode = "v",
        desc = "GrepEnchanted: grug far current path (visual) [grugfar]",
      },
      {
        "<Localleader>gg",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              flags = "--hidden",
            },
          }
        end,
        mode = { "x", "n" },
        desc = "GrepEnchanted: grug far (normal or visual) [grugfar]",
      },
    },
    opts = {
      windowCreationCommand = "botright vsplit",
      keymaps = {
        replace = { n = "<c-c>" },
        qflist = { n = "<c-q>" },
        syncLocations = { n = "<Localleader>s" },
        syncLine = { n = "<Localleader>l" },
        close = { n = "q" },
        historyOpen = { n = "<Leader>h" },
        historyAdd = { n = "<Leader>A" },
        refresh = { n = "R" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
      },
    },
  },
  -- NUMB-NVIM
  {
    "nacro90/numb.nvim",
    event = "BufReadPost",
    config = true,
  },
  -- TROUBLE.NVIM
  {
    -- dir = "~/.local/src/nvim_plugins/trouble.nvim",
    "MadKuntilanak/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<Leader>xr",
        "<CMD>Trouble resume<CR>",
        desc = "Exec: resume [trouble]",
      },

      {
        "<Leader>xx",
        function()
          vim.cmd [[Trouble]]
        end,
        desc = "Exec: open list trouble builtin [trouble]",
      },
      {
        "<Leader>xt",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd [[Trouble todo toggle filter.buf=0]]
        end,
        desc = "Exec: check todotrouble curbuf [trouble]",
      },
      {
        "<Leader>xT",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd [[TodoTrouble]]
        end,
        desc = "Exec: check todotrouble global [trouble]",
      },
      {
        "<Leader>xD",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end

          vim.cmd [[Trouble diagnostics toggle]]
        end,
        desc = "Exec: workspaces diagnostics [trouble]",
      },
      {
        "<Leader>xd",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd [[Trouble diagnostics toggle filter.buf=0]]
        end,
        desc = "Exec: document diagnostisc [trouble]",
      },
      {
        "<Leader>xl",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            if RUtils.qf.is_loclist() then
              vim.cmd [[lclose]]
            end
          end
          vim.cmd "Trouble loclist toggle"
        end,
        desc = "Exec: open loclist with [trouble]",
      },
      {
        "<Leader>xq",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble qflist toggle"
        end,
        desc = "Exec: open quickfix (qf) with [trouble]",
      },
    },
    opts = function()
      local icons_lsp = RUtils.config.icons.kinds
      return {
        focus = true,
        auto_refresh = false, -- use `R` to toggle it
        win = { position = "bottom", relative = "win" },
        preview = {
          type = "main",
          -- when a buffer is not yet loaded, the preview window will be created
          -- in a scratch buffer with only syntax highlighting enabled.
          -- Set to false, if you want the preview to always be a real loaded buffer.
          scratch = false,
        },
        icons = {
          kinds = {
            Array = icons_lsp.Array,
            Boolean = icons_lsp.Boolean,
            Class = icons_lsp.Classs,
            Constant = icons_lsp.Constant,
            Constructor = icons_lsp.Constructor,
            Enum = icons_lsp.Enum,
            EnumMember = icons_lsp.EnumMember,
            Event = icons_lsp.Event,
            Field = icons_lsp.Field,
            File = icons_lsp.File,
            Function = icons_lsp.Function,
            Interface = icons_lsp.Interface,
            Key = icons_lsp.Interface,
            Method = icons_lsp.Key,
            Module = icons_lsp.Method,
            Namespace = icons_lsp.Namespace,
            Null = icons_lsp.Null,
            Number = icons_lsp.Number,
            Object = icons_lsp.Object,
            Operator = icons_lsp.Operator,
            Package = icons_lsp.Package,
            Property = icons_lsp.Property,
            String = icons_lsp.String,
            Struct = icons_lsp.Struct,
            TypeParameter = icons_lsp.TypeParameter,
            Variable = icons_lsp.Variable,
          },
        },
        keys = {
          ["<esc>"] = "cancel",

          q = "close",
          ["<Leader>bk"] = "close",

          r = "refresh",
          R = "toggle_refresh",

          ["<c-s>"] = "jump_split_aboveleft_close",
          -- ["<c-v>"] = "jump_vsplit",

          o = "jump",

          P = "toggle_preview",

          ["<C-a>"] = "fold_toggle",
          ["<TAB>"] = "fold_toggle",

          ["<a-n>"] = "next",
          ["<c-n>"] = "next",
          ["<a-p>"] = "prev",
          ["<c-p>"] = "prev",
        },
      }
    end,
  },
  -- TODOCOMMENTS
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    keys = {
      {
        "<Leader>fT",
        function()
          RUtils.todocomments.search_global { title = "Global" }
          vim.cmd "normal! zz"
        end,
        desc = "Picker: todo global dir (fzflua) [todocomments]",
      },
      {
        "<Leader>ft",
        function()
          RUtils.todocomments.search_local { title = "Curbuf" }
          vim.cmd "normal! zz"
        end,
        desc = "Picker: todo local dir (fzflua) [todocomments]",
      },
    },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      keywords = {
        FIX = { icon = RUtils.config.icons.misc.tools, color = "error", alt = alts.FIX },
        WARN = { icon = RUtils.config.icons.misc.bug, color = "warning", alt = alts.WARN },
        TODO = { icon = RUtils.config.icons.misc.todo, color = "info", alt = alts.TODO },
        NOTE = { icon = RUtils.config.icons.misc.note, color = "hint", alt = alts.INFO },
      },
      -- merge_keywords = false,
      highlight = {
        before = "", -- "fg", "bg", or empty
        keyword = "wide", -- "fg", "bg", "wide", or empty
        after = "fg", -- "fg", "bg", or empty
        pattern = [[.*<(KEYWORDS)*:]],
        comments_only = true, -- highlight only inside comments using treesitter
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      colors = {
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
      },
      search = {
        command = "rg",
        -- pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
        search = {
          pattern = [[(?:\/\/|--(\[\[)?|\*|#\|?|%\{?|;|\{-)[\t ]*(?:(KEYWORDS):)]],
          -- https://www.reddit.com/r/neovim/comments/1qdhr3s/todocommentsnvim_reducing_amount_of_false/
          --[[
          Regex explanation:
          1. (?:...) - non-capture group for comment tokens:
            \/\/ - matches // , used in lots of languages
            --(\[\[)? - matches -- and --[[ , -- used in  SQL, Haskell, Lua,
                  Ada, AppleScript, VHDL, --[[ used in Lua multiline, also
                  matches <!-- for HTML, XML, Markdown
            \*   - matches various formats ( /* /** (* ), lines starting 
                  with * in formatted multiline comments (usually
                  after /* ), also COBOL
            #\|? - matches # and #| - lots of languages comment with # ,
                  ### used in CoffeeScript, #| in Racket and Common
                  Lisp multiline
            %\{? - matches % and %{, % used in MATLAB, Erlang, Prolog,
                  TeX/LaTeX, also %{ used in MATLAB
            ;    - used in Assembly, Lisp, Clojure, Scheme, INI files
            {-   - Haskel multiline
          2. [\t ]* - 0 or any amount of tabs and spaces
          3. (?:(KEYWORDS):) - non-capture group with keywords placeholder ending with :

          This regex does not match: Python docstrings ( """ or ''' ), Ruby
          multiline ( =begin ), Clojure comment reader macro, Batch files,
          Roxygen, Fortran, Visual Basic, VBScript, Basic, PostScript, J, M4
          ]]
        },
        args = {
          "--color=never",
          "--no-heading",
          "--follow",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "-g",
          "!node_modules/**",
          "-g",
          "!.git/**",
        },
      },
    },
  },
  -- ATONE.NVIM -> alternative undotree
  {
    "XXiaoA/atone.nvim",
    cmd = { "Atone", "UndoTree" },
    keys = { { "<Leader>oU", mode = { "n", "x", "o" } } },
    opts = {
      keymaps = {
        tree = {
          quit = { "<C-c>", "q", "<Leader>bk" },
          next_node = "j", -- support v:count
          pre_node = "k", -- support v:count
          undo_to = "<CR>",
          help = { "g?" },
        },
        auto_diff = { quit = { "<C-c>", "q", "<Leader>bk" }, help = { "g?" } },
        help = { quit_help = { "<C-c>", "q", "<Leader>bk" } },
      },
    },
    config = function(_, opts)
      require("atone").setup(opts)

      vim.api.nvim_create_user_command("UndoTree", function()
        vim.cmd "Atone toggle"
      end, { desc = "Open: undo tree [atone.nvim]" })

      RUtils.map.nnoremap("<Leader>oU", function()
        vim.cmd "UndoTree"
      end, { desc = "Open: undo tree [atone.nvim]" })
    end,
  },
}
