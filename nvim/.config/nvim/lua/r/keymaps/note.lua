local M = {}

---@param bufnr integer
function M.neorg_mappings_ft(bufnr)
  RUtils.create_command("NotePrintOutTags", function()
    RUtils.markdown.find_note_by_tag({}, true, true)
  end, { desc = "Note: print out tags" })

  local mappings = {
    ["n"] = {
      ["<Leader>fT"] = {
        function()
          RUtils.todocomments.search_global_note { title = "Todo Note Global" }
          vim.cmd "normal! zRzz"
        end,
        "TODOCOMMENTS: search global TODO in notes [fzflua]",
      },
      ["<Leader>ft"] = {
        function()
          RUtils.todocomments.search_local { title = "Todo Note Curbuf" }
        end,
        "TODOCOMMENTS: search local TODO in notes [fzflua]",
      },
      ["<Leader>fs"] = {
        function()
          RUtils.notes.jump_heading_local()
        end,
        "Note: jump to local heading",
      },
      ["<Leader>fS"] = {
        function()
          RUtils.notes.jump_heading_global()
        end,
        "Note: jump to global heading",
      },
      ["<Leader>lr"] = {
        function()
          RUtils.notes.find_backlinks_local()
        end,
        "Note: find local backlink",
      },
      ["<Leader>lR"] = {
        function()
          RUtils.notes.find_backlinks_global()
        end,
        "Note: find global backlink",
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
        "Note: link follow (vsplit)",
      },
      ["<Leader>ld"] = {
        function()
          if vim.bo.filetype == "org" then
            require("orgmode").action "org_mappings.open_at_point"
          else
            vim.cmd "ObsidianFollowLink"
          end
        end,
        "Note: link follow",
      },
    },
    ["i"] = {
      ["c<cr>"] = {
        function()
          RUtils.notes.insert_tag()
        end,
        "Note: insert tag",
      },
      ["b<cr>"] = {
        function()
          RUtils.notes.insert_backlinks()
        end,
        "Note: insert backlink",
      },
      ["t<cr>"] = {
        function()
          RUtils.notes.insert_title_local()
        end,
        "Note: insert title local",
      },
      ["T<cr>"] = {
        function()
          RUtils.notes.insert_title_global()
        end,
        "Note: insert title global",
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
