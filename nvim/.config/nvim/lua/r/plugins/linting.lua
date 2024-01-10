local Util = require "r.utils"

return {
  -- NULL-LS-EMBEDDED
  {
    dir = "~/.local/src/nvim_plugins/null-ls-embedded",
  },
  -- NONE-LS
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    enabled = false,
    dependencies = { "mason.nvim" },
    init = function()
      Util.on_very_lazy(function()
        require("r.utils").format.register {
          name = "none-ls.nvim",
          priority = 200, -- set higher than conform, the builtin formatter
          primary = true,
          format = function(buf)
            return Util.lsp.format {
              bufnr = buf,
              filter = function(client)
                return client.name == "null-ls"
              end,
            }
          end,
          sources = function(buf)
            local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or {}
            return vim.tbl_map(function(source)
              return source.name
            end, ret)
          end,
        }
      end)
    end,
    opts = function(_, opts)
      local nls = require "null-ls"
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {

        -- lua
        nls.builtins.formatting.stylua,

        -- go
        nls.builtins.formatting.gofumpt,
        nls.builtins.formatting.goimports,
        nls.builtins.diagnostics.golangci_lint,
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,

        nls.builtins.diagnostics.markdownlint.with {
          extra_args = { "--stdin", "--config=" .. vim.env.HOME .. "/.config/miscxrdb/linters/.markdownlint.json" },
        },

        -- sh
        nls.builtins.formatting.shfmt,

        -- ts,js,react
        nls.builtins.formatting.prettierd,
        nls.builtins.diagnostics.eslint_d,
        nls.builtins.code_actions.eslint_d,

        -- docker
        nls.builtins.diagnostics.hadolint,

        -- ansible
        nls.builtins.diagnostics.ansiblelint,

        -- cmake
        nls.builtins.diagnostics.cmake_lint,

        nls.builtins.diagnostics.trail_space.with {
          filetypes = { "org", "norg", "text" },
        },
        nls.builtins.formatting.trim_newlines.with {
          filetypes = { "org", "norg", "text" },
        },
        nls.builtins.formatting.trim_whitespace.with {
          filetypes = { "org", "norg", "text" },
        },

        nls.builtins.diagnostics.codespell.with {
          filetypes = { "org", "norg", "text", "markdown" },
        },

        require("null-ls-embedded").nls_source.with {
          filetypes = { "markdown", "html", "vue", "lua", "org", "norg" },
        },
      })
    end,
  },
  -- NVIM-LINT
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        fish = { "fish" },
        cmake = { "cmakelint" },
        markdown = { "markdownlint", "codespell" },
        go = { "golangcilint" },
        docker = { "hadolint" },
        -- Use the "*" filetype to run linters on all filetypes.
        -- ['*'] = { 'global linter' },
        -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
        -- ['_'] = { 'fallback linter' },
      },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        markdownlint = {
          args = { "--config=" .. vim.env.HOME .. "/.config/miscxrdb/linters/.markdownlint.json" },
        },

        -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   -- `condition` is another LazyVim extension that allows you to
        --   -- dynamically enable/disable linters based on the context.
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },

    config = function(_, opts)
      local M = {}

      local lint = require "lint"

      vim.g.try_lint = function(args)
        args = args or {}
        lint.try_lint(nil, args)
        if vim.g.codespell_active then
          lint.try_lint("codespell", { ignore_errors = true })
        end
      end
      vim.g.codespell_active = true -- enabled by default

      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.loop.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            ---@diagnostic disable-next-line: deprecated
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            Util.warn("Linter not found: " .. name, { title = "nvim-lint" })
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
