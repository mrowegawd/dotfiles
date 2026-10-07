return {
  {
    "hrsh7th/nvim-torch",
    dependencies = { "hrsh7th/nvim-cmp-kit" },
    version = "*",
    config = function()
      local torch = require "torch"

      -- for insert-mode completion.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          torch.attach.i(function()
            return torch.preset.i {
              expand_snippet = function(snippet)
                return vim.fn["vsnip#anonymous"](snippet)
              end,
            }
          end)
        end,
      })

      -- for cmdline-mode completion.
      torch.attach.c(":", function()
        return torch.preset.c()
      end)

      -- character mapping for completion context.
      do
        torch.charmap({ "i", "c" }, "<C-Space>", function(ctx)
          ctx.complete { force = true }
        end)
        torch.charmap("i", "<CR>", function(ctx)
          local selection = ctx.get_selection()
          ctx.commit(selection.index == 0 and 1 or selection.index, { replace = false })
        end)
        torch.charmap({ "i", "c" }, "<C-y>", function(ctx)
          local selection = ctx.get_selection()
          ctx.commit(selection.index == 0 and 1 or selection.index, { replace = true })
        end)
        torch.charmap({ "i", "c" }, "<C-n>", function(ctx)
          local selection = ctx.get_selection()
          ctx.select(selection.index + 1)
        end)
        torch.charmap({ "i", "c" }, "<C-p>", function(ctx)
          local selection = ctx.get_selection()
          ctx.select(selection.index - 1)
        end)
        torch.charmap({ "i", "c" }, "<C-p>", function(ctx)
          local selection = ctx.get_selection()
          ctx.select(selection.index - 1)
        end)
      end
    end,
  },
}
