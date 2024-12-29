local callme = 0

return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", enabled = false },
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not RUtils.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "chrisgrieser/nvim-scissors",
        opts = {
          snippetDir = RUtils.config.path.snippet_path,
        },
      },
    },
    keys = {
      {
        "<Leader>fn",
        function()
          require("scissors").editSnippet()
        end,
        desc = "Misc: edit snippet [nvim-scissors]",
      },
      {
        "<Leader>fN",
        function()
          require("scissors").addNewSnippet()
        end,
        mode = { "n", "v" },
        desc = "Misc: add snippet [nvim-scissors]",
      },
    },
    opts = {
      history = false,
      delete_check_events = "TextChanged",
    },
    config = function()
      local luasnip = require "luasnip"

      require("luasnip.loaders.from_vscode").lazy_load {
        paths = RUtils.config.path.snippet_path,
      }

      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("django-html", { "html" })
      luasnip.filetype_extend("htmldjango", { "html" })

      luasnip.filetype_extend("javascript", { "html" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html", "react" })

      luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- add snippet_forward action
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    opts = function()
      RUtils.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          require("luasnip").jump(1)
          return true
        end
      end
      RUtils.cmp.actions.snippet_stop = function()
        if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
          require("luasnip").unlink_current()
          return true
        end
      end
    end,
  },
  -- Luasnip cmp integration
  {
    "iguanacucumber/nvim-cmp",
    optional = true,
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      local function get_cmp()
        local ok_cmp, cmp = pcall(require, "cmp")
        return ok_cmp and cmp or {}
      end
      local cmp = get_cmp()

      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      opts.mapping = vim.tbl_deep_extend("force", {}, opts.mapping, {
        ["<C-r>"] = cmp.mapping(function(_)
          if callme == 0 then
            callme = 1
            cmp.complete {}
          elseif callme == 1 then
            callme = 2
            if not vim.tbl_contains({ "org", "rgflow" }, vim.bo[0].filetype) then
              cmp.complete { config = { sources = { { name = "codeium" } } } }
            end
          elseif callme == 2 then
            callme = 3
            cmp.complete {
              config = {
                sources = {
                  {
                    name = "buffer",
                    option = {
                      get_bufnrs = function()
                        return vim.tbl_filter(function(buf)
                          return vim.fn.buflisted(buf) == 1 and vim.fn.bufloaded(buf) == 1
                        end, vim.api.nvim_list_bufs())
                      end,
                    },
                  },
                },
              },
            }
          else
            callme = 0
            cmp.complete { config = { sources = { { name = "luasnip" } } } }
          end
        end, {
          "i",
          "s",
        }),
        ["<C-j>"] = cmp.mapping(function()
          local cmps = get_cmp()
          local types = require "cmp.types"

          if cmps.visible() then
            -- if #cmps.get_entries() == 1 then
            --   cmps.confirm { select = true }
            -- else
            cmps.select_next_item {
              behavior = types.cmp.SelectBehavior.Select,
            }
            -- end
          else
            cmps.complete {}
          end
        end, { "i" }),
        ["<C-k>"] = cmp.mapping(function()
          local cmps = get_cmp()
          if cmps.visible() then
            cmps.select_prev_item { behavior = "Select" }
          end
        end, { "i" }),
        ["<C-g>"] = cmp.mapping(function()
          require("fzf-lua").complete_file {
            cmd = "rg --files --hidden",
            winopts = { preview = { hidden = "nohidden" } },
          }
        end, { "i" }),
        ["<c-p>"] = cmp.mapping {
          i = function()
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").jump(1)
            end
          end,
          s = function()
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").jump(1)
            end
          end,
        },
        ["<c-n>"] = cmp.mapping(function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end, { "i", "s" }),
      })
      table.insert(opts.sources, {
        name = "luasnip",
        priority = 50,
        group_index = 1,
        option = { show_autosnippets = true, use_show_condition = false },
      })
    end,
  },
  -- Luasnip blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
      { "saadparwaiz1/cmp_luasnip" },
    },
    opts = {
      sources = { compat = { "luasnip" } },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },
  },
}