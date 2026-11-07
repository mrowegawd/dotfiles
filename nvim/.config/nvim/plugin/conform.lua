local add_on_event = require("vim-pack").add_on_event

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add_on_event("BufWritePre", {
  {
    src = "stevearc/conform.nvim",
    opts = function()
      return {
        -- Leave me alone.
        notify_on_error = false,
        notify_no_formatters = false,
        formatters_by_ft = {
          c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
          go = { "goimports", "gofmt", timeout_ms = 500, lsp_format = "prefer" },
          java = { "palantir-java-format" },
          javascript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
          javascriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
          json = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
          jsonc = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },

          less = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier", "injected" },
          python = { "ruff_format" },
          rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
          scss = { "prettier" },
          sh = { "shfmt" },
          typescript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
          typescriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
          yaml = { "prettier" },

          norg = { "trim_whitespace", "trim_newlines", "orgfmt", "cbfmt" },
          org = { "trim_whitespace", "trim_newlines", "orgfmt", "cbfmt" },

          -- For filetypes without a formatter:
          ["_"] = { "trim_whitespace", "trim_newlines" },

          sql = { "sqlfluff" },
          mysql = { "sqlfluff" },
          plsql = { "sqlfluff" },
        },
        format_on_save = function()
          if vim.bo.filetype == "java" then
            -- Java formatting is too slow to do on save.
            return nil
          end

          -- Don't format when minifiles is open, since that triggers the "confirm without
          -- synchronization" message.
          if vim.g.minifiles_active then
            return nil
          end

          -- Skip formatting if triggered from my special save command.
          if vim.g.skip_formatting then
            vim.g.skip_formatting = false
            return nil
          end

          -- Stop if we disabled auto-formatting.
          if not vim.g.autoformat then
            return nil
          end

          return {}
        end,
        formatters = {
          injected = {
            options = {
              lang_to_formatters = {
                html = {},
              },
            },
          },
          -- Require a Prettier configuration file to format.
          prettier = { require_cwd = true },

          -- NOTE: cbfmt is no longer used since we can use `injected` instead
          cbfmt = { -- use for markdown, org, norg
            cwd = lazy("conform.util").root_file {
              vim.env.HOME .. "/.config/linters/.cbfmt.toml",
            },
          },

          sqlfluff = {
            args = { "format", "--dialect=ansi", "-" },
          },

          orgfmt = {
            format = function(_, ctx, lines, callback)
              local indent = lazy "org.indent"
              local deco = lazy "org.ui.decorations"
              local src = ctx.buf

              local adapt = deco.adapt_indentation(src)

              local scratch = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(scratch, 0, -1, false, lines)
              vim.bo[scratch].filetype = "org"
              vim.bo[scratch].tabstop = vim.bo[src].tabstop
              vim.bo[scratch].shiftwidth = vim.bo[src].shiftwidth
              vim.bo[scratch].expandtab = vim.bo[src].expandtab

              local s, e = 1, #lines
              if ctx.range then
                s, e = ctx.range.start[1], ctx.range["end"][1]
              end

              local orig = deco.adapt_indentation
              ---@diagnostic disable-next-line: duplicate-set-field
              deco.adapt_indentation = function()
                return adapt
              end
              local ok, err = pcall(indent.indent_region, scratch, s, e)
              deco.adapt_indentation = orig

              local out = vim.api.nvim_buf_get_lines(scratch, 0, -1, false)
              vim.api.nvim_buf_delete(scratch, { force = true })

              if not ok then
                callback(err)
              else
                callback(nil, out)
              end
            end,
          },
        },
      }
    end,
  },
})

UtilKey.noremap({ "n", "x" }, "<Leader>cf", function()
  lazy("conform").format { timeout_ms = 3000 }
end, { desc = "Action: run formatting [conform.nvim]" })

-- Use conform for gq.
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Start auto-formatting by default (and disable with my ToggleFormat command).
vim.g.autoformat = true
