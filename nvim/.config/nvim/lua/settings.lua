-- vim: foldmethod=marker foldlevel=0
local o, opt = vim.o, vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- {{{ Generals
o.jumpoptions = "view" -- mapping jump c-i/o is suck, so use default aja, yang `clean`
o.breakindent = true -- start wrapped lines indented
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard, but its slow
o.cmdheight = 0 -- cmdline height: 0 1 2
o.completeopt = "menuone,noinsert"
o.concealcursor = "nc"
o.conceallevel = 2
o.confirm = false -- Confirm to save changes before exiting modified buffer
o.cursorline = true
o.encoding = "utf-8"
o.errorbells = false -- disable error bells (no beep/flash)
opt.fileformats = { "unix", "mac", "dos" }
o.guifont = "SF Mono:h11"
o.helpheight = 12
o.hidden = true -- do not unload buffer when abandoned
o.hlsearch = true -- highlight all text matching current search pattern
o.ignorecase = true -- ignore case on search
o.inccommand = "split"
o.incsearch = true -- show search matches as you type
o.infercase = true -- Infer cases in keyword completion
o.laststatus = 3 -- 2 = always show status line (filename, etc)
o.linebreak = true -- do not break words on line wrap
o.linespace = 0 -- font spacing
o.magic = true --  use 'magic' chars in search patterns
o.modelines = 1 -- read a modeline at EOF
o.mousescroll = "ver:3,hor:6"
o.number = true -- show absolute line no. at the cursor pos
o.pumheight = 20
o.relativenumber = false -- otherwise, show relative numbers in the ruler
o.ruler = false -- disable default ruler, 'ruler' is -> show line,col at the cursor pos
o.secure = true
o.showbreak = "↪ "
o.showcmd = false -- show current command under the cmd line
o.showmatch = true -- highlight matching [{()}]
o.showmode = false -- show current mode (insert, etc) under the cmdline
o.signcolumn = "yes:1" -- Always show the sign column
o.smartcase = true -- case sensitive when search includes uppercase
o.smoothscroll = true
opt.spelloptions:append "noplainbuffer"
o.termguicolors = true -- tmux need this!
o.textwidth = 80 -- max inserted text width for paste operations
o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
o.visualbell = false
o.winborder = "none" -- "none", "rounded"
o.wrapscan = true -- begin search from top of the file when nothing is found
-- }}}
-- {{{ List chars
o.list = true -- Show some invisible characters (tabs...
opt.listchars = {
  eol = nil,
  tab = "→ ", -- Alternatives: '▷▷',
  extends = "»", -- Alternatives: … » › ░
  precedes = "«", -- Alternatives: … « ‹ ░
  trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-- }}}
-- {{{ Message output on vim actions
-- opt.shortmess:append { W = true, I = true, c = true, C = true }
-- }}}
-- {{{ Wild and file globbing stuff in command mode
o.wildmode = "longest:full,full"
-- opt.wildignore = {
--   "*.aux",
--   "*.out",
--   "*.toc",
--   "*.o",
--   "*.obj",
--   "*.dll",
--   "*.jar",
--   "*.pyc",
--   "*.rbc",
--   "*.class",
--   "*.gif",
--   "*.ico",
--   "*.jpg",
--   "*.jpeg",
--   "*.png",
--   "*.avi",
--   "*.wav",
--   -- Temp/System
--   "*.*~",
--   "*~ ",
--   "*.swp",
--   ".lock",
--   ".DS_Store",
--   "tags.lock",
-- }

-- vim.opt.wildignore:append "*.png,*.jpg,*.jpeg,*.gif,*.wav,*.aiff,*.dll,*.pdb,*.mdb,*.so,*.swp,*.zip,*.gz,*.bz2,*.meta,*.svg,*.cache,*/.git/*"

-- opt.wildignore:append { "*/.git/*", "*/node_modules/*", "*/.venv/*", "*/venv/*", "*/__pycache__/*", ".DS_Store" }

-- opt.wildignore:append {
--   ".git",
--   ".hg",
--   ".svn",
--   ".stversions",
--   "*.spl",
--   "%*",
--   "*.zip",
--   "**/tmp/**",
--   "**/node_modules/**",
--   "**/bower_modules/**",
--   "*/.sass-cache/*",
--   "application/vendor/**",
--   "**/vendor/ckeditor/**",
--   "media/vendor/**",
--   "__pycache__",
--   "*.egg-info",
--   "*vim/backups*",
-- }
opt.wildoptions = { "pum", "fuzzy" } --Show completion items using the pop-up-menu (pum)
-- opt.pumblend = 0 -- Make popup window translucent

o.joinspaces = true -- insert spaces after '.?!' when joining lines
o.autoindent = true -- copy indent from current line on newline
o.smartindent = false -- add <tab> depending on syntax (C/C++)
o.startofline = false -- keep cursor column on navigation
o.guicursor = "" -- disable cursor shape modes nvim,
o.tabstop = 2 -- Tab indentation levels every two columns
o.softtabstop = 2 -- Tab indentation when mixing tabs & spaces
o.shiftwidth = 2 -- Indent/outdent by two columns
o.shiftround = true -- Always indent/outdent to nearest tabstop
o.expandtab = true -- Convert all tabs that are typed into spaces
o.smarttab = true -- Use shiftwidths at left margin, tabstops everywhere else
-- o.statuscolumn = [[%!v:lua.require'utils.statuscolumn'.get()]] -- ex:"%=%{&nu ? v:relnum && mode() != 'i' ? v:relnum : v:lnum : ''} %s%C"
-- opt.formatexpr = "v:lua.require'r.utils'.format.formatexpr()"
o.formatoptions = "tcqjn12" -- "cront",
o.splitkeep = "cursor" -- cursor, screen
o.splitbelow = true -- ':new' ':split' below current
o.splitright = true -- ':vnew' ':vsplit' right of current
o.equalalways = false -- New vim windows created won't make everything back to same sizes
-- }}}
-- {{{ Folds
opt.fillchars = {
  -- diff = "░", -- alternatives = ⣿ ░ ╱
  -- diff = " ", -- alternatives = ⣿ ░ ╱
  diff = "╱",
  eob = " ", -- suppress ~ at endofbuffer
  foldclose = "", -- '▶'
  foldopen = "", -- '▼'
  foldsep = " ",

  horiz = "─",
  horizdown = "┬",
  horizup = "┴",
  vert = "│",
  verthoriz = "┼",
  vertleft = "┤",
  vertright = "├",
}
o.foldlevelstart = 99 -- start with all code unfolded
o.foldlevel = 99 -- using ufo provider need a large value, feel free to decrease the value
o.foldmethod = "expr" -- Uses treesitter as folding source.
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
-- }}}
-- {{{ Timings
o.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.undodir = vim.fn.stdpath "data" .. "/undodir" -- Chooses where to store the undodir
o.history = 1000 -- Number of commands to remember in a history table (per buffer).
o.swapfile = false -- Ask what state to recover when opening a file that was not saved.
o.backup = false -- no backup file
o.writebackup = false -- do not backup file before write
o.undofile = true -- don't create root-owned files
o.undolevels = 10000
o.wrap = false -- Disable wrapping of lines longer than the width of window.
o.mouse = "a" -- Enable mouse support.
o.autochdir = false -- Use current file dir as working dir (See project.nvim)
o.scrolloff = 3 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
-- opt.scrolloffpad = 1 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
o.sidescrolloff = 3 -- Same but for side scrolling.
o.sidescroll = 1
o.selection = "old" -- Don't select the newline symbol when using <End> on visual mode
-- }}}
-- {{{ Emoji
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- credit: https://www.youtube.com/watch?v=f91vwoelfne
o.emoji = false
-- }}}
-- {{{ Diff
-- use in vertical diff mode, blank lines to keep sides aligned, ignore whitespace changes
-- opt.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"
opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "vertical",
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
  -- "inline:char",
}
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
-- Disable providers that are not needed
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

-- -- Undercurl
-- vim.cmd [[let &t_Cs = "\e[4:3m"]]
-- vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- plugin: ggandor/lightspeed.nvim
vim.g.lightspeed_no_default_keymaps = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.loaded_matchparen = 1

-- vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_DiffCommand = "diff -u"
