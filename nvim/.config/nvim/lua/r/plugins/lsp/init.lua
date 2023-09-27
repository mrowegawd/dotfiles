if not as.use_lsp_native then
  return {}
end

local border = as.ui.border.rectangle
local icons = as.ui.icons
local fmt = string.format

local callme = 0

local uv = vim.uv or vim.loop

return {
  -- GOTO-PREVIEW (disabled)
  { "rmagatti/goto-preview", config = true },
  -- LSPKIND
  { "onsails/lspkind.nvim" },
  -- MASON NVIM
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "shfmt" },
      ui = { border = as.ui.border.rectangle, height = 0.8 },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- LSP stuff
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- CMP
      "hrsh7th/nvim-cmp",

      -- CMP plugins
      "davidsierradz/cmp-conventionalcommits",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-under-comparator",
      "rcarriga/cmp-dap",
      "saadparwaiz1/cmp_luasnip",

      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "js-everts/cmp-tailwind-colors", -- Support cmp color for tailwind
      { "saecki/crates.nvim", event = { "BufRead Cargo.toml" }, config = true }, -- for rust, creates

      "L3MON4D3/LuaSnip",
    },
    opts = {
      -- add any global capabilities here
      -- capabilities = {},
      format = {
        timeout_ms = nil,
      },
      -- LSP Server Settings
      servers = {
        dockerls = {},
      },
      setup = {},
    },
    config = function(plugin, opts)
      require("r.plugins.lsp.servers").setup(plugin, opts)

      local cmp = require "cmp"
      local has_luasnip, luasnip = pcall(require, "luasnip")
      local types = require "cmp.types"

      -- Based on (private) function in LuaSnip/lua/luasnip/init.lua.
      local in_snippet = function()
        local session = require "luasnip.session"
        local node = session.current_nodes[vim.api.nvim_get_current_buf()]
        if not node then
          return false
        end
        local snippet = node.parent.snippet
        local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
        local pos = vim.api.nvim_win_get_cursor(0)
        if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
          return true
        end
      end

      local check_backspace = function()
        local col = vim.fn.col "." - 1
        ---@diagnostic disable-next-line: param-type-mismatch
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
      end

      local cmp_opts = {
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        window = {
          completion = {
            border = border, --single
            scrollbar = "║",
            col_offset = -1,
            winhighlight = "Normal:Normal,FloatBorder:FzfLuaBorder,CursorLine:PmenuSel,Search:None",
            -- side_padding = -1,
          },
          documentation = {
            border = border, -- "shadow", "rounded"
            winhighlight = "Normal:Normal,FloatBorder:FzfLuaBorder,Search:None",
            scrollbar = "║",
          },
        },

        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<c-n>"] = cmp.mapping(function()
            local c_cmp = require "cmp"
            if c_cmp.visible() then
              c_cmp.select_next_item()
            else
              require("cmp").complete()
            end
          end, { "i", "s" }),
          ["<c-p>"] = cmp.mapping(function(fallback)
            local c_cmp = require "cmp"
            if c_cmp.visible() then
              c_cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<TAB>"] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(function(fallback)
            if has_luasnip and in_snippet() and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-l>"] = cmp.mapping.confirm { select = false },
          ["<cr>"] = cmp.mapping.confirm { select = false },
          ["<C-space>"] = cmp.mapping(function(_)
            local c_cmp = require "cmp"
            -- if c_cmp.visible() then
            --   c_cmp.abort()
            if callme == 0 then
              callme = 1
              c_cmp.complete {
                config = {
                  sources = {
                    { name = "luasnip" },
                  },
                },
              }
            elseif callme == 1 then
              callme = 2
              cmp.complete {
                config = {
                  sources = {
                    {
                      name = "buffer",
                      option = {
                        get_bufnrs = function()
                          return vim.api.nvim_list_bufs()
                        end,
                      },
                    },
                  },
                },
              }
            else
              if callme == 2 then
                callme = 0
                cmp.complete {
                  config = {
                    sources = {
                      { name = "nvim_lsp" },
                    },
                  },
                }
              end
            end
          end, {
            "i",
            "s",
          }),
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            function(entry1, entry2)
              local kind1 = entry1:get_kind()
              kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
              local kind2 = entry2:get_kind()
              kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
              if kind1 ~= kind2 then
                if kind1 == types.lsp.CompletionItemKind.Snippet then
                  return false
                end
                if kind2 == types.lsp.CompletionItemKind.Snippet then
                  return true
                end
                local diff = kind1 - kind2
                if diff < 0 then
                  return true
                elseif diff > 0 then
                  return false
                end
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },

          format = function(entry, vim_item)
            local MAX = math.floor(vim.o.columns * 0.5)
            if #vim_item.abbr >= MAX then
              vim_item.abbr = vim_item.abbr:sub(1, MAX) .. icons.misc.ellipsis
            end

            local item = entry:get_completion_item()
            if item.detail then
              vim_item.menu = item.detail
            end

            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              emoji = "[Emoji]",
              path = "[Path]",
              neorg = "[Neorg]",
              luasnip = "[Snip]",
              dictionary = "[Dict]",
              treesitter = "串",
              buffer = "[Buffer]",
              spell = "[Spell]",
              cmdline = "[Cmd]",
              cmdline_history = "[Hist]",
              orgmode = "[Org]",
              rg = "[Rg]",
              git = "[Git]",
            })[entry.source.name]

            vim_item.kind = fmt("%s  %s", icons.kind[vim_item.kind], vim_item.kind)

            if string.find(vim_item.kind, "Color") then
              vim_item.kind = "Color"
              local tailwind_item = require("cmp-tailwind-colors").format(entry, vim_item)
              vim_item.menu = "[Color]"
              vim_item.kind = " " .. tailwind_item.kind
            end

            -- remove duplicates
            vim_item.dup = ({
              buffer = 1,
              path = 1,
              nvim_lsp = 0,
            })[entry.source.name] or 0

            return vim_item
          end,
        },
        -- experimental = {
        --     ghost_text = {
        --         hl_group = "LspCodeLens",
        --     },
        -- },
        sources = cmp.config.sources {
          {
            name = "nvim_lsp",
            -- Remove snippet from lsp, use luasnip instead
            ---@diagnostic disable-next-line: unused-local
            entry_filter = function(entry, ctx)
              if entry:get_kind() == 15 then
                return false
              end
              return true
            end,
            -- group_index = 1,
          },
          { name = "luasnip" },
          {
            name = "buffer",
            option = {
              keyword_pattern = [[\k\+]],
              -- Enable completion from all visible buffers
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
          { name = "path" },
          { name = "neorg" },
          -- { name = "nvim_lsp_signature_help" },
          { name = "crates" },
        },
      }

      cmp.setup(cmp_opts)

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "emoji" },
          { name = "luasnip" },
          { name = "path" },
          -- { name = "spell", group_index = 2 },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.filetype("norg", {
        sources = cmp.config.sources({
          { name = "neorg" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.filetype("org", {
        sources = cmp.config.sources({
          { name = "orgmode" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.filetype({ "gitcommit", "NeogitPopup" }, {
        sources = cmp.config.sources {
          { name = "path" },
          { name = "emoji" },
          { name = "buffer" },
        },
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
        }, {
          { name = "buffer" },
        }),
      })
      cmp.setup.cmdline(":", {
        mapping = {
          ["<esc>"] = {
            c = function()
              require("r.utils").feedkey("<c-c>", "n")
            end,
          },
          ["<c-q>"] = {
            c = function(fallback)
              if require("cmp").visible() then
                require("cmp").abort()
              else
                fallback()
              end
            end,
          },
          ["<TAB>"] = {
            c = function()
              if require("cmp").visible() then
                require("cmp").select_next_item()
              else
                require("cmp").complete()
              end
            end,
          },
          ["<S-TAB>"] = {
            c = function(fallback)
              if require("cmp").visible() then
                require("cmp").select_prev_item()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources({
          { name = "path" },
        }, { { name = "cmdline" }, { { name = "cmdline_history" } } }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = {
          ["<esc>"] = {
            c = function()
              require("r.utils").feedkey("<c-c>", "n")
            end,
          },
          ["<c-q>"] = {
            c = function(fallback)
              if require("cmp").visible() then
                require("cmp").abort()
              else
                fallback()
              end
            end,
          },
          ["<TAB>"] = {
            c = function()
              if require("cmp").visible() then
                require("cmp").select_next_item()
              else
                require("cmp").complete()
              end
            end,
          },
          ["<S-TAB>"] = {
            c = function(fallback)
              if require("cmp").visible() then
                require("cmp").select_prev_item()
              else
                fallback()
              end
            end,
          },
        },
        sources = {
          { name = "buffer" },
        },
      })

      luasnip.config.setup {
        history = true,
        enable_autosnippets = true,
        -- Update more often, :h events for more info.
        -- updateevents = "TextChanged,TextChangedI",
      }

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = "~/Dropbox/friendly-snippets",
      }

      luasnip.filetype_extend("django-html", { "html" })
      luasnip.filetype_extend("htmldjango", { "html" })
      luasnip.filetype_extend("javascript", { "html" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html" })
      luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- NVIM-LINT
  {
    "mfussenegger/nvim-lint",
    event = "VimEnter",
    opts = {
      linters_by_ft = {
        ["javascript.jsx"] = { "eslint_d" },
        ["typescript.tsx"] = { "eslint_d" },
        go = { "golangcilint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        lua = { "selene" },
        python = { "mypy", "pylint" },
        rst = { "rstlint" },
        sh = { "shellcheck" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vim = { "vint" },
        yaml = { "yamllint" },
      },
      linters = {},
    },
    config = function(_, opts)
      local lint = require "lint"
      lint.linters_by_ft = opts.linters_by_ft
      for k, v in pairs(opts.linters) do
        lint.linters[k] = v
      end
      local timer = assert(uv.new_timer())
      local DEBOUNCE_MS = 500
      local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = aug,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          timer:stop()
          timer:start(
            DEBOUNCE_MS,
            0,
            vim.schedule_wrap(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                  lint.try_lint(nil, { ignore_errors = true })
                end)
              end
            end)
          )
        end,
      })
      lint.try_lint(nil, { ignore_errors = true })
    end,
  },
}
