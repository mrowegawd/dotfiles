vim.g.lazyvim_blink_main = true

local providers = { "lsp", "snippets", "buffer" } -- remove codeium
local idx = 1

return {
  {
    "iguanacucumber/magazine.nvim",
    optional = true,
    enabled = false,
  },
  -- BLINK
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
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
      {
        "Kaiser-Yang/blink-cmp-git",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    opts = {
      -- custom props to disable blink in certain filetypes
      disable_ft = { "prompt", "TelescopePrompt", "snacks_picker_input" },
      snippets = {
        expand = function(snippet, _)
          return RUtils.cmp.expand(snippet)
        end,
      },
      appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "mono" },
      fuzzy = {
        implementation = "rust",
        sorts = {
          "exact",
          "score",
          "sort_text",
        },
      },
      completion = {
        keyword = { range = "full" },
        accept = { auto_brackets = { enabled = true } },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode == "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
            end,
            auto_insert = function(ctx)
              return ctx.mode == "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
            end,
          },
        },
        menu = {
          border = RUtils.config.icons.border.line,
          winhighlight = "Normal:Pmenu,FloatBorder:CmpItemFloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            -- columns = { { "kind_icon" }, { "label", "kind", "source_name", gap = 1 } },
            columns = { { "kind_icon" }, { "label", "kind", gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  return (" " .. RUtils.cmd.strip_whitespace(RUtils.config.icons.kinds[ctx.kind]) .. " ") or ""
                end,
                highlight = function(ctx)
                  if ctx.deprecated then
                    return "BlinkCmpLabelDeprecated"
                  end
                  return "CmpItemKind" .. ctx.kind
                end,
              },
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  if ctx.kind == "Snippet" then
                    return ctx.item.label .. "_" -- add suffix `_` for snippet kind
                  end
                  return ctx.label
                end,
                highlight = function(ctx)
                  -- https://github.com/saghen/blink.cmp/blob/033fbcc7ec55546aa0c3889aa50b6e76915c3f62/doc/configuration/reference.md#completion-menu-draw
                  local highlights = {
                    {
                      0,
                      #ctx.label,
                      group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "LspKind" .. ctx.kind,
                    },
                  }

                  if ctx.label_detail then
                    table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = "Comment" })
                  end

                  for _, item_idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { item_idx, item_idx + 1, group = "BlinkCmpLabelMatch" })
                  end

                  return highlights
                end,
              },
              kind = {
                ellipsis = false,
                width = { fill = true },
                text = function(item)
                  if item.kind == "Color" then
                    return "██"
                  end
                  return ("(%s)"):format(item.kind)
                end,
                highlight = function(item)
                  if item.deprecated then
                    return "BlinkCmpLabelDeprecated"
                  end
                  if item.kind == "Color" then
                    return item.kind_hl
                  end
                  return "LspKind" .. item.kind
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = RUtils.config.icons.border.line,
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocFloatBorder,CursorLine:PmenuSel,Search:None",
          },
          -- draw = function(opts)
          --   opts.default_implementation()
          --   RUtils.lsp.highlight_doc_patterns(opts.window.buf)
          --   local win_id = opts.window:get_win()
          --   if win_id then
          --     require("render-markdown.core.ui").update(opts.window.buf, win_id, "BlinkDraw", true)
          --   end
          -- end,
        },
        ghost_text = {
          enabled = false,
        },
      },
      cmdline = {
        completion = { menu = { auto_show = true } },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" or type == "@" then
            return { "cmdline", "path" }
          end
          return {}
        end,
        keymap = {
          preset = "none",
          ["<C-y>"] = { "select_and_accept" },

          ["<C-n>"] = {
            function(cmp)
              if not cmp.is_visible() then
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Down>", true, true, true), "n", true)
                end
                if type == ":" or type == "@" then
                  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Down>", true, true, true), "n", true)
                end
              else
                cmp.select_next()
              end
            end,
          },
          ["<C-p>"] = {
            function(cmp)
              if not cmp.is_visible() then
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Up>", true, true, true), "n", true)
                end
                if type == ":" or type == "@" then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Up>", true, true, true), "n", true)
                end
              else
                cmp.select_prev()
              end
            end,
          },
          ["<C-r>"] = {
            "hide",
            "cancel",
            "show",
          },
          ["<C-c>"] = {
            "hide",
            "cancel",
            function()
              if vim.fn.getcmdtype() ~= "" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
              end
            end,
          },
        },
      },
      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer", "git" },

        providers = {
          snippets = { opts = { search_paths = { RUtils.config.path.dropbox_path .. "/snippets-for-all" } } },
          path = { opts = { show_hidden_files_by_default = true } },
          buffer = {
            opts = {
              get_bufnrs = function()
                if vim.tbl_contains({ "/", "?", ":", "@" }, vim.fn.getcmdtype()) then
                  return vim.tbl_filter(function(bufnr)
                    return bufnr == vim.api.nvim_get_current_buf()
                  end, vim.api.nvim_list_bufs())
                end
                return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win)
                    return vim.api.nvim_win_get_buf(win)
                  end)
                  :filter(function(buf)
                    return vim.bo[buf].buftype ~= "nofile"
                  end)
                  :totable()
              end,
            },
          },
          lsp = {
            name = "lsp",
            module = "blink.cmp.sources.lsp",
            fallbacks = {},
            transform_items = function(_, items)
              local cmp_kind = require("blink.cmp.types").CompletionItemKind
              return vim.tbl_filter(function(item)
                -- Don't show lsp text and snippets
                return item.kind ~= cmp_kind.Text and item.kind ~= cmp_kind.Snippet
              end, items)
            end,
          },
          git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit" }, vim.bo.filetype)
            end,
          },
        },
      },
      signature = {
        enabled = true,
        window = { border = "rounded", winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocFloatBorder" },
      },
      keymap = {
        preset = "none", -- 'enter', 'none' -> (disable all mappings)

        -- How to disable keymap? -> ["<C-e>"] = {},
        ["<C-y>"] = { "select_and_accept" },

        -- I have to disable these mappings because they cause conflict errors
        -- ["<CR>"] = {},
        ["<C-f>"] = {},
        ["<C-e>"] = {},
        ["<C-b>"] = {},

        ["<C-r>"] = {
          function(cmp)
            local current_provider = providers[idx]

            if current_provider == "codeium" and vim.tbl_contains({ "org", "rgflow" }, vim.bo[0].filetype) then
              -- Jika filetype adalah 'org' atau 'rgflow', lewati 'codeium'
              idx = idx + 1
              current_provider = providers[idx]
            end

            cmp.show { providers = { current_provider } }

            -- Update idx untuk siklus nya
            idx = (idx % #providers) + 1
          end,
        },
        ["<C-n>"] = {
          function(cmp)
            if not cmp.is_visible() then
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Down>", true, true, true), "n", true)
              end
              if type == ":" or type == "@" then
                return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Down>", true, true, true), "n", true)
              end

              cmp.show {}
            else
              cmp.select_next()
            end
          end,
        },
        ["<C-p>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_prev()
            else
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Up>", true, true, true), "n", true)
              end
              if type == ":" or type == "@" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-Up>", true, true, true), "n", true)
              end
            end
          end,
        },
        ["<C-c>"] = {
          "hide",
          "cancel",
          function()
            if vim.fn.getcmdtype() ~= "" then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
            end
          end,
        },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
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
            require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
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
              item.kind_icon = RUtils.config.icons.kinds[item.kind_name] or item.kind_icon or nil
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
