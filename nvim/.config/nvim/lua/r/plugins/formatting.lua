local M = {}

local supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

--- Checks if a Prettier config file exists for the given context
---@param ctx ConformCtx
function M.has_config(ctx)
  vim.fn.system { "prettier", "--find-config-path", ctx.filename }
  return vim.v.shell_error == 0
end

--- Checks if a parser can be inferred for the given context:
--- * If the filetype is in the supported list, return true
--- * Otherwise, check if a parser can be inferred
---@param ctx ConformCtx
function M.has_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  -- default filetypes are always supported
  if vim.tbl_contains(supported, ft) then
    return true
  end
  -- otherwise, check if a parser can be inferred
  local ret = vim.fn.system { "prettier", "--file-info", ctx.filename }
  ---@type boolean, string?
  local ok, parser = pcall(function()
    return vim.fn.json_decode(ret).inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

M.has_config = RUtils.memoize(M.has_config)
M.has_parser = RUtils.memoize(M.has_parser)

---@param opts ConformOpts
function M.setup(_, opts)
  for _, key in ipairs { "format_on_save", "format_after_save" } do
    if opts[key] then
      local msg = "Don't set `opts.%s` for `conform.nvim`.\n**LazyVim** will use the conform formatter automatically"
      RUtils.warn(msg:format(key))
      ---@diagnostic disable-next-line: no-unknown
      opts[key] = nil
    end
  end
  require("conform").setup(opts)
end

return {
  -- CONFORM.NVIM
  {
    "stevearc/conform.nvim",
    event = { "LspAttach" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format { formatters = { "injected" } }
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    init = function()
      -- Install the conform formatter on VeryLazy
      RUtils.on_very_lazy(function()
        RUtils.format.register {
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            local opts = RUtils.opts "conform.nvim"
            require("conform").format(RUtils.merge(opts.format, { bufnr = buf }))
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        }
      end)
    end,
    opts = function()
      local plugin = require("lazy.core.config").plugins["conform.nvim"]
      if plugin.config ~= M.setup then
        RUtils.error({
          "Don't set `plugin.config` for `conform.nvim`.\n",
          "This will break **LazyVim** formatting.\n",
          "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
        }, { title = "LazyVim" })
      end
      ---@class ConformOpts
      local opts = {
        -- LazyVim will use these options when formatting with the conform.nvim formatter
        format = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
        },
        formatters_by_ft = {
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },
          python = { "black" },
          go = { "goimports", "gofumpt" },
          rust = { "rustfmt" },
          kotlin = { "ktlint" },

          ["norg"] = { "trim_whitespace", "trim_newlines" },
          ["org"] = { "trim_whitespace", "trim_newlines" },

          ["_"] = { "trim_whitespace" },
        },
        -- LazyVim will merge the options you set here with builtin formatters.
        -- You can also define any custom formatters here.
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          cbfmt = {
            prepend_args = { "--config=" .. vim.env.HOME .. "/.config/linters/.cbfmt.toml" },
          },
        },
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = { "prettier" }
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        condition = function(_, ctx)
          return M.has_parser(ctx) and M.has_config(ctx)
        end,
      }
      return opts
    end,
    config = M.setup,
  },
}
