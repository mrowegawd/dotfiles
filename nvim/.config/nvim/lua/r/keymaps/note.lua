local fmt, cmd = string.format, vim.cmd

local M = {}

function M.neorg_mappings_ft(bufnr)
  local mappings = {
    ["n"] = {
      ["ri"] = {
        function()
          return RUtils.maim.insert()
        end,
        "Note: insert image",
      },
      ["t<CR>"] = {
        function()
          RUtils.markdown.find_local_titles()
          vim.cmd "normal! zRzz" -- open all closed fold (but it doesnt work)
        end,
        desc = "Note: search local titles [obsidian]",
      },
      ["T<CR>"] = {
        function()
          RUtils.markdown.find_global_titles()
          vim.cmd "normal! zRzz"
        end,
        desc = "Note: search global titles [obsidian]",
      },
      ["l<cr>"] = {
        function()
          RUtils.markdown.find_local_sitelink()
          vim.cmd "normal! zRzz"
        end,
        "Note: find sitelink (curbuf)",
      },
      ["<leader>fT"] = {
        function()
          RUtils.todocomments.search_global_note {
            title = "Todo Note Global",
          }
          vim.cmd "normal! zRzz"
        end,
        "Note: search todo global note [fzflua]",
      },
      ["<leader>ft"] = {
        function()
          RUtils.todocomments.search_local {
            title = "Todo Note Curbuf",
          }
        end,
        "Note: search todo local note [fzflua]",
      },
      ["<Localleader>oa"] = {
        function()
          if vim.bo[0].filetype == "neorg" then
            RUtils.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, true)
            cmd "Neorg toc right"
            local vim_width = vim.o.columns
            vim_width = math.floor(vim_width / 2 - 10)
            cmd(fmt("vertical resize %s", vim_width))
          else
            if RUtils.has "aerial.nvim" then
              vim.cmd [[AerialToggle]]
            end

            if RUtils.has "outline.nvim" then
              vim.cmd [[Outline]]
            end
          end
        end,
        "Note: open toc",
      },
      ["gD"] = {
        function()
          vim.cmd "vsplit | ObsidianFollowLink"
        end,
        "Note: followlink vertical split",
      },
    },
    ["i"] = {
      ["c<cr>"] = {
        function()
          RUtils.markdown.insert_by_categories()
        end,
        "Note: insert categories (curbuf)",
      },
      ["t<cr>"] = {
        function()
          RUtils.markdown.insert_local_titles()
        end,
        "Note: insert title (curbuf)",
      },
      ["T<cr>"] = {
        function()
          RUtils.markdown.insert_global_titles()
        end,
        "Note: insert title (global)",
      },
    },
  }

  -- local resuffle = {}
  for i, x in pairs(mappings) do
    if i == "i" then
      for g, gg in pairs(x) do
        vim.keymap.set(i, g, gg[1], { desc = gg[2], buffer = bufnr })
      end
    else
      for j, jj in pairs(x) do
        vim.keymap.set(i, j, jj[1], { desc = jj[2], buffer = bufnr })
      end
    end
  end
end

return M
