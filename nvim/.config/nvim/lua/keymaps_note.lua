local M = {}

local lazy = require("utils.plugin").require_lazy

local _keys

local Log = lazy "utils.log"

local UtilNote = lazy "utils.note"

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
  -- CreateCmd("NotePrintOutTags", function()
  --   RUtils.markdown.find_note_by_tag({}, true, true)
  -- end, { desc = "Note: print out tags" })

  _keys = {
    ["n"] = {
      -- ├────────────────────────────┤ JUMP TO HEADING ├─────────────────────────┤
      ["<Leader>fs"] = { UtilNote.jump_heading_local, "Note: jump to local heading" },
      ["<Leader>fS"] = { UtilNote.jump_heading_global, "Note: jump to global heading" },

      ["<C-x>ig"] = { UtilNote.insert_tag_by_plugin, "Note: insert tag by plugin" },

      ["<Leader>lv"] = {
        function()
          local links = lazy "org.links"
          local link = links.link_at_cursor()
          if not link then
            Log.warn "No link at cursor"
            return
          end

          local bufnr_asal = vim.api.nvim_get_current_buf()
          local is_internal = link.type == "radio"
            or link.type == "custom-id"
            or link.type == "heading"
            or link.type == "fuzzy"
            or link.type == "coderef"
            or (
              link.type == "id"
              and links.find_id_link
              and (function()
                local loc = links.find_id_link(link.path)
                return loc and (loc.bufnr == bufnr_asal or loc.filename == vim.api.nvim_buf_get_name(bufnr_asal))
              end)()
            )

          if not is_internal then
            vim.cmd "vsplit"
            return links.open_at_point(0)
          end

          -- link eksternal (file, http, attachment, dll): biarkan links.open
          -- yang menangani vsplit
          links.open(link.target, {
            bufnr = bufnr_asal,
            link = link,
            how = "vsplit",
            arg = 0,
          })
        end,
        "Note: open link in vsplit",
      },

      -- ├──────────────────────────────────┤ FIND ├──────────────────────────────────┤
      ["<Localleader>afb"] = { UtilNote.find_backlinks_local, "Note: find local backlink" },
      ["<Localleader>afB"] = { UtilNote.find_backlinks_global, "Note: find global backlink" },
      ["<Localleader>afu"] = { UtilNote.find_url_and_backlinks_local, "Note: find backlink and http in local" },
      ["<Localleader>afU"] = { UtilNote.find_url_and_backlinks_global, "Note: find backlink and http in global" },
    },
    ["i"] = {
      -- ├─────────────────────────────────┤ INSERT ├─────────────────────────────────┤
      ["C<cr>"] = { UtilNote.insert_tag, "Note: insert tag" },
      -- ["c<cr>"] = {
      --   function()
      --     UtilNote.last_insert_tag()
      --   end,
      --   "Note: repeat insert tag",
      -- },
      ["b<cr>"] = { UtilNote.insert_backlinks, "Note: insert backlink" },
      ["t<cr>"] = { UtilNote.insert_title_local, "Note: insert title local" },
      ["T<cr>"] = { UtilNote.insert_title_global, "Note: insert title global" },
    },
  }

  -- if vim.bo[bufnr].filetype == "orgagenda" then
  --   _keys["n"] = {
  --     -- ├────────────────────────────────┤ OPEN IN ├─────────────────────────────┤
  --     ["<c-s>"] = {
  --       function()
  --         UtilNote.open_item_heading_split()
  --       end,
  --       "Note: open in split",
  --     },
  --     ["<c-v>"] = {
  --       function()
  --         UtilNote.open_item_heading_vsplit()
  --       end,
  --       "Note: open in vsplit",
  --     },
  --     ["<c-t>"] = {
  --       function()
  --         UtilNote.open_item_heading_tab()
  --       end,
  --       "Note: open in tab",
  --     },
  --   }
  -- end

  set_keymaps(_keys, bufnr)
end

return M
