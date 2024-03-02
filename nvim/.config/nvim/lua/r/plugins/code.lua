local Highlight = require "r.settings.highlights"
local Icons = require("r.config").icons
local Config = require "r.config"
local Util = require "r.utils"

_G.OverseerConfig = {} -- to store error formats

OverseerConfig.fnpane_run = 0
OverseerConfig.fnpane_runtest = 0
OverseerConfig.fnpane_runmisc = 0

local callme = 0

return {
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    enabled = function()
      if require("r.config").lsp_style == "coc" then
        return false
      end
      return true
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-path",
      "davidsierradz/cmp-conventionalcommits",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "lukas-reineke/cmp-under-comparator",
      "petertriho/cmp-git",
      "lukas-reineke/cmp-rg",
      "rcarriga/cmp-dap",
      "saadparwaiz1/cmp_luasnip",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = true,
      },
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
            paths = Config.path.dropbox_path .. "/friendly-snippets",
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
    },
    config = function()
      local MAX_INDEX_FILE_SIZE = 1024
      local function tab(fallback)
        if vim.snippet.jumpable(1) then
          vim.snippet.jump(1)
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end

      local function shift_tab(fallback)
        if vim.snippet.jumpable(-1) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end

      local border_opts = {
        border = Icons.border.line,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      local cmp = require "cmp"
      cmp.setup {
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
        end,
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        experimental = { ghost_text = false },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          -- cmp_tabnine = 1,
          buffer = 1,
          rg = 1,
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

            -- print(entry.source.name)
            item.menu = item.kind
              .. " "
              .. ({
                nvim_lsp = "[LSP]",
                obsidian = "[OBSIDIAN]",
                obsidian_new = "[OBSIDIAN]",
                nvim_lua = "[LUA]",
                emoji = "[EMOJI]",
                path = "[PATH]",
                neorg = "[NEORG]",
                luasnip = "[SNIP]",
                dictionary = "[DIC]",
                buffer = "[BUF]",
                spell = "[SPELL]",
                orgmode = "[ORG]",
                norg = "[NORG]",
                rg = "[RG]",
                cmdline = "[CMD]",
                git = "[GIT]",
              })[entry.source.name]
            local kind = Icons.kinds
            if kind[item.kind] then
              item.kind = kind[item.kind]
            end

            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        -- sorting = {
        --   comparators = {
        --     -- require("copilot_cmp.comparators").prioritize,
        --     cmp.config.compare.offset,
        --     cmp.config.compare.exact,
        --     cmp.config.compare.score,
        --
        --     deprioritize_snippet,
        --     function(entry1, entry2)
        --       local _, entry1_under = entry1.completion_item.label:find "^_+"
        --       local _, entry2_under = entry2.completion_item.label:find "^_+"
        --       entry1_under = entry1_under or 0
        --       entry2_under = entry2_under or 0
        --       if entry1_under > entry2_under then
        --         return false
        --       elseif entry1_under < entry2_under then
        --         return true
        --       end
        --     end,
        --     cmp.config.compare.recently_used,
        --     cmp.config.compare.kind,
        --     cmp.config.compare.sort_text,
        --     cmp.config.compare.length,
        --     cmp.config.compare.order,
        --     cmp.config.compare.locality,
        --   },
        -- }
        mapping = {
          ["<C-r>"] = cmp.mapping(function(_)
            if callme == 0 then
              callme = 1
              cmp.complete {
                config = {
                  sources = {
                    {
                      name = "luasnip",
                      max_item_count = 5,
                      group_index = 1,
                    },
                  },
                },
              }
            elseif callme == 1 then
              callme = 2
              cmp.complete {
                config = {
                  sources = {
                    {
                      name = "rg",
                      keyword_length = 4,
                      option = { additional_arguments = "--hidden --max-depth 8" },
                      group_index = 1,
                    },
                    {
                      name = "buffer",
                      group_index = 2,
                      max_item_count = 3,
                      options = {
                        get_bufnrs = function()
                          --- from all loaded buffers
                          local bufs = {}
                          local loaded_bufs = vim.api.nvim_list_bufs()
                          for _, bufnr in ipairs(loaded_bufs) do
                            -- Don't index giant files
                            if
                              vim.api.nvim_buf_is_loaded(bufnr)
                              and vim.api.nvim_buf_line_count(bufnr) < MAX_INDEX_FILE_SIZE
                            then
                              table.insert(bufs, bufnr)
                            end
                          end
                          return bufs
                          -- ----
                          -- from visible bufs.
                          -- local bufs = {}
                          -- for _, win in ipairs(vim.api.nvim_list_wins()) do
                          --   bufs[vim.api.nvim_win_get_buf(win)] = true
                          -- end
                          -- --- alternative buf.
                          -- local alter = vim.fn.bufnr('#')
                          -- if alter > 0 then bufs[vim.fn.bufnr('#')] = true end
                          -- return vim.tbl_keys(bufs)
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
                      {
                        name = "nvim_lsp",
                        max_item_count = 5,
                        group_index = 1,
                      },
                    },
                  },
                }
              end
            end
          end, {
            "i",
            "s",
          }),
          ["<c-j>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<c-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<c-q>"] = cmp.mapping.abort(),
          ["<c-g>"] = cmp.mapping(function()
            require("fzf-lua").complete_file {
              cmd = "rg --files --hidden",
              winopts = { preview = { hidden = "nohidden" } },
            }
          end, { "i" }),
          ["<TAB>"] = cmp.mapping(tab, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(shift_tab, { "i", "s" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<cr>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
          ["<c-y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        },
        sources = cmp.config.sources {
          {
            name = "nvim_lsp",
            group_index = 1,
            max_item_count = 5,
            entry_filter = function(entry)
              return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end,
          },
          { name = "luasnip", group_index = 1 },
          {
            name = "rg",
            keyword_length = 3,
            max_item_count = 10,
            option = { additional_arguments = "--hidden --max-depth 8" },
            group_index = 1,
          },
          {
            name = "buffer",
            group_index = 2,
            max_item_count = 3,
            options = {
              get_bufnrs = function()
                local bufs = {}
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                  -- Don't index giant files
                  if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_line_count(bufnr) < MAX_INDEX_FILE_SIZE then
                    table.insert(bufs, bufnr)
                  end
                end
                return bufs
              end,
            },
          },
          { name = "path", max_item_count = 3, group_index = 1 },
          { name = "crates", group_index = 1 },
        },
      }
      vim.lsp.util.stylize_markdown = function(bufnr, contents, optsc)
        contents = vim.lsp.util._normalize_markdown(contents, {
          width = vim.lsp.util._make_floating_popup_size(contents, optsc),
        })

        vim.bo[bufnr].filetype = "markdown"
        vim.treesitter.start(bufnr)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

        return contents
      end

      local tbl_custom_sources = {
        { name = "nvim_lsp", max_item_count = 5, group_index = 1 },
        { name = "buffer", max_item_count = 5, group_index = 1 },
        { name = "luasnip", max_item_count = 5, group_index = 1 },
        { name = "path", max_item_count = 5, group_index = 1 },
        { name = "rg", max_item_count = 5, group_index = 1 },
        { name = "emoji", max_item_count = 5, group_index = 1 },
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

      cmp.setup.filetype({ "rgflow" }, {
        sources = cmp.config.sources { { name = "buffer" }, { name = "rg" }, { name = "path" } },
      })

      cmp.setup.cmdline(":", {
        mapping = {
          ["<C-y>"] = cmp.mapping(function()
            cmp.confirm { select = true }
            Util.map.feedkey("<CR>", "")
          end, { "c" }),
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources {
          { name = "path" },
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = {
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
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
  -- NVIM-AUTOPAIRS
  {
    -- Dont forget to check this issue https://github.com/altermo/ultimate-autopair.nvim/issues/5
    -- before we use ultimate-autopair
    "windwp/nvim-autopairs",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require "nvim-autopairs"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

      autopairs.setup {
        close_triple_quotes = true,
        disable_filetype = { "neo-tree-popup" },
        check_ts = true,
        fast_wrap = { map = "<c-q>" },
        ts_config = {
          lua = { "string" },
          dart = { "string" },
          javascript = { "template_string" },
        },
      }
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
  -- NVIM-SURROUND
  {
    "kylechui/nvim-surround",
    version = "*",
    keys = {
      "ys", -- how to use it: ysiw, yd<brackets>, yc<brackets>
      "yS",
      "yc",
      "yd",
      { "s", "S", remap = true, mode = { "x" } },
      { "S", mode = { "x" } },
      { "gS", mode = { "x" } },
      { "<C-v>s", mode = { "i" } },
      { "<C-v>S", mode = { "i" } },
    },
    config = function()
      local input = require("nvim-surround.input").get_input
      require("nvim-surround").setup {
        keymaps = {
          insert = "<C-v>s",
          insert_line = "<C-v>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "yd",
          change = "yc",
          change_line = "yC",
        },
        -- Configuration here, or leave empty to use defaults
        aliases = {
          ["d"] = { "{", "[", "(", "<", '"', "'", "`" }, -- any delimiter
          ["b"] = { "{", "[", "(", "<" }, -- bracket
          ["p"] = { "(" },
        },
        surrounds = {
          ["f"] = {
            change = {
              target = "^.-([%w_.]+!?)()%(.-%)()()$",
              replacement = function()
                local result = input "Enter the function name: "
                if result then
                  return { { result }, { "" } }
                end
              end,
            },
          },
          ["g"] = {
            add = function()
              local result = require("nvim-surround.config").get_input "Enter the generic name: "
              if result then
                return {
                  { result .. "<" },
                  { ">" },
                }
              end
            end,
            find = "[%w_]-<.->",
            delete = "^([%w_]-<)().-(>)()$",
          },
          ["G"] = {
            add = function()
              local result = require("nvim-surround.config").get_input "Enter the generic name: "
              if result then
                return {
                  { result .. "<" },
                  { ">" },
                }
              end
            end,
            find = "[%w_]-<.->",
            delete = "^([%w_]-<)().-(>)()$",
          },
        },
        move_cursor = false,
      }
    end,
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

      Highlight.plugin("coverage_hi", {
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
    event = "VeryLazy",
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
    requires = { "nvim-lua/plenary.nvim" },
    -- keys = {
    --   { "<Leader>rr", "<Plug>RestNvim", desc = "Open(rest-nvim): execute HTTP request" },
    -- },
    opts = { skip_ssl_verification = true },
    config = function(_, opts)
      require("rest-nvim").setup(opts)
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
      -- { "<a-f>", "<Cmd> RmuxToggleTerm <CR>" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        run_with = "wez", -- mux, tt, wez, toggleterm
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
}
