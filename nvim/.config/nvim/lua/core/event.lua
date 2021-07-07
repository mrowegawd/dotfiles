local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

function autocmd.load_autocmds()
    local definitions = {
        packer = {
            {"BufWritePost", "*.lua", "lua require('core.pack').auto_compile()"}
        },
        bufs = {
            -- Reload vim config automatically
            {"BufWritePost", [[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]]},
            -- Reload Vim script automatically if setlocal autoread
            {
                "BufWritePost,FileWritePost",
                "*.vim",
                [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]]
            },
            {"BufWritePre", "/tmp/*", "setlocal noundofile"},
            {"BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile"},
            {"BufWritePre", "MERGE_MSG", "setlocal noundofile"},
            {"BufWritePre", "*.tmp", "setlocal noundofile"},
            {"BufWritePre", "*.bak", "setlocal noundofile"},
            {"BufWritePre", "*.tsx", "lua vim.api.nvim_command('Format')"},
            {"BufWritePre", "*.go", "lua require('internal.golines').golines_format()"}
            -- Forcing color for unwanted spaces
            -- {"BufNewFile,BufRead,InsertLeave", "*","silent! match RedrawDebugRecompose /\\s\\+$/"};

            -- We use plugin :)
            -- Remember last position of file
            -- {
            --     "BufWinEnter",
            --     "*",
            --     [[if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"^" | execute 'silent! ' . line("'\"") . 'foldopen!' | endif]]
            -- }
        },
        -- " Highlight TODO, FIXME, NOTE, etc.
        -- au Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|BUG\|HACK\)')
        -- au Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')

        wins = {
            -- Highlight current line only on focused window
            {
                "WinEnter,BufEnter,InsertLeave",
                "*",
                [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]]
            },
            {
                "WinLeave,BufLeave,InsertEnter",
                "*",
                [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]]
            },
            -- Equalize window dimensions when resizing vim window
            {"VimResized", "*", [[tabdo wincmd =]]},
            -- Force write shada on leaving nvim
            {"VimLeave", "*", [[if has('nvim') | wshada! | else | wviminfo! | endif]]},
            -- Check if file changed when its window is focus, more eager than 'autoread'
            {"FocusGained", "* checktime"},
            -- Disable paste mode on leaving insert mode.
            {"InsertLeave", "* set nopaste"}
        },
        ft = {
            {"FileType", "dashboard", "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2"},
            {"BufNewFile,BufRead", "*.toml", " setf toml"},
            {"BufNewFile,BufRead", "*.org", " setf dotoo"},
            {"TermOpen", "*", " setf bufhidden=hide | :startinsert"},
            {"TermOpen", "*", " setf nonumber norelativenumber"},
            {"FileType", "qf", "wincmd J"}
        },
        yank = {
            {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]}
        },
        window_dim = {
            --
            {"BufEnter", "*", "lua require'core.window-dim'.buf_enter()"},
            -- {"BufWinEnter", "*", "lua require'core.window-dim'.buf_enter()"},
            {"FocusGained", "*", "lua require'core.window-dim'.focus_gained()"},
            {"VimEnter", "*", "lua require'core.window-dim'.vim_enter()"},
            {"WinEnter", "*", "lua require'core.window-dim'.win_enter()"},
            --
            {"FocusLost", "*", "lua require'core.window-dim'.focus_lost()"},
            {"WinLeave", "*", "lua require'core.window-dim'.win_leave()"}
        },
        color_update = {
            {"ColorScheme", "*", [[lua require("modules.ui._colors").custom_hi()]]}
        },
        mapping_au = {
            {"FileType", "qf", "nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L"},
            -- {"FileType", "org", "nnoremap <buffer> q :bd!<CR>"},
            {"BufWritePost", "*", [[if &filetype == '^\(org\)' | execute 'TrimSpace' | endif]]}
        }
    }

    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
