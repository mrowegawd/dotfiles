local M = {}

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
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format { formatters = { "injected" }, timeout_ms = 3000 }
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
            require("conform").format(RUtils.merge({}, opts.format, { bufnr = buf }))
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            ---@param v conform.FormatterInfo
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
          lsp_fallback = true, -- not recommended to change
        },
        ---@type table<string, conform.FormatterUnit[]>
        formatters_by_ft = {
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },

          ["norg"] = { "trim_whitespace", "trim_newlines" },
          ["org"] = { "trim_whitespace", "trim_newlines" },

          ["_"] = { "trim_whitespace" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
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
          cbfmt = {
            prepend_args = { "--config=" .. vim.env.HOME .. "/.config/linters/.cbfmt.toml" },
          },
        },
      }
      return opts
    end,
    config = M.setup,
  },
}
