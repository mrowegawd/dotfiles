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
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash: jump" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash: treesiter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash: remote" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },
  -- GRUG-FAR.NVIM
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    dependencies = { "mrjones2014/smart-splits.nvim" },
    keys = {
      {
        "<Leader>oF",
        "<CMD>GrugFar<CR>",
        desc = "Open: grug far [grugfar]",
      },
      {
        "<Leader>oF",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "v" },
        desc = "Open: grug far (visual) [grugfar]",
      },
    },
    opts = {
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
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<Leader>xr",
        "<cmd>Trouble lsp_references toggle focus=true auto_refresh=false<cr>",
        desc = "Exec: references LSP [trouble]",
      },
      -- {
      --   "gi",
      --   "<cmd>Trouble lsp_implementations toggle focus=true win.position=right<cr>",
      --   desc = "LSP: implementations [trouble]",
      -- },
      -- {
      --   "gO",
      --   "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=right<cr>",
      --   desc = "LSP: outgoing calls [trouble]",
      -- },
      -- {
      --   "gI",
      --   "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=right<cr>",
      --   desc = "LSP: incomming calls [trouble]",
      -- },
      -- {
      --   "gt",
      --   "<cmd>Trouble lsp_type_definitions<CR>",
      --   desc = "LSP: type definitions [trouble]",
      -- },
      {
        "<Leader>xx",
        function()
          vim.cmd [[Trouble]]
        end,
        desc = "Exec: trouble [trouble]",
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
        desc = "Exec: check TodoTrouble curbuf [trouble]",
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
        desc = "Exec: check TodoTrouble global [trouble]",
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
        win = { position = "bottom", relative = "win" },
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
          o = "jump",
          zh = "fold_toggle",
          ["<a-n>"] = "next",
          ["<a-p>"] = "prev",
          ["<c-n>"] = "next",
          ["<c-p>"] = "prev",
          ["<TAB>"] = "fold_toggle",
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
      -- { "<Leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      keywords = {
        FIX = {
          icon = RUtils.config.icons.misc.tools,
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        WARN = {
          icon = RUtils.config.icons.misc.bug,
          color = "warning",
          alt = { "WARNING", "WARN" },
        },
        TODO = { icon = RUtils.config.icons.misc.check_big, color = "info" },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
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
        pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
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
}
