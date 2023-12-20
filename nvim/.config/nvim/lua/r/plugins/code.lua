local Util = require "r.utils"

local highlight = require "r.config.highlights"

_G.OverseerConfig = {} -- to store error formats

OverseerConfig.fnpane_run = 0
OverseerConfig.fnpane_runtest = 0
OverseerConfig.fnpane_runmisc = 0

local callme = 0

local function get_cmp()
  local ok_cmp, cmp = pcall(require, "cmp")
  return ok_cmp and cmp or {}
end
local function get_luasnip()
  local ok_luasnip, luasnip = pcall(require, "luasnip")
  return ok_luasnip and luasnip or {}
end

return {
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    ---@diagnostic disable-next-line: undefined-global
    build = (not jit.os:find "Windows")
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function()
      local luasnip = require "luasnip"

      require("luasnip.loaders.from_vscode").lazy_load {
        paths = "~/Dropbox/friendly-snippets",
      }

      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("django-html", { "html" })
      luasnip.filetype_extend("htmldjango", { "html" })

      luasnip.filetype_extend("javascript", { "html" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html", "react" })

      -- luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    enabled = function()
      if require("r.config").lsp_style == "coc" then
        return false
      end
      return true
    end,
    event = "InsertEnter",
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-buffer",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-path",
      "FelipeLema/cmp-async-path",
      "hrsh7th/cmp-emoji",
      "petertriho/cmp-git",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          src = {
            cmp = { enabled = true },
          },
        },
      },
    },
    opts = function()
      local cmp = get_cmp()
      local luasnip = get_luasnip()
      -- local types = require "cmp.types"
      local defaults = require "cmp.config.default"()

      local source_buffer = {
        name = "buffer",
        option = {
          get_bufnrs = function()
            ---@diagnostic disable-next-line: unused-local
            local is_small_buf = function(index, buf)
              local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              return byte_size <= 1024 * 1024 -- 1 Megabyte max
            end
            local all_bufs = vim.api.nvim_list_bufs()
            return vim.fn.filter(all_bufs, is_small_buf)
          end,

          -- keyword_length =
          -- keyword_pattern =
          indexing_interval = 10,
          indexing_batch_size = 100,
          max_indexed_line_length = 1024,
        },
      }

      local function tab(fallback) -- make TAB behave like Android Studio
        local col = vim.fn.col "." - 1
        if require("luasnip").expand_or_jumpable() then -- force to check luasnip
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          -- elseif cmp.visible() then
          --   print "cads"
          --   cmp.confirm { select = false }
        elseif col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
          fallback()
        else
          fallback()
        end
      end

      local function shift_tab(fallback)
        if require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end

      local border_opts = {
        border = require("r.config").icons.border.line,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      return {
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
          -- require("cmp_dap").is_dap_buffer()
        end,
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-y>"] = cmp.mapping(function(_)
            -- if cmp.visible() then
            --   cmp.abort()
            if callme == 0 then
              callme = 1
              cmp.complete {
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
                    source_buffer,
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
          ["<c-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end, { "i" }),
          ["<c-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i" }),
          ["<c-q>"] = cmp.mapping.abort(),
          ["<TAB>"] = cmp.mapping(tab, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(shift_tab, { "i", "s" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<cr>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
        },

        experimental = { ghost_text = false },
        sorting = defaults.sorting,
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          -- cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            local label_width = 45
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, label_width)

            if truncated_label ~= label then
              item.abbr = truncated_label .. "…"
            elseif string.len(label) < label_width then
              local padding = string.rep(" ", label_width - string.len(label))
              item.abbr = label .. padding
            end

            item.menu = item.kind
            local icons = require("r.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind]
            end
            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
          -- format = function(_, item)
          --   local icons = require("r.config").icons.kinds
          --   if icons[item.kind] then
          --     item.kind = icons[item.kind] .. item.kind
          --   end
          -- end,
        },

        sources = cmp.config.sources {
          -- https://github.com/neovim/neovim/issues/19118#issuecomment-1221522853
          -- tailwindcss bikin lambat, jadi mencoba mengurangi `max_item_count`
          { name = "nvim_lsp", max_item_count = 100 },
          { name = "luasnip", max_item_count = 100 },
          { name = "nvim_lsp_signature_help" },
          source_buffer,
          { name = "crates" },
          { name = "async_path" },
          -- { name = "orgmode" },
        },
      }
    end,
    config = function(_, opts)
      local cmp = get_cmp()

      vim.lsp.util.stylize_markdown = function(bufnr, contents, optsc)
        contents = vim.lsp.util._normalize_markdown(contents, {
          width = vim.lsp.util._make_floating_popup_size(contents, optsc),
        })

        vim.bo[bufnr].filetype = "markdown"
        vim.treesitter.start(bufnr)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

        return contents
      end

      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      cmp.setup(opts)

      local tbl_custom_sources = {
        { name = "luasnip" },
        { name = "async_path" },
        { name = "buffer" },
        { name = "emoji" },
      }

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources(tbl_custom_sources),
      })

      cmp.setup.filetype({ "norg", "neorg" }, {
        sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "neorg" } })),
      })

      cmp.setup.filetype({ "org", "orgagenda" }, {
        sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "orgmode" } })),
      })

      cmp.setup.filetype("dap-repl", {
        sources = cmp.config.sources { { name = "dap" }, { name = "buffer" } },
      })

      cmp.setup.filetype({ "gitcommit", "NeogitPopup", "NeogitCommitMessage" }, {
        sources = vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "git" } }),
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources { { name = "vim-dadbod-completion" }, { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = {
          -- ["<esc>"] = {
          --   c = function()
          --     Util.cmd.feedkey("<c-c>", "n")
          --   end,
          -- },
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
              else
                fallback()
              end
            end,
          },
          ["<TAB>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<S-TAB>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
          { { name = "cmdline_history" } },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = {
          -- ["<esc>"] = {
          --   c = function()
          --     Util.cmd.feedkey("<c-c>", "n")
          --   end,
          -- },
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
              else
                fallback()
              end
            end,
          },
          ["<TAB>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<S-TAB>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources {
          { name = "buffer" },
        },
      })
    end,
  },
  -- COMMENTS-TS-CONTEXT
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  -- MINI-SURROUND
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzc", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },
  -- MINI.COMMENT
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  -- NVIM-COVERAGE
  {
    "andythigpen/nvim-coverage", -- Display test coverage information
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "Coverage",
      "CoverageSummary",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
    },
    config = function()
      require("coverage").setup {
        highlights = {
          covered = { fg = "green" },
          uncovered = { fg = "red" },
        },
      }

      highlight.plugin("coverage_hi", {
        { CoverageCovered = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoveragePartial = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoverageUncovered = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoverageSummaryFail = { bg = { from = "ColorColumn", attr = "bg" } } },
      })
    end,
  },
  -- SCRATCH
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchOpen" },
    keys = {
      {
        "<Localleader>oS",
        "<CMD>Scratch<CR>",
        desc = "Misc(scratch): select language",
      },
      {
        "<Localleader>os",
        "<CMD>ScratchOpen<CR>",
        desc = "Misc(scratch): open",
      },
    },
  },
  -- REST.NVIM
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = {
      { "<Leader>rr", "<Plug>RestNvim", desc = "Open(rest-nvim): execute HTTP request" },
    },
    opts = { skip_ssl_verification = true },
  },
  -- NVIM-AUTOPAIRS
  {
    "windwp/nvim-autopairs",
    enabled = function()
      if require("r.config").lsp_style == "coc" then
        return false
      end
      return true
    end,
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      close_triple_quotes = true,
      check_ts = true,
      ts_config = {
        lua = { "string" },
        dart = { "string" },
        javascript = { "template_string" },
      },
      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "neo-tree-popup",
        "vim",
      },

      fast_wrap = { map = "<c-g>" },
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
    config = function(_, opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)

      local cmp = require "cmp"
      local has_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if has_autopairs then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
      end

      local handlers = require "nvim-autopairs.completion.handlers"
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done {
          filetypes = {
            ["*"] = {
              ["("] = {
                kind = {
                  cmp.lsp.CompletionItemKind.Function,
                  cmp.lsp.CompletionItemKind.Method,
                },
                handler = handlers["*"],
              },
            },
          },
        }
      )
    end,
  },
  -- RUNMUX
  {
    -- "mrowegawd/runmux",
    dir = "~/.local/src/nvim_plugins/rmux",
    cmd = { "RmuxEDITConfig" },
    keys = {
      { "rf", "<Cmd> RmuxRunFile <CR>" },
      { "rp", "<Cmd> RmuxREPL <CR>" },
      { "rl", "<Cmd> RmuxSendline <CR>" },
      { "rl", "<Cmd> RmuxSendVisualSelection <CR>", mode = { "v" } },
      { "ri", "<Cmd> RmuxSendInterrupt <CR>" },
      { "rI", "<Cmd> RmuxSendInterruptAll <CR>" },
      { "rt", "<Cmd> RmuxTargetPane <CR>" },

      { "rC", "<Cmd> RmuxKillAllPanes <CR>" },
      { "rA", "<Cmd> RmuxRunTaskAll <CR>" },
      { "rg", "<Cmd> RmuxGrepErr <CR>" },

      { "re", "<Cmd> RmuxEDITConfig <CR>" },
      { "rE", "<Cmd> RmuxREDITConfig <CR>" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        run_with = "mux", -- mux, tt, toggleterm
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
}
