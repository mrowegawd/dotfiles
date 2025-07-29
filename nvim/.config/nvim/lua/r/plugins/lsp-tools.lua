return {
  -- GOTO-PREVIEW
  {
    "rmagatti/goto-preview",
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
  -- SYMBOL-USAGE
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
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
  -- KULALA
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    config = true,
    --stylua: ignore
    keys = {
      { "<Leader>r", "", desc = "Kulala: rest", ft = "http" },
      { "<Leader>rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Tasks: open scratchpad [kulala]", ft = "http" },
      { "<Leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Tasks: copy as cURL [kulala]", ft = "http" },
      { "<Leader>rf", "<cmd>lua require('kulala').run()<cr>", desc = "Tasks: send the request [kulala]", ft = "http" },
      { "<Leader>rH", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Kulala: toggle headers/body [kulala]", ft = "http", },
      { "<Leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Tasks: inspect current request [kulala]", ft = "http", },
      { "<Leader>rr", "<cmd>lua require('kulala').close()<cr>", desc = "Tasks: close window [kulala]", ft = "http" },
      {
        "<a-p>",
        "<cmd>lua require('kulala').jump_prev()<cr>",
        desc = "Kulala: jump to previous request",
        ft = "http",
      },
      {
        "<a-n>",
        "<cmd>lua require('kulala').jump_next()<cr>",
        desc = "Kulala: jump to next request",
        ft = "http",
      },
    },
  },
  -- TINY-CODE-ACTION
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {},
  },
}
