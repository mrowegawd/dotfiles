-- vim: foldmethod=marker foldlevel=0
local opt, fn, g, env, loop = vim.opt, vim.fn, vim.g, vim.env, vim.uv

g.projects_dir = env.PROJECTS_DIR or fn.expand "~/projects"
g.dotfiles = env.DOTFILES or fn.expand "~/.dotfiles"
g.os = loop.os_uname().sysname

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- LazyVim completion engine to use.
-- Can be one of: nvimcmp, blink.cmp
-- Leave it to "auto" to automatically use the completion engine
-- enabled with `:LazyExtras`
vim.g.lazyvim_cmp = "auto"

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = "auto"

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

vim.g.is_preview_markdown_off = true
vim.g.is_lsplines_off = false

vim.g.open_command = g.os == "Darwin" and "open" or "xdg-open"
vim.g.vim_dir = g.dotfiles .. "/.config/nvim"
vim.g.work_dir = g.projects_dir .. "/work"
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_matchparen = 1
-- vim.g.health = { style = "float" } -- make :checkhealth float window

-- {{{ Generals
opt.winborder = "none"
opt.mousescroll = "ver:3,hor:6"
opt.termguicolors = true -- tmux need this!
opt.secure = true
opt.modelines = 1 -- read a modeline at EOF
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.completeopt = "menuone,noinsert"
opt.spelloptions:append "noplainbuffer"
opt.errorbells = false -- disable error bells (no beep/flash)
opt.visualbell = false
opt.jumpoptions = "view" -- mapping jump c-i/o is suck, so I use `stack` mode (agar level insane berkurang diotak)
opt.cursorline = true
opt.inccommand = "split"
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.fileformats = { "unix", "mac", "dos" }
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.encoding = "utf-8"
opt.conceallevel = 2
opt.infercase = true -- Infer cases in keyword completion
opt.concealcursor = "nc"
opt.guifont = "SF Mono:h11"
opt.pumheight = 20
opt.helpheight = 12
opt.previewheight = 12
opt.showmode = false -- show current mode (insert, etc) under the cmdline
opt.showcmd = false -- show current command under the cmd line
opt.cmdheight = 0 -- cmdline height: 0 1 2
opt.laststatus = 3 -- 2 = always show status line (filename, etc)
opt.textwidth = 80 -- max inserted text width for paste operations
opt.linespace = 0 -- font spacing
opt.ruler = false -- disable default ruler, 'ruler' is -> show line,col at the cursor pos
opt.signcolumn = "yes:1" -- Always show the sign column
opt.number = true -- show absolute line no. at the cursor pos
opt.relativenumber = false -- otherwise, show relative numbers in the ruler
opt.breakindent = true -- start wrapped lines indented
opt.linebreak = true -- do not break words on line wrap
opt.showbreak = "↪ "
-- }}}
-- {{{ List chars
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = {
  eol = nil,
  tab = "→ ", -- Alternatives: '▷▷',
  extends = "…", -- Alternatives: … » ›
  precedes = "░", -- Alternatives: … « ‹
  trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-- }}}
-- {{{ Message output on vim actions
opt.shortmess:append { W = true, I = true, c = true, C = true }
-- }}}
-- {{{ Wild and file globbing stuff in command mode
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
opt.guicursor = "" -- disable cursor shape modes nvim,
opt.tabstop = 2 -- Tab indentation levels every two columns
opt.softtabstop = 2 -- Tab indentation when mixing tabs & spaces
opt.shiftwidth = 2 -- Indent/outdent by two columns
opt.shiftround = true -- Always indent/outdent to nearest tabstop
opt.expandtab = true -- Convert all tabs that are typed into spaces
opt.smarttab = true -- Use shiftwidths at left margin, tabstops everywhere else
opt.statuscolumn = [[%!v:lua.require'r.utils'.ui.get()]] -- ex:"%=%{&nu ? v:relnum && mode() != 'i' ? v:relnum : v:lnum : ''} %s%C"
opt.formatexpr = "v:lua.require'r.utils'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.splitkeep = "cursor" -- cursor, screen
opt.splitbelow = true -- ':new' ':split' below current
opt.splitright = true -- ':vnew' ':vsplit' right of current
opt.equalalways = false -- New vim windows created won't make everything back to same sizes
-- }}}
-- {{{ Folds
opt.fillchars = {
  eob = " ", -- suppress ~ at endofbuffer
  diff = "░", -- alternatives = ⣿ ░ ╱
  -- msgsep = " ", -- alternatives: ‾ ─
  --
  -- fold = "▶",
  vert = "│", -- "¦", "┃", "┃", "\\", "▕", "│"
  -- horiz = "-",
  -- horiz = "▁",
  foldopen = "", -- '▼'
  foldclose = "", -- '▶'
  foldsep = " ",
}
opt.foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil -- show foldcolumn in nvim 0.9
opt.foldlevelstart = 99 -- start with all code unfolded
opt.foldlevel = 99 -- using ufo provider need a large value, feel free to decrease the value
opt.magic = true --  use 'magic' chars in search patterns
opt.hlsearch = true -- highlight all text matching current search pattern
opt.incsearch = true -- show search matches as you type
opt.ignorecase = true -- ignore case on search
opt.smartcase = true -- case sensitive when search includes uppercase
opt.showmatch = true -- highlight matching [{()}]
opt.wrapscan = true -- begin search from top of the file when nothing is found
opt.hidden = true -- do not unload buffer when abandoned
-- }}}
-- {{{ Timings
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.undodir = vim.fn.stdpath "data" .. "/undodir" -- Chooses where to store the undodir
opt.history = 1000 -- Number of commands to remember in a history table (per buffer).
opt.swapfile = false -- Ask what state to recover when opening a file that was not saved.
opt.backup = false -- no backup file
opt.writebackup = false -- do not backup file before write
opt.undofile = true -- don't create root-owned files
opt.wrap = false -- Disable wrapping of lines longer than the width of window.
opt.mouse = "a" -- Enable mouse support.
opt.autochdir = false -- Use current file dir as working dir (See project.nvim)
opt.scrolloff = 5 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
opt.sidescrolloff = 3 -- Same but for side scrolling.
opt.sidescroll = 1
opt.selection = "old" -- Don't select the newline symbol when using <End> on visual mode
-- }}}
-- {{{ Emoji
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- credit: https://www.youtube.com/watch?v=f91vwoelfne
opt.emoji = false
-- }}}
-- {{{ Diff
-- use in vertical diff mode, blank lines to keep sides aligned, ignore whitespace changes
vim.opt.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"
-- }}}
-- {{{ Sessions
-- NOTE: remove "folds" dari sessionoptions tampak nya menghilangkan error "no fold found error"
-- ketika session di restore, relate issue: https://github.com/jedrzejboczar/possession.nvim/issues/19#issuecomment-1323804180
opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "globals",
  "help",
  "localoptions",
  "skiprtp",
  "tabpages",
  "tabpages",
  "terminal",
  "winpos",
  "winsize",
}
-- }}}
-- {{{ Providers
-- Disable providers we do not care a about
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 1 -- for python 2
vim.g.loaded_python3_provider = 1
vim.g.python3_host_prog = os.getenv "HOME" .. "/.config/neovim3/bin/python"

local enable_providers = {
  "python3_provider",
  "node_provider",
  -- and so on
}

for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end
-- }}}
-- {{{ Neovide stuff
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_hide_mouse_when_typing = true
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

  vim.keymap.set("", "<C-0>", "<CMD>lua vim.g.neovide_scale_factor = 1<CR>", { noremap = true })
  -- vim.keymap.set("i", "<C-S-v>", "<C-r>+", { noremap = true })

  vim.g.neovide_opacity = 0.94

  -- Helper function for transparency formatting
  -- local alpha = function()
  --   return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
  -- end

  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
end
-- }}}
-- {{{ Filetype detection
vim.filetype.add {
  filename = {
    Brewfile = "ruby",
    justfile = "just",
    Justfile = "just",
    Tmuxfile = "tmux",
    ["yarn.lock"] = "yaml",
    [".buckconfig"] = "toml",
    [".flowconfig"] = "ini",
    [".jsbeautifyrc"] = "json",
    [".jscsrc"] = "json",
    [".watchmanconfig"] = "json",
    ["dev-requirements.txt"] = "requirements",
    ["helmfile.yaml"] = "yaml",
  },
  pattern = {
    [".*%.js%.map"] = "json",
    [".*%.postman_collection"] = "json",
    ["Jenkinsfile.*"] = "groovy",
    ["%.kube/config"] = "yaml",
    ["%.config/git/users/.*"] = "gitconfig",
    ["requirements-.*%.txt"] = "requirements",
    [".*/templates/.*%.ya?ml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
  },
}
-- }}}
-- {{{ Plugin var globals
-- Plugin: azabiong/vim-highlighter
-- delete jika tidak dibutuhkan or commented
vim.g.HiSet = ""
vim.g.HiErase = ""
vim.g.HiClear = ""
vim.g.HiFind = ""
vim.g.HiSetSL = ""
vim.g.HiFindTool = "rg -H --color=never --no-heading --column --smart-case"

-- plugin: ggandor/lightspeed.nvim
vim.g.lightspeed_no_default_keymaps = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- plugin: mbbill/undotree
vim.g.undotree_WindowLayout = 2
-- vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_DiffCommand = "diff -u"

-- if vim.env.PROF then
--   -- example for lazy.nvim
--   -- change this to the correct path for your plugin manager
--   local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
--   vim.opt.rtp:append(snacks)
--   require("snacks.profiler").startup {
--     startup = {
--       event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
--       -- event = "UIEnter",
--       -- event = "VeryLazy",
--     },
--   }
-- end

-- }}}
-- {{{ Foldexpr, foldtext, smoothscroll
if vim.fn.has "nvim-0.10" == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'r.utils'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'r.utils'.ui.foldtext()"
end
-- }}}
