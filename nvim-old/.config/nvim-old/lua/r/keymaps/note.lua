local M = {}

local _keys

local function set_keymaps(mappings, bufnr)
  for mode, x in pairs(mappings) do
    if mode == "i" then
      for key, key_func in pairs(x) do
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.keymap.set(mode, key, key_func[1], { desc = key_func[2], buffer = bufnr, remap = true })
        end
      end
    else
      for key, key_func in pairs(x) do
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.keymap.set(mode, key, key_func[1], { desc = key_func[2], buffer = bufnr, remap = true })
        end
      end
    end
  end
end

---@param bufnr integer
function M.note_mappings_ft(bufnr)
  RUtils.create_command("NotePrintOutTags", function()
    RUtils.markdown.find_note_by_tag({}, true, true)
  end, { desc = "Note: print out tags" })

  _keys = {
    ["n"] = {
      ["<Leader>ld"] = {
        function()
          RUtils.notes.open_item_heading_default()
        end,
        "Note: open under cursor",
      },
      ["<Leader>lv"] = {
        function()
          RUtils.notes.open_item_heading_vsplit()
        end,
        "Note: open vsplit under cursor",
      },

      -- ├────────────────────────────┤ JUMP TO HEADING ├─────────────────────────┤
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

      -- ├──────────────────────────────────┤ FIND ├──────────────────────────────────┤
      ["<Leader>rr"] = {
        function()
          RUtils.notes.find_backlinks_local()
        end,
        "Note: find local backlink",
      },
      ["<Leader>rR"] = {
        function()
          RUtils.notes.find_backlinks_global()
        end,
        "Note: find global backlink",
      },
      ["<Leader>uu"] = {
        function()
          RUtils.notes.find_url_and_backlinks_local()
        end,
        "Note: find backlink and http in local",
      },
      ["<Leader>uU"] = {
        function()
          RUtils.notes.find_url_and_backlinks_global()
        end,
        "Note: find backlink and http in global",
      },
    },
    ["i"] = {
      -- ├─────────────────────────────────┤ INSERT ├─────────────────────────────────┤
      ["C<cr>"] = {
        function()
          RUtils.notes.insert_tag()
        end,
        "Note: insert tag",
      },
      ["c<cr>"] = {
        function()
          RUtils.notes.last_insert_tag()
        end,
        "Note: repeat insert tag",
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

  if vim.bo[bufnr].filetype == "orgagenda" then
    _keys["n"] = {
      -- ├────────────────────────────────┤ OPEN IN ├─────────────────────────────┤
      ["<c-s>"] = {
        function()
          RUtils.notes.open_item_heading_split()
        end,
        "Note: open in split",
      },
      ["<c-v>"] = {
        function()
          RUtils.notes.open_item_heading_vsplit()
        end,
        "Note: open in vsplit",
      },
      ["<c-t>"] = {
        function()
          RUtils.notes.open_item_heading_tab()
        end,
        "Note: open in tab",
      },
    }
  end

  set_keymaps(_keys, bufnr)
end

return M
