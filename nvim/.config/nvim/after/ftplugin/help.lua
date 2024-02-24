-- if vim.bo.ma then
--   return
-- end

local keymap = vim.keymap
-- local opt_local = vim.opt_local

-- opt_local.number = false
-- opt_local.relativenumber = false
-- opt_local.signcolumn = "no"

keymap.set("n", "gd", "<c-]>", {
  buffer = true,
  desc = "Go to definition",
})

-- keymap.set("n", "<BS>", "<c-t>", {
--     buffer = true,
--     desc = "Go back last definition",
-- })

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

-- vim.bo.buflisted = false
-- vim.opt_local.conceallevel = 1
-- vim.opt_local.list = false
-- vim.opt_local.number = false
-- vim.opt_local.relativenumber = false
-- vim.opt_local.signcolumn = "no"
-- vim.opt_local.spell = false
-- vim.opt_local.statuscolumn = ""

-- open help buffers in new tabs by default
-- vim.cmd.wincmd "T"

-- get highlighted code examples
-- vim.treesitter.start()
