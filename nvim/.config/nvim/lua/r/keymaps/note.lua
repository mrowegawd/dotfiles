local M = {}

function M.neorg_mappings_ft(bufnr)
  RUtils.cmd.create_command("NotePrintOutTags", function()
    RUtils.markdown.find_note_by_tag({}, is_set, true)
  end, { desc = "Note: print out tags" })

  local mappings = {
    ["n"] = {
      ["gs"] = {
        function()
          RUtils.markdown.find_local_titles()
          vim.cmd "normal! zRzz" -- open all closed fold (but it doesnt work)
        end,
        desc = "Note: search local titles [markdown]",
      },
      ["gS"] = {
        function()
          RUtils.markdown.find_global_titles()
          vim.cmd "normal! zRzz"
        end,
        desc = "Note: search global titles [markdown]",
      },
      ["grr"] = {
        function()
          RUtils.markdown.find_backlinks()
        end,
        desc = "Note: find backlinks (like references)",
      },
      ["<Leader>fl"] = {
        function()
          RUtils.info("Find links current buffer", { title = "Notes" })
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
        "TODOCOMMENTS: search global TODO comments in notes [fzflua]",
      },
      ["<Leader>ft"] = {
        function()
          RUtils.todocomments.search_local {
            title = "Todo Note Curbuf",
          }
        end,
        "TODOCOMMENTS: search local TODO comments in notes [fzflua]",
      },
      ["gD"] = {
        function()
          if vim.bo.filetype == "org" then
            vim.cmd "vsplit"
            require("orgmode").action "org_mappings.open_at_point"
          else
            vim.cmd "vsplit | ObsidianFollowLink"
          end
        end,
        "Note: followlink vertical split",
      },
      ["gd"] = {
        function()
          if vim.bo.filetype == "org" then
            require("orgmode").action "org_mappings.open_at_point"
          else
            vim.cmd "ObsidianFollowLink"
          end
        end,
        "Note: followlink",
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
