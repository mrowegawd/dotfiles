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
    event = { "InsertEnter", "CmdlineEnter" },
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
      "disable_ft",
    },
    build = function()
      require("blink.cmp").build():pwait()
    end,
    dependencies = {
      "saghen/blink.lib",
      "saghen/blink.compat",
      "mikavilpas/blink-ripgrep.nvim",
      "Kaiser-Yang/blink-cmp-git",
      { "MattiasMTS/cmp-dbee", branch = "ms/v2" },
    },
    opts = {
      -- custom props to disable blink in certain filetypes
      disable_ft = { "prompt", "TelescopePrompt", "snacks_picker_input", "org-roam-select", "qfbookmark" },
      snippets = {
        expand = function(snippet, _)
          return RUtils.cmp.expand(snippet)
        end,
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
          border = "none",
          winhighlight = "Normal:Pmenu,FloatBorder:PmenuFloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label" },
              { "source_name" },
            },
            components = {
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
              kind_icon = {
                text = function(ctx)
                  if ctx.source_name == "Cmdline" then
                    return ""
                  end

                  local kind = ""

                  if ctx.kind == "Color" then
                    return "██"
                  end

                  if ctx.kind == "Commit" then
                    kind = RUtils.config.icons.git.unmerged
                  else
                    kind = RUtils.config.icons.kinds[ctx.kind] or ""
                  end

                  return " " .. RUtils.strip_whitespaces(kind) .. " "
                end,
                highlight = function(ctx)
                  if ctx.deprecated then
                    return "BlinkCmpLabelDeprecated"
                  end

                  if ctx.kind == "Text" then
                    return ""
                  end

                  return "LspKind" .. ctx.kind
                end,
              },
              source_name = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  local map = {
                    buffer = "[Buffer]",
                    codecompanion = "[CodeCompanion]",
                    copilot = "[Copilot]",
                    dbee = "[dbee]",
                    emoji = "[Emoji]",
                    git = "[Git]",
                    lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    path = "[Path]",
                    tmux = "[Tmux]",
                  }
                  return map[ctx.source_id]
                    or map[ctx.source_name]
                    or ("[" .. (ctx.source_name or ctx.source_id or "?") .. "]")
                end,
                highlight = function(item)
                  if item.deprecated then
                    return "BlinkCmpLabelDeprecated"
                  end
                  if item.kind == "Color" then
                    return item.kind_hl
                  end
                  return "BlinkCmpLabelKind"
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = RUtils.config.icons.border.rightsideonly, -- "none",
            winhighlight = "Normal:BlinkDocNormal,FloatBorder:BlinkDocFloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        ghost_text = {
          enabled = false,
        },
      },
      cmdline = {
        completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
        keymap = {
          preset = "none",
          ["<Right>"] = false,
          ["<Left>"] = false,

          ["<C-y>"] = { "select_and_accept" },

          ["<C-j>"] = {
            function()
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return RUtils.map.feedkey "<C-Down>"
              end
              if type == ":" or type == "@" then
                return RUtils.map.feedkey "<C-Down>"
              end
            end,
          },
          ["<C-k>"] = {
            function()
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return RUtils.map.feedkey "<C-Up>"
              end
              if type == ":" or type == "@" then
                return RUtils.map.feedkey "<C-Up>"
              end
            end,
          },
          ["<C-n>"] = {
            function(cmp)
              if not cmp.is_visible() then
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                  return RUtils.map.feedkey "<C-Down>"
                end
                if type == ":" or type == "@" then
                  return RUtils.map.feedkey "<C-Down>"
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
                  return RUtils.map.feedkey "<C-Up>"
                end
                if type == ":" or type == "@" then
                  return RUtils.map.feedkey "<C-Up>"
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
          ["<C-q>"] = {
            "hide",
            "cancel",
            function()
              if vim.fn.getcmdtype() ~= "" then
                return RUtils.map.feedkey "<C-c>"
              end
            end,
          },
        },
      },
      sources = {
        compat = {},
        default = function()
          local sources = { "lsp", "path", "snippets", "buffer" }

          -- Workaround for git source not supporting per_filetype configuration
          -- https://github.com/Kaiser-Yang/blink-cmp-git/issues/62#issuecomment-3062425218
          if vim.tbl_contains({ "gitcommit", "octo" }, vim.bo.filetype) then
            sources = { "buffer", "git" }
          end
          return sources
        end,

        providers = {
          lsp = {
            name = "lsp",
            module = "blink.cmp.sources.lsp",
            fallbacks = {},
            score_offset = 5,
            transform_items = function(_, items)
              local cmp_kind = require("blink.cmp.types").CompletionItemKind
              return vim.tbl_filter(function(item)
                return item.kind ~= cmp_kind.Text and item.kind ~= cmp_kind.Snippet
              end, items)
            end,
          },
          snippets = {
            score_offset = -5,
            opts = { search_paths = { RUtils.config.path.dropbox_path .. "/snippets-for-all" } },
          },
          path = {
            score_offset = -3,
            opts = { show_hidden_files_by_default = true },
          },
          buffer = {
            score_offset = -10,
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
          git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit" }, vim.bo.filetype)
            end,
          },
          ripgrep = {
            name = "RG",
            module = "blink-ripgrep",
            score_offset = -10,
            opts = {
              project_root_marker = { "package.json", ".git" },
              backend = {
                use = "gitgrep-or-ripgrep",
              },
            },
          },
        },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      fuzzy = { implementation = "rust" },
      -- fuzzy = {
      --   -- implementation = "rust",
      --   sorts = {
      --     "exact",
      --     "score",
      --     "sort_text",
      --   },
      -- },
      keymap = {
        preset = "none", -- 'enter', 'none' -> (disable all mappings)
        -- How to disable keymap? -> ["<C-e>"] = {},
        ["<C-y>"] = { "select_and_accept" },

        ["<C-f>"] = {},
        ["<C-e>"] = {},
        ["<C-b>"] = {},

        ["<C-g>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_next()
            end
            return cmp.show { providers = { "ripgrep" } }
          end,
        },

        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<C-r>"] = {
          function(cmp)
            local current_provider = providers[idx]

            if current_provider == "codeium" and vim.tbl_contains({ "org" }, vim.bo[0].filetype) then
              idx = idx + 1
              current_provider = providers[idx]
            end

            cmp.show { providers = { current_provider } }

            idx = (idx % #providers) + 1
          end,
        },
        ["<C-q>"] = { "hide" },
        ["<C-n>"] = {
          function(cmp)
            if vim.bo.filetype == "org-roam-select" then
              cmp.hide {}
              local fallback = require("blink.cmp.keymap.fallback").wrap("i", "<Down>")
              return fallback()
            end

            if not cmp.is_visible() then
              cmp.show {}
            else
              cmp.select_next()
            end
          end,
        },
        ["<C-p>"] = {
          function(cmp)
            if vim.bo.filetype == "org-roam-select" then
              cmp.hide {}
              local fallback = require("blink.cmp.keymap.fallback").wrap("i", "<Up>")
              return fallback()
            end

            if cmp.is_visible() then
              cmp.select_prev()
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
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
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

  -- blink.pairs - auto close and color brackets (disabled, too slow!)
  {
    "saghen/blink.pairs",
    enabled = false,
    version = "*", -- (recommended) only required with prebuilt binaries
    event = { "BufReadPre", "BufNewFile" },
    -- download prebuilt binaries from github releases
    dependencies = "saghen/blink.download",
    -- OR build from source, requires nightly:
    -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable()
        -- and require("blink.pairs.mappings").disable()
        -- to enable/disable mappings at runtime
        enabled = true,
        cmdline = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {},
        -- see the defaults:
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
        pairs = {},
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        groups = {
          "BlinkPairsOrange",
          "BlinkPairsPurple",
          "BlinkPairsBlue",
        },
        unmatched_group = "BlinkPairsUnmatched",

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = "BlinkPairsMatchParen",
          priority = 250,
        },
      },
      debug = false,
    },
  },
}
