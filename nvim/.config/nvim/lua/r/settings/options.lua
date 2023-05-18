local root = vim.env.USER == "root"
local opt, fn, cmd = vim.opt, vim.fn, vim.cmd

return function()
    -- Load cfilter plugin allows filtering down an existing quickfix list
    cmd.packadd "cfilter"

    -- Load colorscheme
    as.pcall("theme failed to load because", cmd.colorscheme, as.colorscheme)

    -- opt.exrc = false -- ignore '~/.exrc'
    opt.secure = true
    opt.modelines = 1 -- read a modeline at EOF
    opt.errorbells = false -- disable error bells (no beep/flash)
    opt.termguicolors = true
    -- opt.autoread = true -- auto read file if changed outside of
    opt.wrap = false
    opt.fileformats = { "unix", "mac", "dos" }
    opt.clipboard = "unnamedplus"
    -- Exclude usetab as we do not want to jump to buffers in already open tabs
    -- do not use split or vsplit to ensure we don't open any new windows
    opt.switchbuf = "useopen,uselast"
    opt.encoding = "utf-8"
    -- opt.fileencoding = "utf-8"
    opt.backspace = { "eol", "start", "indent" }
    opt.conceallevel = 2
    opt.concealcursor = "nc"
    opt.guifont = "Fira Code:h9"
    -- This is from the help docs, it enables mode shapes, "Cursor" highlight, and
    -- blinking
    opt.guicursor = {
        [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
        [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
        [[sm:block-blinkwait175-blinkoff150-blinkon175]],
    }
    opt.incsearch = false
    opt.pumheight = 15
    opt.helpheight = 12
    opt.previewheight = 12
    opt.showmode = false -- show current mode (insert, etc) under the cmdline
    opt.showcmd = false -- show current command under the cmd line
    opt.cmdheight = 0 -- cmdline height: 0 1 2
    opt.laststatus = 1 -- 2 = always show status line (filename, etc)
    -- buat cursor selalu di tengah window, https://www.reddit.com/r/vim/comments/4kjgmz/weekly_vim_tips_and_tricks_thread_11/d3frprs
    -- tapi ada minus jika open file diff, secara bersebarangan
    opt.scrolloff = 3 -- 999
    opt.sidescrolloff = 8 -- min number of cols to keep between cursor and screen edge
    opt.textwidth = 80 -- max inserted text width for paste operations
    opt.linespace = 0 -- font spacing
    opt.ruler = true -- show line,col at the cursor pos
    opt.number = true -- show absolute line no. at the cursor pos
    opt.relativenumber = false -- otherwise, show relative numbers in the ruler
    opt.equalalways = false -- New vim windows created won't make everything back to same sizes
    opt.cursorline = false -- Show a line where the current cursor is
    opt.signcolumn = "yes" -- Show sign column as first column
    opt.wrap = false -- wrap long lines
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
        tab = "→ ",
        -- eol = "↴",
        -- nbsp = "␣",
        -- lead = "␣",
        -- space = "␣",
        trail = "•", -- unwanted spaces
        extends = "⟩",
        precedes = "⟨",
    }

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
    opt.shortmess = {
        t = true, -- truncate file messages at start
        A = true, -- ignore annoying swap file messages
        o = true, -- file-read message overwrites previous
        O = true, -- file-read message overwrites previous
        T = true, -- truncate non-file messages in middle
        f = true, -- (file x of x) instead of just (x of x
        F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
        s = true,
        c = true,
        W = true, -- Don't show [w] or written when writing
    }

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
    opt.smartindent = true -- add <tab> depending on syntax (C/C++)
    opt.startofline = false -- keep cursor column on navigation

    opt.tabstop = 2 -- Tab indentation levels every two columns
    opt.tabstop = 2 -- Tab indentation levels every two columns
    opt.softtabstop = 2 -- Tab indentation when mixing tabs & spaces
    opt.softtabstop = 2 -- Tab indentation when mixing tabs & spaces
    opt.shiftwidth = 2 -- Indent/outdent by two columns
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
    -- borrowed from tjdevries
    -- opt.formatoptions = o.formatoptions
    --     - "a" -- Auto formatting is BAD.
    --     - "t" -- Don't auto format my code. I got linters for that.
    --     + "c" -- In general, I like it when comments respect textwidth
    --     + "q" -- Allow formatting comments w/ gq
    --     - "o" -- O and o, don't continue comments
    --     + "r" -- But do continue when pressing enter.
    --     + "n" -- Indent past the formatlistpat, not underneath it.
    --     + "j" -- Auto-remove comments if possible.
    --     - "2" -- I'm not in gradeschool anymore

    opt.splitbelow = true -- ':new' ':split' below current
    opt.splitkeep = "screen"
    opt.splitright = true -- ':vnew' ':vsplit' right of current

    -----------------------------------------------------------------------------//
    -- Folds {{{1
    -----------------------------------------------------------------------------//
    opt.fillchars = {
        eob = " ", -- suppress ~ at EndOfBuffer
        diff = "╱", -- alternatives = ⣿ ░ ─
        msgsep = " ", -- alternatives: ‾ ─
        fold = " ",
        foldopen = "", -- '▼'
        foldclose = "", -- '▶'
        foldsep = " ",
    }
    opt.foldcolumn = "1" -- 0 is not bad
    -- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value

    -- unfortunately folding in (n)vim is a mess, if you set the fold level to start
    -- at X then it will auto fold anything at that level, all good so far. If you then
    -- try to edit the content of your fold and the foldmethod=manual then it will
    -- recompute the fold which when using nvim-ufo means it will be closed again...
    opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99

    opt.autochdir = false -- do not change dir when opening a file

    opt.magic = true --  use 'magic' chars in search patterns
    opt.hlsearch = true -- highlight all text matching current search pattern
    opt.incsearch = true -- show search matches as you type
    opt.ignorecase = true -- ignore case on search
    opt.smartcase = true -- case sensitive when search includes uppercase
    opt.showmatch = true -- highlight matching [{()}]
    opt.wrapscan = true -- begin search from top of the file when nothing is found

    -- opt.cpoptions = vim.o.cpoptions .. "x" -- stay on search item when <esc>
    opt.backup = false -- no backup file
    opt.writebackup = false -- do not backup file before write
    opt.undofile = true -- don't create root-owned files
    if root then
        opt.undofile = false -- don't create root-owned files
        opt.shada = ""
        opt.shadafile = "NONE"
    else
        opt.undofile = true -- actually use undo files
        opt.undodir = opt.undodir + "." -- fallback
        opt.shada = {
            "!",
            "'10",
            "/100",
            ":100",
            "<0",
            "@1",
            "f1",
            "h",
            "s1",
        }
    end
    opt.hidden = true -- do not unload buffer when abandoned
    opt.swapfile = false -- no swap file

    -----------------------------------------------------------------------------//
    -- Timings {{{1
    -----------------------------------------------------------------------------//
    opt.updatetime = 300
    opt.incsearch = false
    opt.timeoutlen = 500
    -- opt.ttimeoutlen = 10

    --[[
  ShDa (info for vim): session data history
  --------------------------------------------
  ! - Save and restore global variables (their names should be without lowercase letter).
  ' - Specify the maximum number of marked files remembered. It also saves the jump list and the change list.
  < - Maximum of lines saved for each register. All the lines are saved if this is not included, <0 to disable pessistent registers.
  % - Save and restore the buffer list. You can specify the maximum number of buffer stored with a number.
  / or : - Number of search patterns and entries from the command-line history saved. opt.history is used if it’s not specified.
  f - Store file (uppercase) marks, use 'f0' to disable.
  s - Specify the maximum size of an item’s content in KiB (kilobyte).
      For the info file, it only applies to register.
      For the shada file, it applies to all items except for the buffer list and header.
  h - Disable the effect of 'hlsearch' when loading the shada file.

  :oldfiles - all files with a mark in the shada file
  :rshada   - read the shada file (:rinfo for vim)
  :wshada   - write the shada file (:wrinfo for vim)
]]

    opt.shada = [[!,'100,<0,s100,h]]

    -----------------------------------------------------------------------------//
    -- Emoji {{{1
    -----------------------------------------------------------------------------//
    -- emoji is true by default but makes (n)vim treat all emoji as double width
    -- which breaks rendering so we turn this off.
    -- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
    opt.emoji = false

    -----------------------------------------------------------------------------//
    -- Diff {{{1
    -----------------------------------------------------------------------------//
    -- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
    opt.diffopt = opt.diffopt
        + {
            "vertical",
            "iwhite",
            "hiddenoff",
            "foldcolumn:0",
            "context:4",
            "algorithm:histogram",
            "indent-heuristic",
            "linematch:60",
        }

    opt.sessionoptions = {
        "globals",
        "buffers",
        "curdir",
        "help",
        "winpos",
        "tabpages",
    }
    opt.viewoptions = { "cursor", "folds" } -- save/restore just these (with `:{mk,load}view`)

    -- Use faster grep alternatives if possible
    if as and not as.falsy(fn.executable "rg") then
        vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
        opt.grepformat = opt.grepformat ^ { "%f:%l:%c:%m" }
    elseif as and not as.falsy(fn.executable "ag") then
        vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
        opt.grepformat = opt.grepformat ^ { "%f:%l:%c:%m" }
    end

    -- Disable providers we do not care a about
    vim.g.loaded_python_provider = 0 -- for python 2
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_node_provider = 0

    vim.g.glow_binary_path = as.home .. "/.local/bin"
    vim.g.python3_host_prog = as.home .. "/.config/neovim3/bin/python"
    vim.g.extra_whitespace_ignored_filetypes = {
        "alpha",
        "NvimTree",
        "TelescopePrompt",
    }
end
