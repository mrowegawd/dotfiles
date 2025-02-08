vim.g.lazyvim_blink_main = false

-- local source_priority = {
--   lsp = 4,
--   snippets = 3,
--   path = 2,
--   buffer = 5,
--   cmdline = 1,
--   codeium = 1,
-- }

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
      disable_ft = { "prompt", "TelescopePrompt", "snacks_picker_input" },
      snippets = {
        expand = function(snippet, _)
          return RUtils.cmp.expand(snippet)
        end,
      },
      appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "mono" },
      completion = {
        keyword = { range = "full" },
        accept = { auto_brackets = { enabled = true } },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
            end,
            auto_insert = true,
          },
        },
        menu = {
          border = "single",
          winhighlight = "Normal:Pmenu,FloatBorder:CmpItemFloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            --   columns = { { "kind_icon" }, { "label", "kind", "source_name", gap = 1 } },
            --   components = {
            --     kind = {
            --       ellipsis = false,
            --       width = { fill = true },
            --       text = function(ctx)
            --         return ("(%s)"):format(ctx.kind)
            --       end,
            --       highlight = function(ctx)
            --         return (require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx) or "BlinkCmpKind")
            --           .. ctx.kind
            --       end,
            --     },
            --   },
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
          -- NOTE: spam error from codeium completion
          -- relate issue https://github.com/Exafunction/codeium.nvim/pull/264#issuecomment-2583615777
          -- jadi disable sementara dahulu
          enabled = false,
        },
      },
      -- fuzzy = {
      --   -- NOTE: source priority?
      --   -- https://github.com/Saghen/blink.cmp/issues/1098#issuecomment-2619750942
      --   sorts = {
      --     function(a, b)
      --       print()
      --       return source_priority[a.source_id] > source_priority[b.source_id]
      --     end,
      --     -- defaults
      --     "score",
      --     "sort_text",
      --   },
      -- },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
        end,
        -- providers = {
        --   -- lsp = {
        --   --   ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[])
        --   --   transform_items = function(ctx, items)
        --   --     ---@diagnostic disable-next-line: redundant-return-value
        --   --     return vim.tbl_filter(function(item)
        --   --       local c = ctx.get_cursor()
        --   --       local cursor_line = ctx.line
        --   --       local cursor = {
        --   --         row = c[1],
        --   --         col = c[2] + 1,
        --   --         line = c[1] - 1,
        --   --       }
        --   --
        --   --       RUtils.vlog.log.info(vim.inspect(item))
        --   --       print "hasdf"
        --   --
        --   --       local cursor_before_line = string.sub(cursor_line, 1, cursor.col - 1)
        --   --       -- remove text
        --   --       if item.kind == vim.lsp.protocol.CompletionItemKind.Text then
        --   --         return false
        --   --       end
        --   --
        --   --       if vim.bo.filetype == "vue" then
        --   --         -- For events
        --   --         if cursor_before_line:match "(@[%w]*)%s*$" ~= nil then
        --   --           return item.label:match "^@" ~= nil
        --   --         -- For props also exclude events with `:on-` prefix
        --   --         elseif cursor_before_line:match "(:[%w]*)%s*$" ~= nil then
        --   --           return item.label:match "^:" ~= nil and not item.label:match "^:on%-" ~= nil
        --   --         -- For slot
        --   --         elseif cursor_before_line:match "(#[%w]*)%s*$" ~= nil then
        --   --           return item.kind == vim.lsp.protocol.CompletionItemKind.Method
        --   --         end
        --   --       end
        --   --
        --   --       return true
        --   --     end, items)
        --   --   end,
        --   -- },
        --   -- snippets = {
        --   --   min_keyword_length = 1,
        --   --   score_offset = 4,
        --   -- },
        --   -- -- lsp = {
        --   -- --   min_keyword_length = 0,
        --   -- --   score_offset = 3,
        --   -- --   name = "LSP",
        --   -- --   module = "blink.cmp.sources.lsp",
        --   -- --   fallbacks = {},
        --   -- -- },
        --   -- path = {
        --   --   min_keyword_length = 0,
        --   --   score_offset = 2,
        --   -- },
        --   -- buffer = {
        --   --   min_keyword_length = 1,
        --   --   score_offset = 1,
        --   -- },
        -- },
      },
      signature = {
        enabled = true,
        window = { border = "rounded", winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocFloatBorder" },
      },
      keymap = {
        preset = "enter",
        -- how to disable keymap? -> ["<C-e>"] = {},
        ["<C-y>"] = { "select_and_accept" },
        ["<CR>"] = { "accept", "fallback" },

        ["<C-n>"] = {
          function(cmp)
            if not cmp.is_visible() then
              cmp.show()
            else
              cmp.select_next()
            end
          end,
        },
        ["<C-p>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_prev()
            end
          end,
        },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        cmdline = {
          --   -- NOTE: issue terkait
          --   -- https://github.com/Saghen/blink.cmp/issues/1092
          --   -- https://github.com/Saghen/blink.cmp/issues/1117
          --   -- ["<C-y>"] = {
          --   --   function(cmp)
          --   --     --     -- local type = vim.fn.getcmdtype()
          --   --     --     -- print(type)
          --   --     --     -- local mode = vim.fn.mode(1):sub(1, 1)
          --   --     --     -- print(mode)
          --   --     --
          --   --     -- local function get_cursor()
          --   --     --   return { 1, vim.fn.getcmdpos() - 1 } or vim.api.nvim_win_get_cursor(0)
          --   --     -- end
          --   --     -- local p = get_cursor()
          --   --     -- print(vim.inspect(p))
          --   --
          --   --     local get_mode = function()
          --   --       local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
          --   --       if mode == "i" then
          --   --         return "i" -- insert
          --   --       elseif mode == "v" or mode == "V" or mode == CTRL_V then
          --   --         return "x" -- visual
          --   --       elseif mode == "s" or mode == "S" or mode == CTRL_S then
          --   --         return "s" -- select
          --   --       elseif mode == "c" and vim.fn.getcmdtype() ~= "=" then
          --   --         return "c" -- cmdline
          --   --       end
          --   --     end
          --   --
          --   --     local is_cmdline_mode = function()
          --   --       return get_mode() == "c"
          --   --     end
          --   --
          --   --     local get_cursor = function()
          --   --       if is_cmdline_mode() then
          --   --         return {
          --   --           math.min(vim.o.lines, vim.o.lines - (vim.api.nvim_get_option_value("cmdheight", {}) - 1)),
          --   --           vim.fn.getcmdpos() - 1,
          --   --         }
          --   --       end
          --   --       return vim.api.nvim_win_get_cursor(0)
          --   --     end
          --   --
          --   --     local j = get_cursor()[2]
          --   --
          --   --     if j > 1 then
          --   --       print(j)
          --   --       cmp.accept()
          --   --       --   --       -- print(vim.fn.setcmdpos(cursor[2]))
          --   --       --   print "mantap"
          --   --       --
          --   --       --       -- if cmp.is_visible() then
          --   --       --       --
          --   --       --
          --   --       --       -- local completion_list = require "blink.cmp.completion.list"
          --   --       --       -- local item = opts.index ~= nil and completion_list.items[opts.index]
          --   --       --       --   or completion_list.get_selected_item()
          --   --       --       -- if item == nil then
          --   --       --       --   return
          --   --       --       -- end
          --   --       --       --
          --   --       --       -- vim.schedule(function()
          --   --       --       --   completion_list.accept(opts)
          --   --       --       -- end)
          --   --       --
          --   --       --       -- cmp.accept()
          --   --       --       vim.schedule(function()
          --   --       --         local completion_list = require "blink.cmp.completion.list"
          --   --       --         completion_list.accept {
          --   --       --           index = 1,
          --   --       --           callback = function()
          --   --       --             vim.fn.setcmdpos(p[2])
          --   --       --           end,
          --   --       --         }
          --   --       --       end)
          --   --       --       return true
          --   --       --       -- end
          --   --     end
          --   --   end,
          --   -- },
          --
          ["<C-y>"] = {
            "select_and_accept",
            -- function(cmp)
            --   if cmp.is_visible() then
            --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
            --   end
            -- end,
          },
          ["<C-n>"] = {
            "select_next",
            "fallback",
            --   function(cmp)
            --     if cmp.is_visible() then
            --       local type = vim.fn.getcmdtype()
            --       if type == "/" or type == "?" then
            --         return cmp.select_next { auto_insert = true }
            --       end
            --       return cmp.select_next { auto_insert = true }
            --     else
            --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Down>", true, true, true), "n", true)
            --     end
            --   end,
          },
          ["<C-p>"] = {
            "select_prev",
            "fallback",
            --   function(cmp)
            --     if cmp.is_visible() then
            --       local type = vim.fn.getcmdtype()
            --       if type == "/" or type == "?" then
            --         return cmp.select_prev { auto_insert = true }
            --       end
            --       return cmp.select_prev { auto_insert = true }
            --     else
            --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Up>", true, true, true), "n", true)
            --     end
            --   end,
          },
          -- ["<C-p>"] = { "select_prev", "fallback" },
          --   ["<C-c>"] = {
          --     "hide",
          --     "cancel",
          --     function()
          --       if vim.fn.getcmdtype() ~= "" then
          --         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
          --       end
          --     end,
          --   },
          ["<CR>"] = {
            function()
              if vim.api.nvim_get_mode().mode == "c" then
                local type = vim.fn.getcmdtype()
                -- if type == "/" or type == "?" then
                if type == ":" then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Space>", true, false, true), "i", true)
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
                  return
                end
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
              end
            end,
          },
        },
      },
    },

    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      local disabled_filetypes = opts.disable_ft or {}
      opts.enabled = function()
        -- NOTE: when using `hawtkeys`, there is an error with codeium completion
        -- and the method below is used to address this issue
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
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, RUtils.config.icons.kinds)
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
