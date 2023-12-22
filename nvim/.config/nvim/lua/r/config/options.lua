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
  opt = {
    secure = true,
    modelines = 1, -- read a modeline at EOF
    confirm = false, -- Confirm to save changes before exiting modified buffer

    errorbells = false, -- disable error bells (no beep/flash)
    visualbell = false,

    jumpoptions = "stack", -- ketika <c-i> dan <c-o>, lebih enak jump last cursor daripada window
    cursorline = true,
    inccommand = "split",
    virtualedit = "block", -- Allow cursor to move where there is no text in visual block mode
    fileformats = { "unix", "mac", "dos" },

    clipboard = "unnamedplus",
    -- Exclude usetab as we do not want to jump to buffers in already open tabs
    -- do not use split or vsplit to ensure we don't open any new windows
    switchbuf = "useopen,uselast",
    encoding = "utf-8",
    conceallevel = 2,
    infercase = true, -- Infer cases in keyword completion
    concealcursor = "nc",
    guifont = "Fira Code:h7.5",
    pumheight = 15,
    helpheight = 12,
    previewheight = 12,
    showmode = false, -- show current mode (insert, etc) under the cmdline
    showcmd = false, -- show current command under the cmd line
    cmdheight = 0, -- cmdline height: 0 1 2
    laststatus = 3, -- 2 = always show status line (filename, etc)
    textwidth = 80, -- max inserted text width for paste operations
    linespace = 0, -- font spacing
    ruler = true, -- show line,col at the cursor pos
    signcolumn = "yes", -- Always show the sign column
    number = true, -- show absolute line no. at the cursor pos
    relativenumber = true, -- otherwise, show relative numbers in the ruler
    breakindent = true, -- start wrapped lines indented
    linebreak = true, -- do not break words on line wrap
    showbreak = "↪ ",
    -----------------------------------------------------------------------------//
    -- List chars {{{
    -----------------------------------------------------------------------------//
    list = true, -- invisible chars
    -- Characters to display on ':set list',explore glyphs using:
    -- `xfd -fa "InputMonoNerdFont:style:Regular"` or
    -- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
    -- input special chars with the sequence <C-v-u> followed by the hex code
    listchars = {
      eol = nil,
      tab = "→ ", -- Alternatives: '▷▷',
      extends = "…", -- Alternatives: … » ›
      precedes = "░", -- Alternatives: … « ‹
      trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
    },

    -----------------------------------------------------------------------------//
    -- Message output on vim actions {{{1
    -----------------------------------------------------------------------------//
    shortmess = opt.shortmess:append { W = true, I = true, c = true, C = true }, -- copied default and removed `t` (long paths were being truncated) while adding `c`

    -----------------------------------------------------------------------------//
    -- Wild and file globbing stuff in command mode {{{1
    -----------------------------------------------------------------------------//
    wildmode = "longest:full,full",
    wildignore = {
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
    },
    wildoptions = { "pum", "fuzzy" }, --Show completion items using the pop-up-menu (pum)
    pumblend = 0, -- Make popup window translucent

    joinspaces = true, -- insert spaces after '.?!' when joining lines
    autoindent = true, -- copy indent from current line on newline
    smartindent = false, -- add <tab> depending on syntax (C/C++)
    startofline = false, -- keep cursor column on navigation

    tabstop = 2, -- Tab indentation levels every two columns
    softtabstop = 2, -- Tab indentation when mixing tabs & spaces
    shiftwidth = 2, -- Indent/outdent by two columns
    shiftround = true, -- Always indent/outdent to nearest tabstop
    expandtab = true, -- Convert all tabs that are typed into spaces
    smarttab = true, -- Use shiftwidths at left margin, tabstops everywhere else

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
    formatoptions = "jtcqln", -- tcqj

    splitkeep = "cursor", -- cursor, screen
    splitbelow = true, -- ':new' ':split' below current
    splitright = true, -- ':vnew' ':vsplit' right of current
    equalalways = false, -- New vim windows created won't make everything back to same sizes
    -----------------------------------------------------------------------------//
    -- folds {{{1
    -----------------------------------------------------------------------------//
    fillchars = {
      eob = " ", -- suppress ~ at endofbuffer
      diff = "⣿", -- alternatives = ⣿ ░ ╱
      msgsep = " ", -- alternatives: ‾ ─
      fold = " ",
      foldopen = "", -- '▼'
      foldclose = "", -- '▶'
      foldsep = " ",
    },

    foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil, -- show foldcolumn in nvim 0.9
    foldlevelstart = 99, -- start with all code unfolded
    -- unfortunately folding in (n)vim is a mess, if you set the fold level to start
    -- at x then it will auto fold anything at that level, all good so far. if you then
    -- try to edit the content of your fold and the foldmethod=manual then it will
    -- recompute the fold which when using nvim-ufo means it will be closed again...
    foldlevel = 99, -- using ufo provider need a large value, feel free to decrease the value

    magic = true, --  use 'magic' chars in search patterns
    hlsearch = true, -- highlight all text matching current search pattern
    incsearch = true, -- show search matches as you type
    ignorecase = true, -- ignore case on search
    smartcase = true, -- case sensitive when search includes uppercase
    showmatch = true, -- highlight matching [{()}]
    wrapscan = true, -- begin search from top of the file when nothing is found
    cpoptions = vim.o.cpoptions .. "x", -- stay on search item when <esc>
    hidden = true, -- do not unload buffer when abandoned

    -----------------------------------------------------------------------------//
    -- timings {{{1
    -----------------------------------------------------------------------------//
    updatetime = 50,
    -- timeoutlen = 300,

    -- wierd tmux esc-j/k line switch issue fix
    -- https://github.com/LazyVim/LazyVim/discussions/163
    timeoutlen = 1000,
    ttimeoutlen = 0,

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
    undodir = vim.fn.stdpath "data" .. "/undodir", -- Chooses where to store the undodir
    history = 1000, -- Number of commands to remember in a history table (per buffer).
    swapfile = false, -- Ask what state to recover when opening a file that was not saved.
    backup = false, -- no backup file
    writebackup = false, -- do not backup file before write
    undofile = true, -- don't create root-owned files
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
    wrap = false, -- Disable wrapping of lines longer than the width of window.
    mouse = "a", -- Enable mouse support.
    -- mousescroll = "ver:0,hor:0", -- "ver:1,hor:0", -- Disables hozirontal scroll in neovim.
    guicursor = "n:blinkon200,i-ci-ve:ver25", -- Enable cursor blink.
    autochdir = false, -- Use current file dir as working dir (See project.nvim)
    scrolloff = 5, -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
    sidescrolloff = 3, -- Same but for side scrolling.
    sidescroll = 1,
    selection = "old", -- Don't select the newline symbol when using <End> on visual mode

    -----------------------------------------------------------------------------//
    -- emoji {{{1
    -----------------------------------------------------------------------------//
    -- emoji is true by default but makes (n)vim treat all emoji as double width
    -- which breaks rendering so we turn this off.
    -- credit: https://www.youtube.com/watch?v=f91vwoelfne
    emoji = false,

    -----------------------------------------------------------------------------//
    -- diff {{{1
    -----------------------------------------------------------------------------//
    -- use in vertical diff mode, blank lines to keep sides aligned, ignore whitespace changes
    diffopt = opt.diffopt + {
      -- "vertical",
      -- "iwhite",
      -- "hiddenoff",
      -- "foldcolumn:0",
      -- "context:4",
      "algorithm:histogram",
      -- "indent-heuristic",
      -- "linematch:60",
    },
    sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
  },
}

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
