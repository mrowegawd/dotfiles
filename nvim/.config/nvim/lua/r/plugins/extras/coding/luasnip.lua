return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", enabled = false },
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = (not RUtils.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      { "chrisgrieser/nvim-scissors", opts = { snippetDir = RUtils.config.path.snippet_path } },
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
        mode = { "n", "x" },
        desc = "Misc: add snippet [nvim-scissors]",
      },
    },
    opts = {
      history = false,
      delete_check_events = "TextChanged",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = RUtils.config.path.snippet_path,
      }

      -- luasnip.filetype_extend("python", { "django" })
      -- luasnip.filetype_extend("django-html", { "html" })
      -- luasnip.filetype_extend("htmldjango", { "html" })
      --
      -- luasnip.filetype_extend("javascript", { "html" })
      -- luasnip.filetype_extend("javascript", { "javascriptreact" })
      -- luasnip.filetype_extend("javascriptreact", { "html" })
      -- luasnip.filetype_extend("typescript", { "html" })
      -- luasnip.filetype_extend("typescriptreact", { "html", "react" })
      --
      -- luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      keymap = {
        ["<C-y>"] = {
          function(cmp)
            local luasnip = require "luasnip"
            if cmp.is_visible() then
              return cmp.select_and_accept()
            elseif luasnip.expand_or_jumpable() then
              return cmp.accept()
            elseif luasnip.get_active_snip() then
              return luasnip.jump(1)
            elseif vim.snippet.active() then
              return vim.snippet.jump(1)
            end
          end,
          "fallback",
        },
        ["<Tab>"] = {
          function()
            local luasnip = require "luasnip"
            if luasnip.expand_or_jumpable() then
              return luasnip.expand_or_jump()
            elseif luasnip.get_active_snip() then
              RUtils.info "asf"
              return luasnip.jump(1)
            elseif vim.snippet.active() then
              return vim.snippet.jump(1)
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function()
            local luasnip = require "luasnip"
            if luasnip.get_active_snip() then
              return luasnip.jump(-1)
            elseif vim.snippet.active() then
              return vim.snippet.jump(-1)
            else
              local cur = vim.api.nvim_win_get_cursor(0)
              pcall(vim.api.nvim_win_set_cursor, 0, { cur[1], cur[2] - 1 })
            end
          end,
        },
        ["<C-s>"] = {
          function()
            require("luasnip").unlink_current()
          end,
        },
      },
    },
  },
}
