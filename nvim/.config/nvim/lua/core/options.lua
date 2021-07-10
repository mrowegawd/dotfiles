local root = vim.env.USER == "root"
-- local function bind_option(options)
--   for k, v in pairs(options) do
--     if v == true or v == false then
--       -- vim.cmd('set ' .. k)
--       vim.opt[k] = v
--     else
--       vim.cmd('set ' .. k .. '=' .. v)
--     end
--   end
-- end

local function load_options()
    local global_local = {
        termguicolors = true,
        rnu = true,
        errorbells = true,
        synmaxcol = 200,
        visualbell = true,
        hidden = true,
        fileformats = {"unix", "mac", "dos"},
        magic = true,
        virtualedit = "block",
        encoding = "utf-8",
        viewoptions = {"folds", "cursor", "curdir", "slash", "unix"},
        sessionoptions = {"curdir", "globals", "help", "tabpages", "winsize"},
        clipboard = "unnamedplus",
        wildignorecase = true,
        foldmethod = "indent",
        foldtext = "v:lua.FoldText()",
        wildmenu = true,
        wildmode = "longest:full,full",
        wildignore = {
            ".git",
            ".hg",
            ".svn",
            "*.pyc",
            "*.o",
            "*.out",
            "*.jpg",
            "*.jpeg",
            "*.png",
            "*.gif",
            "*.zip",
            "**/tmp/**",
            "*.DS_Store",
            "**/node_modules/**",
            "**/bower_modules/**"
        },
        backup = false,
        backupcopy = "yes",
        writebackup = false,
        swapfile = false,
        guicursor = "a:block",
        viewdir = O.default.cache_dir .. "view/",
        spellfile = O.default.cache_dir .. "spell/en.uft-8.add",
        history = 2000,
        --  ShaDa/viminfo:
        --   ' - Maximum number of previously edited files marks
        --   < - Maximum number of lines saved for each register
        --   @ - Maximum number of items in the input-line history to be
        --   s - Maximum size of an item contents in KiB
        --   h - Disable the effect of 'hlsearch' when loading the shada
        -- shada = !,'300,<50,@100,s10,h"
        shada = "!,'300,<50,@100,s10,h",
        backupskip = {"/tmp/*", "$TMPDIR/*", "$TMP/*", "$TEMP/*", "*/shm/*", "/private/var/*", ".vault.vim"},
        smarttab = true,
        shiftround = true,
        timeout = true,
        ttimeout = true,
        timeoutlen = 400,
        ttimeoutlen = 10,
        updatetime = 100,
        updatecount = 80, -- update swapfiles every 80 typed chars,
        redrawtime = 600,
        ignorecase = true,
        smartcase = true,
        lazyredraw = true,
        incsearch = true,
        wrapscan = true,
        complete = {".", "w", "b", "k"},
        inccommand = "split",
        spellcapcheck = "",
        -- grepformat     = "%f:%l:%c:%m";
        grepprg = "rg --hidden --vimgrep --smart-case --",
        -- grepprg = "rg --vimgrep --glob --smart-case '!*{.git,node_modules,build,bin,obj,README.md,tags}'",
        -- breakat        = [[\ \	;:,!?]];
        startofline = false,
        whichwrap = "b,h,l,s,<,>,[,],~",
        splitbelow = true,
        splitright = true,
        switchbuf = "useopen",
        backspace = {"indent", "eol", "start"},
        diffopt = {"filler", "iwhite", "internal", algorithm = "patience"},
        -- completeopt = {"menu,menuone,noselect,noinsert"},
        completeopt = {"menuone,noselect"},
        jumpoptions = "stack",
        showmode = false,
        -- shortmess = vim.o.shortmess .. "cA", -- "AIOTWacot"
        shortmess = "AIOTWacot",
        scrolloff = 2,
        sidescrolloff = 5,
        foldlevelstart = 99,
        ruler = false,
        list = true,
        fillchars = {vert = "|", eob = " "},
        showtabline = 2,
        winwidth = 30,
        winminwidth = 10,
        pumheight = 15,
        helpheight = 12,
        previewheight = 12,
        showcmd = false,
        cmdheight = 1,
        cmdwinheight = 5,
        equalalways = false,
        laststatus = 2,
        display = "lastline",
        showbreak = "↳  ",
        listchars = {tab = "» ", nbsp = "+", trail = "·", extends = "→", precedes = "←"},
        pumblend = 10,
        winblend = 10,
        textwidth = 80,
        expandtab = true,
        autoindent = true,
        tabstop = 2,
        shiftwidth = 2,
        softtabstop = -1,
        wrap = false,
        foldenable = true,
        linebreak = true,
        formatoptions = "cqornj2",
        number = true,
        numberwidth = 4,
        conceallevel = 2,
        signcolumn = "yes"
    }

    -- taken from https://github.com/wincent/wincent, awesome guy!
    if root then
        vim.opt.undofile = false -- don't create root-owned files
    else
        vim.opt.undodir = O.default.cache_dir .. "undo//" -- keep undo files out of the way
        vim.opt.undodir = vim.opt.undodir + "." -- fallback
        vim.opt.undofile = true -- actually use undo files
    end

    vim.opt.backupdir = O.default.cache_dir .. "backup//" -- keep backup files out of the way (ie. if 'backup' is ever set)
    vim.opt.backupdir = vim.opt.backupdir + "." -- fallback

    vim.opt.backupskip = vim.opt.backupskip + "*.re,*.rei" -- prevent bsb's watch mode from getting confused (if 'backup' is ever set)

    vim.opt.directory = O.default.cache_dir .. "swap//" -- keep swap files out of the way
    vim.opt.directory = vim.opt.directory + "." -- fallback

    vim.g.python_host_prog = O.default.home .. "/.config/neovim2/bin/python"
    vim.g.python3_host_prog = O.default.home .. "/.config/neovim3/bin/python"

    for name, value in pairs(global_local) do
        vim.opt[name] = value
    end

    -- vsnip
    vim.g.vsnip_filetypes = {
        ["typescript"] = {"javascript"},
        ["svelte"] = {"javascript", "typescript", "html"}
    }

    vim.cmd([[cab Wq wq]])
    vim.cmd([[cab Q! q!]])
    vim.cmd([[cab Q!! q!]])
    vim.cmd([[cab q!! q!]])
    vim.cmd([[cab WQ wq]])
    vim.cmd([[cab Q1 q!]])
    vim.cmd([[cab W1 up!]])
    vim.cmd([[cab W! up!]])
    vim.cmd([[cab w; up!]])
    vim.cmd([[cab W; up!]])
    vim.cmd([[cab W up]])
    vim.cmd([[cab Q q]])
    vim.cmd([[cab bD bd]])
    vim.cmd([[cab w@ up!]])
    vim.cmd([[cab W@ up!]])
end

load_options()
