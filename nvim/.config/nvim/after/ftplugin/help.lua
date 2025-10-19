local keymap, opt_local = vim.keymap, vim.opt_local

opt_local.number = false
opt_local.relativenumber = false
opt_local.signcolumn = "no"
opt_local.buflisted = false
opt_local.conceallevel = 2

-- open help buffers in new tabs by default
-- vim.cmd.wincmd "L"

keymap.set("n", "gd", "<c-]>", {
  buffer = true,
  desc = "Help: go to definition",
})

keymap.set("n", "<Leader>ld", "<c-]>", {
  buffer = true,
  desc = "Help: go to definition",
})

keymap.set("n", "<BS>", "<c-t>", {
  buffer = true,
  desc = "Help: go back last definition",
})

-- " if this a vim help file rather than one I'm creating
-- " add mappings otherwise do not
-- if &l:buftype == 'help' || expand('%') =~# '^'.$VIMRUNTIME
--   nnoremap <buffer> q :<c-u>q<cr>
--   " nnoremap <silent><buffer> <c-p> :Helptags<cr>
--   " keymap: [help] easy to jump on help filetype
--   nnoremap <silent><buffer> o /'\l\{2,\}'<CR>
--   nnoremap <silent><buffer> O ?'\l\{2,\}'<CR>
--   nnoremap <silent><buffer> s /\|\zs\S\+\ze\|<CR>
--   nnoremap <silent><buffer> S ?\|\zs\S\+\ze\|<CR>
--   finish
-- endif
