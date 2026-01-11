local M = {}

---@param bufnr integer
function M.neorg_mappings_ft(bufnr)
  RUtils.create_command("NotePrintOutTags", function()
    RUtils.markdown.find_note_by_tag({}, true, true)
  end, { desc = "Note: print out tags" })

  local mappings = {
    ["n"] = {
      ["<Leader>mfl"] = {
        function()
          RUtils.markdown.find_local_sitelink()
          vim.cmd "normal! zRzz"
        end,
        "Note: find http link on curbuf",
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
      ["<Leader>mft"] = {
        function()
          RUtils.notes.find_local_title()
        end,
        "Note: jump local title",
      },
      ["<Leader>mfT"] = {
        function()
          RUtils.notes.find_global_title()
        end,
        "Note: jump global title",
      },
      ["<Leader>lr"] = {
        function()
          RUtils.markdown.find_backlinks()
        end,
        "Note: find backlinks (like references)",
      },
      ["<Leader>mfb"] = {
        function()
          RUtils.markdown.find_backlinks()
        end,
        "Note: find backlinks (like references)",
      },
      ["<Leader>lv"] = {
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
      ["<Leader>ld"] = {
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
          RUtils.notes.insert_tag()
        end,
        "Note: insert local tag",
      },
      ["t<cr>"] = {
        function()
          RUtils.notes.insert_local_title()
        end,
        "Note: insert local title",
      },
      ["T<cr>"] = {
        function()
          RUtils.notes.insert_global_title()
        end,
        "Note: insert global title",
      },
    },
  }

  for mode, x in pairs(mappings) do
    if mode == "i" then
      for key, key_func in pairs(x) do
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.keymap.set(mode, key, key_func[1], { desc = key_func[2], buffer = bufnr })
        end
      end
    else
      for key, key_func in pairs(x) do
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.keymap.set(mode, key, key_func[1], { desc = key_func[2], buffer = bufnr })
        end
      end
    end
  end
end

return M
