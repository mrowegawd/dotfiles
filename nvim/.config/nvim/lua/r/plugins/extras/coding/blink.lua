vim.g.lazyvim_blink_main = true

return {
  {
    "iguanacucumber/magazine.nvim",
    optional = true,
    enabled = false,
  },
  -- BLINK
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
      "disable_ft",
    },
    dependencies = {
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
    event = "InsertEnter",
    opts = {
      -- custom props to disable blink in certain filetypes
      disable_ft = { "prompt", "TelescopePrompt" },
      snippets = {
        expand = function(snippet, _)
          return RUtils.cmp.expand(snippet)
        end,
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        kind_icons = RUtils.config.icons.kinds,
      },
      completion = {
        list = {
          selection = {
            -- preselect = function(ctx)
            --   return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
            -- end,
            preselect = false,
            auto_insert = false,
          },
        },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "single",
          winhighlight = "Normal:Pmenu,FloatBorder:CmpItemFloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "kind", "source_name", gap = 1 } },
            components = {
              kind = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  return ("(%s)"):format(ctx.kind)
                end,
                highlight = function(ctx)
                  return (require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx) or "BlinkCmpKind")
                    .. ctx.kind
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "single",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocFloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        -- NOTE: sementara di disable dahulu dengan set empty table
        cmdline = {},
        -- cmdline = function()
        --   local type = vim.fn.getcmdtype()
        --   -- Search forward and backward
        --   if type == "/" or type == "?" then
        --     return {}
        --     -- This shows buffer completions in search but i hate it
        --     -- return {"Buffer"}
        --   end
        --   -- Commands
        --   if type == ":" then
        --     return { "cmdline" }
        --   end
        --   return {}
        -- end,
      },
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-r>"] = { "show", "hide", "fallback" }, -- trigger completion

        ["<cr>"] = { "fallback" },

        ["<C-n>"] = { "show", "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },

        -- ["<C-t>"] = { "show_documentation", "hide_documentation", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
    },

    config = function(_, opts)
      -- setup compat sources
      -- local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(opts.sources.default) == "table" and not vim.tbl_contains(opts.sources.default, source) then
          table.insert(opts.sources.default, source)
        end
      end

      local disabled_filetypes = opts.disable_ft or {}
      opts.enabled = function()
        -- NOTE: ketika menggunakan `hawtkeys` terjadi error pada completion
        -- codemium, cara dibawah ini untuk mengatasi masalah tersebut
        if vim.bo.buftype == "nofile" and vim.bo.filetype == "" then
          return false
        end

        -- will use to disable completions on certain filetypes
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      end

      -- add ai_accept to <Tab> key
      if not opts.keymap["<Tab>"] then
        if opts.keymap.preset == "super-tab" then -- super-tab
          opts.keymap["<Tab>"] = {
            require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
            RUtils.cmp.map { "snippet_forward", "ai_accept" },
            "fallback",
          }
        else -- other presets
          opts.keymap["<Tab>"] = {
            RUtils.cmp.map { "snippet_forward", "ai_accept" },
            "fallback",
          }
        end
      end

      ---  NOTE: compat with latest version. Currenlty 0.7.6
      if not vim.g.lazyvim_blink_main then
        ---@diagnostic disable-next-line: inject-field
        opts.sources.completion = opts.sources.completion or {}
        opts.sources.completion.enabled_providers = enabled
        if vim.tbl_get(opts, "completion", "menu", "draw", "treesitter") then
          ---@diagnostic disable-next-line: assign-type-mismatch
          opts.completion.menu.draw.treesitter = true
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil
      opts.disable_ft = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
  -- add blink icons
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("keep", {
        Color = "██", -- Use block instead of icon for color items to make swatches more usable
      }, RUtils.config.icons.kinds)
    end,
  },

  -- Add lazydev source for blink
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
}
