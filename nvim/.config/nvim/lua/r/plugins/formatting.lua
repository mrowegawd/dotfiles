local Util = require "r.utils"

local M = {}

---@param opts ConformOpts
function M.setup(_, opts)
  for name, formatter in pairs(opts.formatters or {}) do
    if type(formatter) == "table" then
      ---@diagnostic disable-next-line: undefined-field
      if formatter.extra_args then
        ---@diagnostic disable-next-line: undefined-field
        formatter.prepend_args = formatter.extra_args
        Util.deprecate(("opts.formatters.%s.extra_args"):format(name), ("opts.formatters.%s.prepend_args"):format(name))
      end
    end
  end

  for _, key in ipairs { "format_on_save", "format_after_save" } do
    if opts[key] then
      Util.warn(
        ("Don't set `opts.%s` for `conform.nvim`.\n**LazyVim** will use the conform formatter automatically"):format(
          key
        )
      )
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
      Util.on_very_lazy(function()
        Util.format.register {
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            local plugin = require("lazy.core.config").plugins["conform.nvim"]
            local Plugin = require "lazy.core.plugin"
            local opts = Plugin.values(plugin, "opts", false)
            require("conform").format(Util.merge(opts.format, { bufnr = buf }))
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
      -- local plugin = require("lazy.core.config").plugins["conform.nvim"]
      -- if plugin.config ~= M.setup then
      --   Util.error({
      --     "Don't set `plugin.config` for `conform.nvim`.\n",
      --     "This will break **LazyVim** formatting.\n",
      --     "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
      --   }, { title = "LazyVim" })
      -- end
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

          ["javascript"] = { { "prettierd", "prettier" } },
          ["javascriptreact"] = { { "prettierd", "prettier" } },
          ["typescript"] = { { "prettierd", "prettier" } },
          ["typescriptreact"] = { { "prettierd", "prettier" } },
          ["vue"] = { { "prettierd", "prettier" } },
          ["css"] = { { "prettierd", "prettier" } },
          ["scss"] = { { "prettierd", "prettier" } },
          ["less"] = { { "prettierd", "prettier" } },
          ["html"] = { { "prettierd", "prettier" } },
          ["json"] = { { "prettierd", "prettier" } },
          ["jsonc"] = { { "prettierd", "prettier" } },
          ["yaml"] = { { "prettierd", "prettier" } },
          ["graphql"] = { { "prettierd", "prettier" } },
          ["handlebars"] = { { "prettierd", "prettier" } },

          ["markdown"] = { "prettierd", "cbfmt" },
          ["markdown.mdx"] = { { "prettierd", "prettier" } },
          ["norg"] = { "trim_whitespace", "trim_newlines" }, -- TODO: cbfmt does not work :(
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

          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
      return opts
    end,
    config = M.setup,
  },
}
