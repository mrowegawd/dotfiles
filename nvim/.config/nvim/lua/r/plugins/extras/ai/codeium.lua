return {
  -- CODEIUM
  {
    "Exafunction/codeium.nvim",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},
  },

  -- add ai_accept action
  {
    "Exafunction/codeium.nvim",
    opts = function()
      RUtils.cmp.actions.ai_accept = function()
        if require("codeium.virtual_text").get_current_completion_item() then
          RUtils.create_undo()
          vim.api.nvim_input(require("codeium.virtual_text").accept())
          return true
        end
      end
    end,
  },
  -- codeium cmp source
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = { "codeium.nvim" },
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
      })
    end,
  },
  -- codeium blink source
  vim.g.ai_cmp
      and {
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "codeium.nvim", "saghen/blink.compat" },
        opts = {
          sources = {
            compat = { "codeium" },
            providers = {
              codeium = {
                kind = "Codeium",
                score_offset = 100,
                async = true,
              },
            },
          },
        },
      }
    or nil,
}
