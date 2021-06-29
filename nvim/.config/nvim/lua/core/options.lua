local global = require("core.global")

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
        -- mouse          = "nv";
        rnu = true,
        errorbells = true,
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
        writebackup = false,
        swapfile = false,
        undofile = true,
        guicursor = "a:block",
        directory = global.cache_dir .. "swag/",
        undodir = global.cache_dir .. "undo/",
        backupdir = global.cache_dir .. "backup/",
        viewdir = global.cache_dir .. "view/",
        spellfile = global.cache_dir .. "spell/en.uft-8.add",
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
        redrawtime = 600,
        ignorecase = true,
        smartcase = true,
        infercase = true,
        incsearch = true,
        wrapscan = true,
        complete = {".", "w", "b", "k"},
        inccommand = "split",
        -- grepformat     = "%f:%l:%c:%m";
        grepprg = "rg --hidden --vimgrep --smart-case --",
        -- breakat        = [[\ \	;:,!?]];
        startofline = false,
        -- whichwrap      = "h,l,<,>,[,],~";
        splitbelow = true,
        splitright = true,
        switchbuf = "useopen",
        backspace = {"indent", "eol", "start"},
        diffopt = {"filler", "iwhite", "internal", algorithm = "patience"},
        completeopt = {"menu,menuone,noselect,noinsert"},
        jumpoptions = "stack",
        showmode = false,
        -- shortmess = "aoOTIcF",
        shortmess = "filnxtToOFc",
        scrolloff = 2,
        sidescrolloff = 5,
        foldlevelstart = 99,
        ruler = false,
        list = true,
        fillchars = {vert = "|"},
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
        -- formatoptions = "1jcroql",
        formatoptions = "cqornj2",
        number = true,
        numberwidth = 4,
        conceallevel = 2,
        signcolumn = "yes" -- enable sign column all the time, 4 column
    }

    -- if global.is_mac then
    --   vim.g.clipboard = {
    --     name = "macOS-clipboard",
    --     copy = {
    --       ["+"] = "pbcopy",
    --       ["*"] = "pbcopy",
    --     },
    --     paste = {
    --       ["+"] = "pbpaste",
    --       ["*"] = "pbpaste",
    --     },
    --     cache_enabled = 0
    --   }
    -- end

    -- local bw_local  = {
    --   synmaxcol      = 2500;

    --   breakindentopt = "shift:2,min:20";
    --   colorcolumn    = "80";
    --   concealcursor  = "niv";
    -- }

    vim.g.python_host_prog = global.home .. "/.config/neovim2/bin/python"
    vim.g.python3_host_prog = global.home .. "/.config/neovim3/bin/python"

    for name, value in pairs(global_local) do
        vim.opt[name] = value
    end

    -- Vimwiki
    local wiki_path = os.getenv("HOME") .. "/MrKampang/vimwiki"

    vim.g.vimwiki_list = {
        {
            path = wiki_path,
            index = "home",
            auto_diary_index = 1,
            automatic_nested_syntaxes = 1,
            syntax = "markdown",
            template_default = "markdown",
            ext = ".md"
        }
    }

    -- Disable ALL Vimwiki key mappings
    -- let g:vimwiki_listsyms          = '✗○◐●✓'
    vim.g.vimwiki_key_mappings = {all_maps = 0}
    vim.g.vimwiki_table_mappings = 0
    vim.g.vimwiki_folding = "expr"
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_hl_cb_checked = 1
    vim.g.vimwiki_hl_headers = 1
    vim.g.vimwiki_markdown_link_ext = 1
    --- END
end

load_options()
