local opt, fn, g, env, loop = vim.opt, vim.fn, vim.g, vim.env, vim.uv

g.projects_dir = env.PROJECTS_DIR or fn.expand "~/projects"
g.dotfiles = env.DOTFILES or fn.expand "~/.dotfiles"
g.os = loop.os_uname().sysname

local options = {
  g = {
    open_command = g.os == "Darwin" and "open" or "xdg-open",
    vim_dir = g.dotfiles .. "/.config/nvim",
    work_dir = g.projects_dir .. "/work",
    mapleader = " ",
    maplocalleader = ",",
  },
}

opt.secure = true
opt.modelines = 1 -- read a modeline at EOF
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.completeopt = "menu,menuone,noselect"

opt.errorbells = false -- disable error bells (no beep/flash)
opt.visualbell = false

opt.jumpoptions = "stack" -- ketika <c-i> dan <c-o>, lebih enak jump last cursor daripada window
opt.cursorline = true
opt.inccommand = "split"
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.fileformats = { "unix", "mac", "dos" }

opt.clipboard = "unnamedplus"
-- -- Exclude usetab as we do not want to jump to buffers in already open tabs
-- -- do not use split or vsplit to ensure we don't open any new windows
opt.switchbuf = "useopen,uselast"
opt.encoding = "utf-8"
opt.conceallevel = 2
opt.infercase = true -- Infer cases in keyword completion
opt.concealcursor = "nc"
opt.guifont = "JetBrains Mono:h11"
opt.pumheight = 15
opt.helpheight = 12
opt.previewheight = 12
opt.showmode = false -- show current mode (insert, etc) under the cmdline
opt.showcmd = false -- show current command under the cmd line
opt.cmdheight = 0 -- cmdline height: 0 1 2
opt.laststatus = 3 -- 2 = always show status line (filename, etc)
opt.textwidth = 80 -- max inserted text width for paste operations
opt.linespace = 0 -- font spacing
opt.ruler = true -- show line,col at the cursor pos
opt.signcolumn = "yes:1" -- Always show the sign column
opt.number = true -- show absolute line no. at the cursor pos
opt.relativenumber = true -- otherwise, show relative numbers in the ruler
opt.breakindent = true -- start wrapped lines indented
opt.linebreak = true -- do not break words on line wrap
opt.showbreak = "↪ "
-----------------------------------------------------------------------------//
-- List chars {{{
-----------------------------------------------------------------------------//
opt.list = true -- invisible chars
-- Characters to display on ':set list',explore glyphs using:
-- `xfd -fa "InputMonoNerdFont:style:Regular"` or
-- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
-- input special chars with the sequence <C-v-u> followed by the hex code
opt.listchars = {
  eol = nil,
  tab = "→ ", -- Alternatives: '▷▷',
  extends = "…", -- Alternatives: … » ›
  precedes = "░", -- Alternatives: … « ‹
  trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}

-----------------------------------------------------------------------------//
-- Message output on vim actions {{{1
-----------------------------------------------------------------------------//
opt.shortmess = opt.shortmess:append { W = true, I = true, c = true, C = true } -- copied default and removed `t` (long paths were being truncated) while adding `c`

-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
opt.wildmode = "longest:full,full"
opt.wildignore = {
  "*.aux",
  "*.out",
  "*.toc",
  "*.o",
  "*.obj",
  "*.dll",
  "*.jar",
  "*.pyc",
  "*.rbc",
  "*.class",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.avi",
  "*.wav",
  -- Temp/System
  "*.*~",
  "*~ ",
  "*.swp",
  ".lock",
  ".DS_Store",
  "tags.lock",
}
opt.wildoptions = { "pum", "fuzzy" } --Show completion items using the pop-up-menu (pum)
opt.pumblend = 0 -- Make popup window translucent

opt.joinspaces = true -- insert spaces after '.?!' when joining lines
opt.autoindent = true -- copy indent from current line on newline
opt.smartindent = false -- add <tab> depending on syntax (C/C++)
opt.startofline = false -- keep cursor column on navigation

opt.tabstop = 2 -- Tab indentation levels every two columns
opt.softtabstop = 2 -- Tab indentation when mixing tabs & spaces
opt.shiftwidth = 2 -- Indent/outdent by two columns
opt.shiftround = true -- Always indent/outdent to nearest tabstop
opt.expandtab = true -- Convert all tabs that are typed into spaces
opt.smarttab = true -- Use shiftwidths at left margin, tabstops everywhere else

-- c: auto-wrap comments using textwidth
-- r: auto-insert the current comment leader after hitting <Enter>
-- o: auto-insert the current comment leader after hitting 'o' or 'O'
-- q: allow formatting comments with 'gq'
-- n: recognize numbered lists
-- 1: don't break a line after a one-letter word
-- j: remove comment leader when it makes sense
-- this gets overwritten by ftplugins (:verb set fo)
-- we use autocmd to remove 'o' in '/lua/autocmd.lua'
-- [comments borrowed from tjdevries]
opt.formatoptions = "jtcqln" -- tcqj

opt.splitkeep = "cursor" -- cursor, screen
opt.splitbelow = true -- ':new' ':split' below current
opt.splitright = true -- ':vnew' ':vsplit' right of current
opt.equalalways = false -- New vim windows created won't make everything back to same sizes
-----------------------------------------------------------------------------//
-- folds {{{1
-----------------------------------------------------------------------------//
opt.fillchars = {
  eob = " ", -- suppress ~ at endofbuffer
  diff = "⣿", -- alternatives = ⣿ ░ ╱
  msgsep = " ", -- alternatives: ‾ ─
  fold = " ",
  vert = "┃",
  foldopen = "", -- '▼'
  foldclose = "", -- '▶'
  foldsep = " ",
}

opt.foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil -- show foldcolumn in nvim 0.9
opt.foldlevelstart = 99 -- start with all code unfolded
-- unfortunately folding in (n)vim is a mess, if you set the fold level to start
-- at x then it will auto fold anything at that level, all good so far. if you then
-- try to edit the content of your fold and the foldmethod=manual then it will
-- recompute the fold which when using nvim-ufo means it will be closed again...
opt.foldlevel = 99 -- using ufo provider need a large value, feel free to decrease the value

opt.magic = true --  use 'magic' chars in search patterns
opt.hlsearch = true -- highlight all text matching current search pattern
opt.incsearch = true -- show search matches as you type
opt.ignorecase = true -- ignore case on search
opt.smartcase = true -- case sensitive when search includes uppercase
opt.showmatch = true -- highlight matching [{()}]
opt.wrapscan = true -- begin search from top of the file when nothing is found
opt.hidden = true -- do not unload buffer when abandoned

-----------------------------------------------------------------------------//
-- timings {{{1
-----------------------------------------------------------------------------//
-- updatetime = 50
opt.updatetime = 300
opt.timeout = true
-- timeoutlen = 300,
opt.timeoutlen = 500
opt.ttimeoutlen = 10

--[[
     shda (info for vim): session data history
     --------------------------------------------
     ! - save and restore global variables (their names should be without lowercase letter).
     ' - specify the maximum number of marked files remembered. it also saves the jump list and the change list.
     < - maximum of lines saved for each register. all the lines are saved if this is not included, <0 to disable pessistent registers.
     % - save and restore the buffer list. you can specify the maximum number of buffer stored with a number.
     / or : - number of search patterns and entries from the command-line history saved. opt.history is used if it’s not specified.
     f - store file (uppercase) marks, use 'f0' to disable.
     s - specify the maximum size of an item’s content in kib (kilobyte).
         for the info file, it only applies to register.
         for the shada file, it applies to all items except for the buffer list and header.
     h - disable the effect of 'hlsearch' when loading the shada file.

     :oldfiles - all files with a mark in the shada file
     :rshada   - read the shada file (:rinfo for vim)
     :wshada   - write the shada file (:wrinfo for vim)
    -- ]]
-- shada = [[!,'100,<0,s100,h]],

-- Aditions
opt.undodir = vim.fn.stdpath "data" .. "/undodir" -- Chooses where to store the undodir
opt.history = 1000 -- Number of commands to remember in a history table (per buffer).
opt.swapfile = false -- Ask what state to recover when opening a file that was not saved.
opt.backup = false -- no backup file
opt.writebackup = false -- do not backup file before write
opt.undofile = true -- don't create root-owned files
-- if root then
--     opt.undofile = false -- don't create root-owned files
--     opt.shada = ""
--     opt.shadafile = "none"
-- else
--     opt.undofile = true -- actually use undo files
--     opt.undodir = opt.undodir + "." -- fallback
--     opt.shada = {
--         "!",
--         "'10",
--         "/100",
--         ":100",
--         "<0",
--         "@1",
--         "f1",
--         "h",
--         "s1",
--     }
-- end
opt.wrap = false -- Disable wrapping of lines longer than the width of window.
opt.mouse = "a" -- Enable mouse support.
-- mousescroll = "ver:0,hor:0", -- "ver:1,hor:0", -- Disables hozirontal scroll in neovim.
opt.guicursor = "n:blinkon200,i-ci-ve:ver25" -- Enable cursor blink.
opt.autochdir = false -- Use current file dir as working dir (See project.nvim)
opt.scrolloff = 5 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
opt.sidescrolloff = 3 -- Same but for side scrolling.
opt.sidescroll = 1
opt.selection = "old" -- Don't select the newline symbol when using <End> on visual mode

-----------------------------------------------------------------------------//
-- emoji {{{1
-----------------------------------------------------------------------------//
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- credit: https://www.youtube.com/watch?v=f91vwoelfne
opt.emoji = false

-----------------------------------------------------------------------------//
-- diff {{{1
-----------------------------------------------------------------------------//
-- use in vertical diff mode, blank lines to keep sides aligned, ignore whitespace changes
opt.diffopt = opt.diffopt
  + {
    -- "vertical",
    -- "iwhite",
    -- "hiddenoff",
    -- "foldcolumn:0",
    -- "context:4",
    "algorithm:histogram",
    -- "indent-heuristic",
    -- "linematch:60",
  }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end

if vim.fn.has "nvim-0.10" == 1 then
  opt.smoothscroll = true
end

if vim.treesitter.foldtext then
  opt.foldtext = "v:lua.require'r.utils'.ui.foldtext()"
end

if vim.fn.has "nvim-0.9.0" == 1 then
  opt.statuscolumn = [[%!v:lua.require'r.utils'.ui.statuscolumn()]]
end

if vim.fn.has "nvim-0.10" == 1 then
  opt.foldmethod = "expr"
  -- opt.foldexpr = "v:lua.require'r.utils'.ui.foldexpr()"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
else
  opt.foldmethod = "indent"
end

vim.o.formatexpr = "v:lua.require'r.utils'.format.formatexpr()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Disable providers we do not care a about
-- vim.g.loaded_python_provider = 0 -- for python 2
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- vim.g.python3_host_prog = os.getenv "HOME" .. "/.config/neovim3/bin/python"

package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua;"

-- vim.g.nvim_tree_disable_netrw = 0
-- vim.g.nvim_tree_hijack_netrw = 0
-- -- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_vfx_mode = "railgun"

  vim.keymap.set("", "<C-=>", function()
    local _, _, font_size = vim.o.guifont:find ".*:h(%d+)$"
    font_size = tostring(tonumber(font_size) + 1)
    vim.o.guifont = string.gsub(vim.o.guifont, "%d+$", font_size)
  end, { noremap = true })
  vim.keymap.set("", "<C-->", function()
    local _, _, font_size = vim.o.guifont:find ".*:h(%d+)$"
    if tonumber(font_size) > 1 then
      font_size = tostring(tonumber(font_size) - 1)
      vim.o.guifont = string.gsub(vim.o.guifont, "%d+$", font_size)
    end
  end, { noremap = true })

  vim.keymap.set("i", "<C-S-v>", "<C-r>+", { noremap = true })
end
