return {
  -- CODEIUM
  {
    "nvim-cmp",
    dependencies = {
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
      })

      local cmp = require "cmp"
      opts.mapping = vim.tbl_deep_extend("force", {}, opts.mapping, {
        ["<c-q>"] = cmp.mapping(function()
          cmp.complete {
            config = {
              sources = {
                {
                  name = "codeium",
                  -- max_item_count = 5,
                  keyword_length = 1,
                  priority = 60,
                  group_index = 4,
                },
              },
            },
          }
        end, { "i" }),
      })
    end,
  },
}
