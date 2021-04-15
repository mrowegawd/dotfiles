local k = require("astronauta.keymap")
local nnoremap = k.nnoremap
-- local vnoremap = k.vnoremap
-- local noremap = k.noremap
-- local inoremap = k.inoremap
-- local nmap = k.nmap
-- local xmap = k.xmap

local general_mappings = {

  -- POMODORO ------------------------------------------------------------- {{{
  -- ["<localleader>rps"] = "<cmd>lua require('modules._tools').pomorun('toggle')<CR>",
  -- ["<localleader>rpp"] = "<cmd>lua require('modules._tools').pomorun('pause')<CR>",
  -- ["<localleader>rpr"] = "<cmd>lua require('modules._tools').pomorun('resume')<CR>",
  -- }}}
  -- TELESCOPE ------------------------------------------------------------ {{{
  ["<localleader>ff"] = require("plugins._telescope").files,
  ["<localleader>fb"] = require("telescope.builtin").buffers,
  ["<localleader>ft"] = ":Telescope builtin<CR>",
  ["<localleader>fm"] = require("telescope.builtin").keymaps,
  ["<localleader>fc"] = require("telescope.builtin").git_status,
  ["<localleader>fg"] = require("plugins._telescope").grep_prompt,
  ["<localleader>fG"] = require("plugins._telescope").grep_prompt_word,

  ["<localleader>fh"] = require("telescope.builtin").help_tags,
  ["<localleader>fo"] = require("telescope.builtin").oldfiles,
  -- ["<localleader>fl"] = require("plugins._telescope").buffer_fuzzy,
  -- ["<C-g>m"] = require("telescope").extensions.media_files.media_files,
  -- ["<leader>fa"] = require("plugins._telescope").arecibo,
  -- ["<localleader>fo"] = require("plugins._telescope").file_browser,
  -- }}}

}

for j, v in pairs(general_mappings) do
  nnoremap({ j, v, { silent = true } })
end

-- vim: foldmethod=marker foldlevel=0
