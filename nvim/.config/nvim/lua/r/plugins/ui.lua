local fn = vim.fn
local highlight = require "r.config.highlights"
local Util = require "r.utils"

return {
  -- MINI.INDENTSCOPE
  {
    "echasnovski/mini.indentscope",
    version = "*",
    main = "mini.indentscope",
    event = { "VeryLazy" },
    config = function(_, opts)
      highlight.plugin("mini.indentscopeUi", {
        { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
      })
      require("mini.indentscope").setup(opts)

      Util.cmd.augroup("DetachMiniIndentScope", {
        event = { "FileType" },
        pattern = {
          "NeogitCommitMessage",
          "NeogitPopup",
          "NeogitStatus",
          "NvimTree",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
          "checkhealth",
          "dashboard",
          "fzf",
          "gitcommit",
          "help",
          "lazy",
          "lspinfo",
          "make",
          "man",
          "markdown",
          "mason",
          "neorg",
          "norg",
          "org",
          "orgagenda",
          "sagafinder",
        },
        command = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      symbol = "┊",
      mappings = {
        goto_top = "<leader>k",
        goto_bottom = "<leader>j",
      },
      options = {
        try_as_border = true,
      },
      draw = {
        animation = function()
          return 0
        end,
      },
    },
  },
  -- INDENT-BLANKLINE
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "ColorScheme" },
    main = "ibl",
    opts = {
      scope = { enabled = false },
      indent = {
        char = "┊", -- │, ┊, │, ▏, ┆, ┊, , ┊
        tab_char = "┊", -- │, ┊, │, ▏, ┆, ┊, , ┊
        repeat_linebreak = false,
      },
      exclude = {
        filetypes = {
          "NvimTree",
          "dashboard",
          "dbout",
          "flutterToolsOutline",
          "fzf",
          "fzflua",
          "git",
          "gitcommit",
          "help",
          "log",
          "markdown",
          "neo-tree",
          "neo-tree-popup",
          "norg",
          "org",
          "orgagenda",
          "sagafinder",
          "txt",
          "undotree",
        },
      },
    },
    config = function(_, opts)
      highlight.plugin("ibl_indentline", {
        { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
        { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
      })
      require("ibl").setup(opts)
    end,
  },
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    init = function()
      vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
      vim.notify = require "notify"
    end,
    opts = {
      timeout = 5000,
      max_width = function()
        return math.floor(vim.o.columns * 0.6)
      end,
      top_down = false,
      max_height = function()
        return math.floor(vim.o.lines * 0.8)
      end,

      -- on_open = function(win)
      --   if not vim.api.nvim_win_is_valid(win) then
      --     return
      --   end
      --   vim.api.nvim_win_set_config(win, { border = require("r.config").icons.border.line })
      -- end,
      render = function(...)
        local notification = select(2, ...)
        local style = Util.cmd.falsy(notification.title[1]) and "minimal" or "default"
        require("notify.render")[style](...)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 175 })
        if not vim.g.notifications_enabled then
          vim.api.nvim_win_close(win, true)
        end
        if not package.loaded["nvim-treesitter"] then
          pcall(require, "nvim-treesitter")
        end
        vim.wo[win].conceallevel = 3
        local buf = vim.api.nvim_win_get_buf(win)
        if not pcall(vim.treesitter.start, buf, "markdown") then
          vim.bo[buf].syntax = "markdown"
        end
        vim.wo[win].spell = false
      end,
    },
    config = function(_, opts)
      -- require("r.config.highlights").plugin("notify", {
      --   { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
      --   { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
      --   { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
      --   { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
      --   { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
      --   { NotifyERRORBody = { link = "NormalFloat" } },
      --   { NotifyWARNBody = { link = "NormalFloat" } },
      --   { NotifyINFOBody = { link = "NormalFloat" } },
      --   { NotifyDEBUGBody = { link = "NormalFloat" } },
      --   { NotifyTRACEBody = { link = "NormalFloat" } },
      -- })
      require("notify").setup(opts)
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
      "MunifTanjim/nui.nvim",
    },
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        ---@diagnostic disable-next-line: param-type-mismatch
        function() require("noice").redirect(fn.getcmdline()) end,
        mode = "c",
        desc =
        "Redirect Cmdline"
      },
      { "<leader>rD", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    },
    init = function()
      require("r.config.highlights").plugin("notify", {
        { NoiceCmdlinePopupBorder = { fg = { from = "Directory" } } },
      })
    end,
    opts = {
      -- debug = true,
      lsp = {
        documentation = {
          opts = {
            border = { style = "rounded" },
            position = { row = 2 },
          },
        },
        progress = {
          enabled = false,
        },
        signature = { auto_open = { enabled = true }, enabled = false },
        hover = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false,
        },
      },
      cmdline = {
        view = "cmdline",
      },
      messages = {
        -- Using kevinhwang91/nvim-hlslens because virtualtext is hard to read
        view_search = false,
      },
      popupmenu = {
        backend = "cmp",
      },
      routes = {
        {
          opts = { skip = true },
          filter = {
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { event = { "msg_showmode", "msg_showcmd", "msg_ruler" } },
              { event = "msg_show", find = "written" },
              { event = "msg_show", find = "%d+ lines, %d+ bytes" },
              { event = "msg_show", kind = "search_count" },
              { event = "msg_show", find = "%d+L, %d+B" },
              { event = "msg_show", find = "^Hunk %d+ of %d" },
              { event = "msg_show", find = "%d+ change" },
              { event = "msg_show", find = "%d+ line" },
              { event = "msg_show", find = "%d+ more line" },
              -- TODO: investigate the source of this LSP message and disable it happens in typescript files
              -- https://github.com/nvimdev/lspsaga.nvim/issues/1295
              { event = "notify", find = "No information available" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        command_palette = true, -- position the cmdline and popupmenu together
        bottom_search = true, -- use a classic bottom cmdline for search
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
  -- FOLD CYCLE
  {
    "jghauser/fold-cycle.nvim",
    opts = {},
    keys = {
      {
        "<Leader>z",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold(fold-cycle): cycle fold",
      },
      {
        "z<Leader>",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold(fold-cycle): cycle fold",
      },
    },
  },
  -- INCLINE.NVIM
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    opts = function()
      return {
        highlight = {
          groups = {
            InclineNormal = {
              guifg = highlight.tint(highlight.get("Normal", "bg"), -0.5),
              guibg = highlight.tint(highlight.get("Normal", "fg"), 1),
              gui = "bold",
            },

            InclineNormalNC = {
              guifg = highlight.tint(highlight.get("LineNr", "fg"), 1),
              guibg = highlight.tint(highlight.get("Normal", "bg"), 0.5),
              gui = "bold",
            },
          },
        },
        window = { margin = { vertical = 0, horizontal = 2 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      }
    end,
  },
  -- NEO-SCROLL
  {
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    event = "VeryLazy",
    opts = { hide_cursor = true, mappings = { "<C-d>", "<C-u>", "zt", "zz", "zb" } },
  },
}
