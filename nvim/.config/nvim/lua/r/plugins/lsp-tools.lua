local Highlight = require "r.settings.highlights"

return {
  -- OUTPUTPANEL
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    config = function()
      require("output_panel").setup()
    end,
  },
  -- GOTOPREVIEW
  {
    "rmagatti/goto-preview",
    event = "VeryLazy",
    config = function()
      require("goto-preview").setup {
        post_open_hook = function(_, win)
          vim.api.nvim_set_option_value("winhighlight", "Normal:NormalFloat,FloatBorder:FloatBorder", { win = win })
        end,
      }
    end,
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
  -- NVIM-DEVDOCS (disabled)
  {
    "luckasRanarison/nvim-devdocs",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = true,
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
    event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    keys = {
      {
        "<Leader>us",
        function()
          require("symbol-usage").refresh()
          RUtils.info("Refresh", { title = "Symbol-usage" })
        end,
        desc = "Toggle: symbol-usage refresh [symbol-usage]",
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
        disable = { filetypes = { "dockerfile", "markdown", "org", "neorg" } },
        ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn' `above` by default
        vt_position = "end_of_line",
      }
    end,
  },
  -- LSP-SIGNATURE
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy", -- "InsertEnter",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      Highlight.plugin("lspSignatureUIcol", {
        { LspSignatureActiveParameter = { fg = "white", bg = "NONE", bold = true, underline = true } },
      })
      require("lsp_signature").setup(opts)
    end,
  },
  -- GLANCE
  {
    "DNLHC/glance.nvim",
    event = "LspAttach",
    enabled = false,
    cmd = { "Glance" },
    opts = function()
      Highlight.plugin("glanceHi", {
        { GlancePreviewNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
        { GlancePreviewCursorLine = { bg = { from = "CursorLine", attr = "bg" } } },
        { GlancePreviewLineNr = { bg = { from = "NormalFloat", attr = "bg" } } },

        -- { GlanceListNormal = { bg = { from = "NormalFloat", attr = "bg", alter = -0.8 } } },
        { GlanceListCursorLine = { bg = { from = "CursorLine", attr = "bg" } } },
      })

      local actions = require("glance").actions

      return {
        height = 30, -- Height of the window
        zindex = 100,
        preview_win_opts = { relativenumber = false, wrap = false },
        folds = {
          fold_closed = "",
          fold_open = "",
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
            ["zm"] = actions.close_fold,
            ["l"] = actions.open_fold,
            ["zo"] = actions.open_fold,
            ["za"] = actions.open_fold,
            ["<C-l>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
            ["<a-h>"] = actions.enter_win "preview",
            ["<c-h>"] = actions.enter_win "preview",
            ["p"] = actions.enter_win "preview",
          },
          preview = {
            ["ql"] = actions.close,
            ["p"] = actions.enter_win "list",
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["<a-l>"] = actions.enter_win "list",
            ["<c-l>"] = actions.enter_win "list",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
        },
      }
    end,
  },
  -- KULALA
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    config = true,
    keys = {
      { "<Leader>R", "", desc = "+rest" },
      { "rf", "<cmd>lua require('kulala').run()<cr>", ft = "http", desc = "Kulala: send the request" },
      { "rH", "<cmd>lua require('kulala').toggle_view()<cr>", ft = "http", desc = "Kulala: toggle headers/body" },
      { "rF", "<cmd>lua require('kulala').scratchpad()<cr>", ft = "http", desc = "Kulala: open scratchpad" },
      { "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Kulala: copy as cURL" },
      { "R", "<cmd>lua require('kulala').replay()<cr>", desc = "Kulala: replay the last request" },
      {
        "<c-p>",
        "<cmd>lua require('kulala').jump_prev()<cr>",
        ft = "http",
        desc = "Kulala: jump to previous request",
      },
      {
        "<c-n>",
        "<cmd>lua require('kulala').jump_next()<cr>",
        ft = "http",
        desc = "Kulala: jump to next request",
      },
      -- Closes the kulala window and also the current buffer if it is a .http or .rest file
      { "rr", "<cmd>lua require('kulala').close()<cr>", ft = "http", desc = "Kulala: close window" },
    },
  },
}
