return {
  {
    "saghen/blink.cmp",
    enabled = false,
    optional = true,
  },
  -- NVIM-CMP
  {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    version = false, -- Last release is way too old
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    event = { "InsertEnter", "CmdLineEnter" },
    dependencies = {
      { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      -- "iguanacucumber/mag-cmp-emoji",
      "rcarriga/cmp-dap",
      { "FelipeLema/cmp-async-path", name = "cmp-path" },
      "lukas-reineke/cmp-under-comparator",
      "davidsierradz/cmp-conventionalcommits",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function()
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()
      local auto_select = true

      local function get_lsp_completion_context(completion, source)
        local ok, source_name = pcall(function()
          return source.source.client.config.name
        end)
        if not ok then
          return nil
        end
        if source_name == "tsserver" then
          return completion.detail
        elseif source_name == "gopls" then
          return completion.detail
        elseif source_name == "rust_analyzer" then
          return completion.detail
        elseif source_name == "zls" then
          return completion.detail
        elseif source_name == "lua_ls" then
          return completion.detail
        end
      end

      return {
        auto_brackets = {}, -- Configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        enabled = function()
          local disabled = false
          disabled = disabled or (RUtils.cmd.get_option "buftype" == "prompt")
          disabled = disabled or (RUtils.cmd.get_option "buftype" == "terminal")
          disabled = disabled or (RUtils.cmd.get_option "filetype" == "")
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          return not disabled
        end,
        window = {
          completion = cmp.config.window.bordered {
            winhighlight = "Normal:Pmenu,FloatBorder:CmpItemFloatBorder,CursorLine:PmenuSel,Search:None",
            col_offset = -4, -- To fit `lspkind` icon
            side_padding = 1, -- One character margin
            scrolloff = 0,
            scrollbar = true,
            border = {
              { "󱐋", "CmpItemIconWarningMsg" },
              { "─", "CmpItemFloatBorder" },
              { "╮", "CmpItemFloatBorder" },
              { "│", "CmpItemFloatBorder" },
              { "╯", "CmpItemFloatBorder" },
              { "─", "CmpItemFloatBorder" },
              { "╰", "CmpItemFloatBorder" },
              { "│", "CmpItemFloatBorder" },
            },
          },
          documentation = cmp.config.window.bordered {
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocFloatBorder,CursorLine:PmenuSel,Search:None",
            border = {
              { "", "DiagnosticHint" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
          },
        },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          buffer = 1,
          rg = 1,
          path = 1,
        },
        experimental = {
          -- only show ghost text when we show ai completions
          ghost_text = vim.g.ai_cmp and {
            hl_group = "CmpGhostText",
          } or false,
        },
        performance = {
          debounce = 0, -- default is 60ms
          throttle = 0, -- default is 30ms
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local label_width = 50
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, label_width)

            if truncated_label ~= label then
              item.abbr = truncated_label .. "…"
            elseif string.len(label) < label_width then
              local padding = string.rep(" ", label_width - string.len(label))
              item.abbr = label .. padding
            end

            -- To check `print(entry.source.name)`
            local item_kind = item.kind
            if item_kind == nil then -- Remove duplicate
              return {}
            end

            item.menu = item_kind
              .. " "
              .. (
                ({
                  obsidian = "[OBSIDIAN]",
                  obsidian_new = "[OBSIDIAN]",
                  nvim_lua = "[LUA]",
                  emoji = "[EMOJI]",
                  path = "[PATH]",
                  neorg = "[NEORG]",
                  dictionary = "[DIC]",
                  noice_popupmenu = "[Noice]",

                  spell = "[SPELL]",
                  orgmode = "[ORG]",
                  norg = "[NORG]",
                  rg = "[RG]",
                  git = "[GIT]",
                })[entry.source.name] or ""
              )

            local hlkind = ("CmpItemKind%s"):format(item_kind)
            item.menu_hl_group = hlkind

            local kind = RUtils.config.icons.kinds
            if kind[item.kind] then
              item.kind = kind[item.kind]
            end

            local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
            if completion_context ~= nil and completion_context ~= "" then
              item.menu = item.menu .. completion_context
            end

            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        view = {
          entries = {
            follow_cursor = false,
          },
        },
        sorting = defaults.sorting,
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          -- ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
          ["<C-y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        },
        sources = {
          {
            name = "nvim_lsp",
            priority = 100,
            group_index = 1,
          },
          -- { name = "path", priority = 10, group_index = 9 },
          { name = "async_path", priority = 30, group_index = 5 },
          {
            name = "emoji",
            priority = 10,
            group_index = 9,
            entry_filter = function()
              if vim.bo.filetype ~= "gitcommit" then
                return false
              end
              return true
            end,
          },
          {
            name = "git",
            priority = 40,
            group_index = 4,
            entry_filter = function()
              if vim.bo.filetype ~= "gitcommit" then
                return false
              end
              return true
            end,
          },
          {
            name = "orgmode",
            priority = 40,
            group_index = 4,
            entry_filter = function()
              if vim.bo.filetype ~= "org" then
                return false
              end
              return true
            end,
          },
          { name = "vim-dadbod-completion" },
          {
            name = "buffer",
            max_item_count = 5,
            keyword_length = 2,
            priority = 50,
            group_index = 4,
            option = {
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  return vim.fn.buflisted(buf) == 1 and vim.fn.bufloaded(buf) == 1
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      }
    end,
    main = "r.utils.cmp",
  },
  -- Add lazydev source for cmp
  {
    "iguanacucumber/magazine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sources, { name = "lazydev", group_index = 0 })
    end,
  },
}
