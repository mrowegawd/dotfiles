-- local fmt, cmd = string.format, vim.cmd

local M = {}

function M.neorg_mappings_ft(bufnr)
  local mappings = {
    ["n"] = {
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
      ["grr"] = {
        function()
          RUtils.markdown.find_backlinks()
        end,
        desc = "Note: find backlinks (like references)",
      },
      ["l<cr>"] = {
        function()
          RUtils.markdown.find_local_sitelink()
          vim.cmd "normal! zRzz"
        end,
        "Note: find and go to links (curbuf)",
      },
      ["<Leader>fT"] = {
        function()
          RUtils.todocomments.search_global_note {
            title = "Todo Note Global",
          }
          vim.cmd "normal! zRzz"
        end,
        "Note: search todocomment global note [fzflua]",
      },
      ["<Leader>ft"] = {
        function()
          RUtils.todocomments.search_local {
            title = "Todo Note Curbuf",
          }
        end,
        "Note: search todocomment local note [fzflua]",
      },
      ["<Leader>gD"] = {
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
