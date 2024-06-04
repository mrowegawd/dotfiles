local Highlight = require "r.settings.highlights"

return {
  -- LSPSAGA (disabled)
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    enabled = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function(_, opts)
      Highlight.plugin("LspsagaCustomHi", {
        -- { SagaBorder = { link = "NormalFloat" } },
        { SagaTitle = { bg = "red", fg = "black", bold = true } },
        { SagaFileName = { link = "Directory" } },
        -- { SagaFinderFName = { bg = { from = "Boolean", attr = "fg" }, fg = { from = "Normal", attr = "bg" } } },
        -- { SagaFolderName = { link = "Directory" } },
        -- { SagaNormal = { link = "Pmenu" } },
      })

      require("lspsaga").setup(opts)
    end,
    opts = {
      ui = {
        border = "rounded",
        devicon = true,
        foldericon = true,
        title = true,
        expand = "⊞",
        collapse = "⊟",
        code_action = "💡",
        lines = { "┗", "┣", "┃", "━", "┏" },
        kind = nil,
        button = { "", "" },
        imp_sign = "󰳛 ",
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
        max_height = 0.8,
        left_width = 0.7,
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
        layout = "normal", -- normal, layout
        win_width = 30,
        auto_preview = true,
        detail = true,
        auto_close = true,
        close_after_jump = false,
        max_height = 0.5,
        left_width = 0.3,
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
  -- INCRENAME
  {
    "smjonas/inc-rename.nvim",
    opts = {
      show_message = false,
      hl_group = "MyQuickFixLineEnter", -- the highlight group used for highlighting the identifier's new name
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancel
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
      { "<Leader>fd", "<CMD>DevdocsOpen<CR>", desc = "Misc: open devdocs [devdocs]" },
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
  -- SYMBOL-USAGE
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    opts = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("MyCodeUsage").bg, italic = true })
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageContent",
        { bg = h("MyCodeUsage").bg, fg = h("MyCodeUsage").fg, italic = true }
      )
      vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("MyCodeUsage").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("MyCodeUsage").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("MyCodeUsage").bg, italic = true })

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
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
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
        disable = { filetypes = { "dockerfile", "markdown", "org", "neorg" } },
        ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn' `above` by default
        vt_position = "end_of_line",
      }
    end,
  },
}
