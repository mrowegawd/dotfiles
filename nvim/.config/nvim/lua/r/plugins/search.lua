local highlight, fn, cmd, fmt = as.highlight, vim.fn, vim.cmd, string.format
local icons = as.ui.icons
local prompt = icons.misc.telescope .. "  "

local function format_title(str, icon, icon_hl)
    return {
        { " " },
        { (icon and icon .. " " or ""), icon_hl or "DevIconDefault" },
        { str, "Bold" },
        { " " },
    }
end

return {
    -- FLASH.NVIM
    {
        "folke/flash.nvim",
        opts = {
            modes = {
                search = {
                    search = { trigger = ";" },
                },
                char = {
                    keys = { "f", "F", "t", "T", ";", "H", "L" }, -- remove "," from keys
                },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    -- default options: exact mode, multi window, all directions, with a backdrop
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    -- show labeled treesitter nodes around the cursor
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    -- jump to a remote location to execute the operator
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            -- {
            --     "R",
            --     mode = { "n", "o", "x" },
            --     function()
            --         -- show labeled treesitter nodes around the search matches
            --         require("flash").treesitter_search()
            --     end,
            --     desc = "Treesitter Search",
            -- },
        },
    },
    -- FZF-LUA
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        enabled = function()
            if as.use_search_telescope then
                return false
            end
            return true
        end,
        keys = {
            -- { "<leader>ff", require("utils").find_files, desc = "Find Files" },
            {
                "<Leader>ff",
                "<cmd>FzfLua files<cr>",
                desc = "Fzflua: find files",
            },
            {
                "B",
                function()
                    return require("fzf-lua").buffers {
                        winopts = {
                            preview = { hidden = "hidden" },
                            width = 0.5,
                            height = 0.33,
                        },
                    }
                end,
                desc = "Fzflua: buffers",
            },

            {
                "<Leader>fw",
                "<CMD>FzfLua blines<CR>",
                desc = "FzfLua: live_grep on curbuf",
            },
            {
                "<Leader>fW",
                "<CMD>FzfLua lines<CR>",
                desc = "Fzflua: live_grep on buffers",
            },
            {
                "<Leader>fk",
                "<CMD>FzfLua keymaps<CR>",
                desc = "Fzflua: keymaps",
            },
            {
                "<Leader>fc",
                "<CMD>FzfLua commands<CR>",
                desc = "Fzflua: commands",
            },
            {
                "<Leader>fo",
                "<CMD>FzfLua oldfiles<CR>",
                desc = "Fzflua: oldfiles",
            },
            {
                "<Leader>fO",
                "<CMD>FzfLua files cwd=~/.config/nvim<CR>",
                desc = "Fzflua: dotfiles",
            },
            {
                "<Leader>fF",
                function()
                    if vim.bo.filetype ~= "norg" then
                        local plugins_directory = vim.fn.stdpath "data"
                            .. "/lazy"

                        return require("fzf-lua").files {
                            prompt = "Plugins❯ ",
                            cwd = plugins_directory,
                            prompt_title = "Find plugin files",
                        }
                    end

                    return require("fzf-lua").files {
                        prompt = "[NORG] files❯ ",
                        cwd = as.wiki_path,
                    }
                end,
                desc = "Fzflua: find plugin files",
            },
            {
                "<Leader>fh",
                "<CMD>FzfLua help_tags<CR>",
                desc = "Fzflua: help tags",
            },
            {
                "<Leader>fl",
                "<CMD>FzfLua resume<CR>",
                desc = "Fzflua: resume (last search)",
            },
            {
                "<Leader>fg",
                function()
                    return require("fzf-lua").live_grep_glob {
                        -- prompt = "Live GrepGlob❯ ",
                        -- prompt = prompt,
                        winopts = {
                            preview = {
                                vertical = "up:60%",
                            },
                        },
                    }
                end,
                desc = "Fzflua: live grep",
            },
            {
                "<Leader>fg",
                "<CMD>FzfLua grep_visual<CR>",
                desc = "Fzflua: live grep [visual]",
                mode = { "v" },
            },
            {
                "<localleader>g",
                "<CMD>FzfLua changes<CR>",
                desc = "Fzflua: changes",
            },
            {
                "<c-g>",
                "<CMD>FzfLua jumps<CR>",
                desc = "Fzflua: jumps",
            },
            {
                "z=",
                function()
                    return require("fzf-lua").spell_suggest {
                        winopts = {
                            relative = "cursor",
                            height = 0.33,
                            width = 0.33,
                        },
                    }
                end,
                desc = "Fzflua: spell",
            },
            {
                "<leader>fQ",
                "<CMD>FzfLua quickfix<CR>",
                desc = "Fzflua: qf list",
            },

            {
                "<leader>fq",
                function()
                    local path = require "fzf-lua.path"

                    local qf_items = fn.getqflist()

                    local qf_ntbl = {}
                    for _, qf_item in pairs(qf_items) do
                        table.insert(
                            qf_ntbl,
                            path.relative(
                                vim.api.nvim_buf_get_name(qf_item.bufnr),
                                vim.uv.cwd()
                            )
                        )
                    end

                    local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case {q} ]]
                        .. table.concat(qf_ntbl, " ")

                    return require("fzf-lua").live_grep {
                        -- prompt = "GrepQF❯ ",
                        prompt = prompt,
                        winopts = {
                            title = format_title("Grep", " "),
                            height = 0.85,
                            width = 0.90,
                            preview = {
                                vertical = "up:60%",
                                layout = "vertical",
                            },
                        },
                        cmd = pcmd,
                    }
                end,
                desc = "Fzflua: grep qf items",
            },
        },
        -- init = function()
        --             },
        --             commands = {
        --                 {
        --                     ":FzfLua highlights",
        --                     description = "Fzflua: highlights",
        --                 },
        --                 {
        --                     ":FzfLua keymaps",
        --                     description = "Fzflua: keymaps",
        --                 },
        --                 {
        --                     ":FzfLua autocmds",
        --                     description = "Fzflua: autocmds",
        --                 },
        --                 {
        --                     ":FzfLua commands",
        --                     description = "Fzflua: commands",
        --                 },
        --                 {
        --                     ":FzfLua colorschemes",
        --                     description = "Fzflua: colorschemes",
        --                 },
        --                 {
        --                     ":FzfLua command_history",
        --                     description = "Fzflua: command history",
        --                 },
        --             },
        --         },
        --         {
        --             itemgroup = "Misc",
        --             keymaps = {
        --                 {
        --                     "<c-v>",
        --                     function()
        --                         return require("fzf-lua").complete_path {
        --                             winopts = {
        --                                 relative = "cursor",
        --                                 height = 0.33,
        --                                 width = 0.33,
        --                             },
        --                             cmd = "fd --color never --type f --hidden --follow",
        --                         }
        --                     end,
        --                     mode = { "i" },
        --                     description = "Fzflua: complete path",
        --                 },
        --             },
        --         },
        --     }
        -- end,
        config = function()
            local actions = require "fzf-lua.actions"
            local path = require "fzf-lua.path"

            require("fzf-lua").setup {
                keymap = {
                    builtin = {
                        -- neovim `:tmap` mappings for the fzf win
                        ["<F1>"] = "toggle-help",
                        ["<F2>"] = "toggle-fullscreen",
                        -- Only valid with the 'builtin' previewer
                        ["<F3>"] = "toggle-preview-wrap",
                        ["<F4>"] = "toggle-preview",
                        -- Rotate preview clockwise/counter-clockwise
                        -- ["c-l>"] = "toggle-preview-ccw",
                        ["<F6>"] = "toggle-preview-cw",

                        ["<c-d>"] = "preview-page-down",
                        ["<c-u>"] = "preview-page-up",
                    },
                    fzf = {
                        -- fzf '--bind=' options
                        ["ctrl-z"] = "abort",

                        -- ["ctrl-u"] = "unix-line-discard",
                        -- ["ctrl-d"] = "half-page-down",
                        -- ["ctrl-b"] = "half-page-up",
                        -- ["ctrl-g"] = "beginning-of-line",
                        -- ["ctrl-g"] = "end-of-line",
                        ["ctrl-a"] = "toggle-all",
                        -- Only valid with fzf previewers (bat/cat/git/etc)
                        ["f3"] = "toggle-preview-wrap",
                        ["f4"] = "toggle-preview",
                        ["ctrl-d"] = "preview-page-down",
                        ["ctrl-u"] = "preview-page-up",
                    },
                },
                actions = {
                    -- These override the default tables completely
                    -- no need to set to `false` to disable an action
                    -- delete or modify is sufficient
                    files = {
                        -- providers that inherit these actions:
                        --   files, git_files, git_status, grep, lsp
                        --   oldfiles, quickfix, loclist, tags, btags
                        --   args
                        -- default action opens a single selection
                        -- or sends multiple selection to quickfix
                        -- replace the default action with the below
                        -- to open all files whether single or multiple
                        -- ["default"]     = actions.file_edit,
                        ["default"] = actions.file_edit_or_qf,

                        ["ctrl-s"] = actions.file_split,
                        ["ctrl-v"] = actions.file_vsplit,
                        ["ctrl-t"] = actions.file_tabedit,

                        -- ["ctrl-s"] = actions.file_split,
                        -- ["ctrl-v"] = actions.file_vsplit,
                        -- ["ctrl-t"] = actions.file_tabedit,
                        ["ctrl-q"] = actions.file_sel_to_qf,
                        -- ["ctrl-l"] = actions.file_sel_to_ll,
                    },
                    buffers = {
                        -- providers that inherit these actions:
                        --   buffers, tabs, lines, blines
                        ["default"] = actions.buf_edit,
                        ["alt-q"] = actions.file_sel_to_qf,

                        ["ctrl-s"] = actions.buf_split,
                        ["ctrl-v"] = actions.buf_vsplit,
                        ["ctrl-t"] = actions.buf_tabedit,
                    },
                },
                fzf_opts = {
                    -- options are sent as `<left>=<right>`
                    -- set to `false` to remove a flag
                    -- set to '' for a non-value flag
                    -- for raw args use `fzf_args` instead
                    ["--ansi"] = "",
                    ["--info"] = "inline",
                    ["--height"] = "100%",
                    ["--layout"] = "reverse",
                    ["--border"] = "none",
                },
                -- Only used when fzf_bin = "fzf-tmux", by default opens as a
                -- popup 80% width, 80% height (note `-p` requires tmux > 3.2)
                -- and removes the sides margin added by `fzf-tmux` (fzf#3162)
                -- for more options run `fzf-tmux --help`
                fzf_tmux_opts = { ["-p"] = "80%,80%", ["--margin"] = "0,0" },
                -- fzf '--color=' options (optional)
                -- fzf_colors = {
                --     ["fg"] = { "fg", "Pmenu" },
                --     -- ["bg"] = { "bg", "Normal" },
                --     ["hl"] = { "fg", "ErrorMsg" },
                -- ["fg+"] = { "fg", "Boolean" },
                --     ["bg+"] = { "bg", "PmenuSel" },
                -- ["hl+"] = { "fg", "Boolean" },
                --     -- ["info"] = { "fg", "PreProc" },
                --     -- ["prompt"] = { "fg", "Conditional" },
                --     -- ["pointer"] = { "fg", "Exception" },
                --     -- ["marker"] = { "fg", "Keyword" },
                --     -- ["spinner"] = { "fg", "Label" },
                --     -- ["header"] = { "fg", "Comment" },
                --     -- ["gutter"] = { "bg", "Normal" },
                -- },
                previewers = {
                    cat = {
                        cmd = "cat",
                        args = "--number",
                    },
                    bat = {
                        cmd = "bat",
                        args = "--style=numbers,changes --color always",
                        theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
                        config = nil, -- nil uses $BAT_CONFIG_PATH
                    },
                    head = {
                        cmd = "head",
                        args = nil,
                    },
                    git_diff = {
                        cmd_deleted = "git diff --color HEAD --",
                        cmd_modified = "git diff --color HEAD",
                        cmd_untracked = "git diff --color --no-index /dev/null",
                        -- uncomment if you wish to use git-delta as pager
                        -- can also be set under 'git.status.preview_pager'
                        -- pager        = "delta --width=$FZF_PREVIEW_COLUMNS",
                    },
                    man = {
                        cmd = "man -c %s | col -bx",
                    },
                    builtin = {
                        syntax = true, -- preview syntax highlight?
                        syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
                        syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
                        limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
                        -- previewer treesitter options:
                        -- enable specific filetypes with: `{ enable = { "lua" } }
                        -- exclude specific filetypes with: `{ disable = { "lua" } }
                        -- disable fully with: `{ enable = false }`
                        treesitter = { enable = true, disable = {} },
                        -- By default, the main window dimensions are calculted as if the
                        -- preview is visible, when hidden the main window will extend to
                        -- full size. Set the below to "extend" to prevent the main window
                        -- from being modified when toggling the preview.
                        toggle_behavior = "default",
                        -- preview extensions using a custom shell command:
                        -- for example, use `viu` for image previews
                        -- will do nothing if `viu` isn't executable
                        extensions = {
                            -- neovim terminal only supports `viu` block output
                            ["png"] = { "viu", "-b" },
                            ["svg"] = { "chafa" },
                            ["jpg"] = { "ueberzug" },
                        },
                        -- if using `ueberzug` in the above extensions map
                        -- set the default image scaler, possible scalers:
                        --   false (none), "crop", "distort", "fit_contain",
                        --   "contain", "forced_cover", "cover"
                        -- https://github.com/seebye/ueberzug
                        ueberzug_scaler = "cover",
                    },
                },
                -- provider setup
                files = {
                    -- debug = true, -- jangan lupa: untuk check `rg opt`, use debug
                    -- previewer = "bat", -- uncomment to override previewer
                    -- (name from 'previewers' table)
                    -- set to 'false' to disable
                    prompt = "  ",
                    winopts = { title = format_title("Files", "") },
                    multiprocess = true, -- run command in a separate process
                    git_icons = true, -- show git icons?
                    file_icons = true, -- show file icons?
                    color_icons = true, -- colorize file|git icons
                    -- path_shorten   = 1,              -- 'true' or number, shorten path?
                    -- executed command priority is 'cmd' (if exists)
                    -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
                    -- default options are controlled by 'fd|rg|find|_opts'
                    -- cmd            = "find . -type f -printf '%P\n'",
                    -- find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
                    -- fd_opts = "--color=never --type f --hidden --follow --exclude .git",

                    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
                    fd_opts = [[--color never --type f --hidden --follow ]]
                        .. [[--exclude .git --exclude node_modules --exclude '*.pyc']]
                        .. [[ --exclude '*.ttf' --exclude '*.png' --exclude '*.otf']],
                    -- by default, cwd appears in the header only if {opts} contain a cwd
                    -- parameter to a different folder than the current working directory
                    -- uncomment if you wish to force display of the cwd as part of the
                    -- query prompt string (fzf.vim style), header line or both
                    -- show_cwd_prompt = true,
                    -- show_cwd_header = true,
                    actions = {
                        -- inherits from 'actions.files', here we can override
                        -- or set bind to 'false' to disable a default action
                        -- custom actions are available too
                        -- ["ctrl-y"] = function(selected)
                        --     print(selected[1])
                        -- end,
                        ["default"] = function(selected, opts)
                            -- as.info(selected[1])
                            local selected_item = selected[1]
                            local status, entry = pcall(
                                path.entry_to_file,
                                selected_item,
                                opts,
                                opts.force_uri
                            )

                            local file_or_dir = vim.uv.fs_stat(entry.path)

                            if
                                file_or_dir
                                and status
                                and file_or_dir.type == "file"
                            then
                                require("fzf-lua").actions.file_edit(
                                    selected,
                                    opts
                                )
                            else
                                require("fzf-lua").live_grep {
                                    winopts = {
                                        title = format_title(
                                            entry.path,
                                            "  "
                                        ),
                                    },
                                    cwd = entry.path,
                                }
                            end
                        end,

                        ["ctrl-b"] = function(_, args)
                            local winopts = {
                                preview = { hidden = "nohidden" },
                            }
                            if args.cmd:find "--type f" then
                                args.cmd = args.cmd:gsub("--type f", "", 1)
                                args.cmd:gsub("%s*\\*$", "")
                                args.cmd = args.cmd .. " --type d"
                                winopts = {
                                    preview = { hidden = "hidden" },
                                }
                            elseif args.cmd:find "--type d" then
                                args.cmd = args.cmd:gsub("--type d", "", 1)
                                args.cmd:gsub("%s*\\*$", "")
                                args.cmd = args.cmd .. " --type f"
                            end
                            require("fzf-lua").files {
                                cmd = args.cmd,
                                winopts = winopts,
                            }
                        end,
                    },
                },
                git = {
                    files = {
                        prompt = "  ",
                        cmd = "git ls-files --exclude-standard",
                        winopts = { title = format_title("Git Files", "") },
                        multiprocess = true, -- run command in a separate process
                        git_icons = true, -- show git icons?
                        file_icons = true, -- show file icons?
                        color_icons = true, -- colorize file|git icons
                    },
                    status = {
                        prompt = "  ",
                        winopts = { title = format_title("Git Status", "") },
                        preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS --line-numbers",
                        actions = {
                            -- actions inherit from 'actions.files' and merge
                            -- ["left"] = { actions.git_stage, actions.resume },
                            ["ctrl-r"] = { actions.git_reset, actions.resume },
                            ["right"] = { actions.git_unstage, actions.resume },
                            ["left"] = {
                                actions.git_stage,
                                actions.resume,
                            },
                        },
                    },
                    commits = {
                        prompt = "  ",
                        -- prompt = prompt,
                        cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
                        preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
                        winopts = { title = format_title("", "Commits") },
                        actions = {
                            ["default"] = actions.git_buf_edit,
                            ["right"] = actions.git_checkout,
                            ["ctrl-s"] = actions.git_buf_split,
                            ["ctrl-v"] = actions.git_buf_vsplit,
                            ["ctrl-t"] = actions.git_buf_tabedit,

                            -- Open hash on browser
                            ["ctrl-b"] = function(selected, _)
                                local selection = selected[1]
                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                vim.api.nvim_command(":GBrowse " .. commit_hash)
                            end,
                            -- Copy hash to clipboard
                            ["ctrl-y"] = function(selected, _)
                                local selection = selected[1]
                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                vim.fn.setreg("+", commit_hash)
                                vim.fn.setreg("*", commit_hash)

                                as.info(
                                    "Copied commit hash "
                                        .. commit_hash
                                        .. " to clipboard",
                                    "FZFGit"
                                )
                            end,
                            -- Show diff all log
                            ["ctrl-o"] = function(selected, _)
                                local selection = selected[1]

                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                local cmdmsg = ":DiffviewOpen -uno "
                                    .. commit_hash

                                vim.api.nvim_command(cmdmsg)

                                as.info(
                                    "Showing a diff " .. commit_hash "FZFGit"
                                )
                            end,
                            -- Open diff current modified
                            ["ctrl-m"] = function(selected, _)
                                local selection = selected[1]

                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                local filename =
                                    require("r.utils.fzf_diffview").git_relative_path(
                                        vim.api.nvim_get_current_buf()
                                    )

                                local cmdmsg = ":DiffviewOpen -uno "
                                    .. commit_hash
                                    .. " -- "
                                    .. filename

                                vim.api.nvim_command(cmdmsg)

                                as.info(
                                    "Comparing a commit diff "
                                        .. commit_hash
                                        .. " with current file \n"
                                        .. filename,
                                    "FZFGit"
                                )
                            end,
                        },
                    },
                    bcommits = {
                        prompt = "  ",
                        -- default preview shows a git diff vs the previous commit
                        -- if you prefer to see the entire commit you can use:
                        --   git show --color {1} --rotate-to=<file>
                        --   {1}    : commit SHA (fzf field index expression)
                        --   <file> : filepath placement within the commands
                        -- cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset' <file>",
                        preview = "git diff --color {1}~1 {1} -- <file>",
                        -- preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
                        winopts = {
                            title = format_title("", "Buffer Commits"),
                        },
                        -- preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1} | delta --width $FZF_PREVIEW_COLUMNS",
                        -- uncomment if you wish to use git-delta as pager
                        --preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
                        actions = {
                            ["default"] = actions.git_buf_edit,
                            ["ctrl-s"] = actions.git_buf_split,
                            ["ctrl-v"] = actions.git_buf_vsplit,
                            ["ctrl-t"] = actions.git_buf_tabedit,

                            ["ctrl-y"] = function(selected, _)
                                local selection = selected[1]
                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                vim.fn.setreg("+", commit_hash)
                                vim.fn.setreg("*", commit_hash)

                                as.info(
                                    "Copied commit hash "
                                        .. commit_hash
                                        .. " to clipboard",
                                    "FZFGit"
                                )
                            end,
                            ["ctrl-b"] = function(selected, _)
                                local selection = selected[1]
                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                vim.api.nvim_command(":GBrowse " .. commit_hash)
                            end,
                            ["ctrl-o"] = function(selected, _)
                                local selection = selected[1]

                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                local cmdmsg = ":DiffviewOpen -uno "
                                    .. commit_hash

                                vim.api.nvim_command(cmdmsg)

                                as.info(
                                    "Showing a diff " .. commit_hash "FZFGit"
                                )
                            end,
                            ["ctrl-m"] = function(selected, _)
                                local selection = selected[1]

                                local commit_hash = require(
                                    "r.utils.fzf_diffview"
                                ).split_string(
                                    selection,
                                    " "
                                )[1]

                                local filename =
                                    require("r.utils.fzf_diffview").git_relative_path(
                                        vim.api.nvim_get_current_buf()
                                    )

                                local cmdmsg = ":DiffviewOpen -uno "
                                    .. commit_hash
                                    .. " -- "
                                    .. filename

                                vim.api.nvim_command(cmdmsg)

                                as.info(
                                    "Showing a diff "
                                        .. commit_hash
                                        .. " with current file \n"
                                        .. filename,
                                    "FZFGit"
                                )
                            end,
                        },
                    },
                    branches = {
                        prompt = "  ",
                        cmd = "git branch --all --color",
                        preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
                        winopts = {
                            title = format_title("Branches", ""),
                            height = 0.3,
                            row = 0.4,
                        },
                        actions = {
                            ["default"] = actions.git_switch,
                        },
                    },
                    stash = {
                        prompt = "  ",
                        cmd = "git --no-pager stash list",
                        preview = "git --no-pager stash show --patch --color {1}",
                        winopts = {
                            title = format_title("Stash", ""),
                        },
                        actions = {
                            ["default"] = actions.git_stash_apply,
                            ["ctrl-x"] = {
                                actions.git_stash_drop,
                                actions.resume,
                            },
                        },
                        fzf_opts = {
                            ["--no-multi"] = "",
                            ["--delimiter"] = "'[:]'",
                        },
                    },
                    icons = {
                        ["M"] = { icon = "M", color = "yellow" },
                        ["D"] = { icon = "D", color = "red" },
                        ["A"] = { icon = "A", color = "green" },
                        ["R"] = { icon = "R", color = "yellow" },
                        ["C"] = { icon = "C", color = "yellow" },
                        ["T"] = { icon = "T", color = "magenta" },
                        ["?"] = { icon = "?", color = "magenta" },
                        -- override git icons?
                        -- ["M"]        = { icon = "★", color = "red" },
                        -- ["D"]        = { icon = "✗", color = "red" },
                        -- ["A"]        = { icon = "+", color = "green" },
                    },
                },
                grep = {
                    -- debug = true, -- jangan lupa: untuk check `rg opt`, use debug
                    -- prompt = "Rg❯ ",
                    -- prompt = prompt,
                    -- prompt = " ",
                    prompt = "  ",
                    winopts = { title = format_title("Grep", " ") },
                    -- previewer = "bat", -- uncomment to override previewer
                    input_prompt = "Grep For❯ ",
                    multiprocess = true, -- run command in a separate process
                    git_icons = true, -- show git icons?
                    file_icons = true, -- show file icons?
                    color_icons = true, -- colorize file|git icons
                    -- executed command priority is 'cmd' (if exists)
                    -- otherwise auto-detect prioritizes `rg` over `grep`
                    -- default options are controlled by 'rg|grep_opts'
                    -- cmd            = "rg --vimgrep",
                    grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
                    rg_opts = "--column --line-number -i --hidden --no-heading --color=always --smart-case --max-columns=4096",
                    -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
                    -- search strings will be split using the 'glob_separator' and translated
                    -- to '--iglob=' arguments, requires 'rg'
                    -- can still be used when 'false' by calling 'live_grep_glob' directly
                    rg_glob = false, -- default to glob parsing?
                    glob_flag = "--iglob", -- for case sensitive globs use '--glob'
                    glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
                    -- advanced usage: for custom argument parsing define
                    -- 'rg_glob_fn' to return a pair:
                    --   first returned argument is the new search query
                    --   second returned argument are addtional rg flags
                    -- rg_glob_fn = function(query, opts)
                    --   ...
                    --   return new_query, flags
                    -- end,
                    actions = {
                        -- actions inherit from 'actions.files' and merge
                        -- this action toggles between 'grep' and 'live_grep'
                        ["ctrl-g"] = { actions.grep_lgrep },
                        ["ctrl-y"] = function(_, opts)
                            if opts.__FNCREF__ then
                                require("fzf-lua").grep {
                                    prompt = "Grep❯ ",
                                    continue_last_search = true,
                                }
                                require("fzf-lua.actions").ensure_insert_mode()
                            else
                                require("fzf-lua").live_grep {
                                    prompt = "Live Grep❯ ",
                                    continue_last_search = true,
                                }
                                require("fzf-lua.actions").ensure_insert_mode()
                            end
                        end,
                    },
                    no_header = false, -- hide grep|cwd header?
                    no_header_i = false, -- hide interactive header?
                },
                args = {
                    prompt = "Args❯ ",
                    files_only = true,
                    -- actions inherit from 'actions.files' and merge
                    actions = {
                        ["ctrl-x"] = { actions.arg_del, actions.resume },
                    },
                },
                oldfiles = {
                    -- prompt = prompt,
                    prompt = "  ",
                    cwd_only = true,
                    stat_file = true, -- verify files exist on disk
                    winopts = { title = format_title("History", "") },
                    include_current_session = false, -- include bufs from current session
                },
                buffers = {
                    prompt = "  ",
                    winopts = { title = format_title("Buffers", "󰈙") },
                    -- previewer = "bat", -- uncomment to override previewer
                    file_icons = true, -- show file icons?
                    color_icons = true, -- colorize file|git icons
                    sort_lastused = true, -- sort buffers() by last used
                    cwd_only = false, -- buffers for the cwd only
                    cwd = nil, -- buffers list for a given dir
                    fzf_opts = {
                        ["--delimiter"] = "' '",
                        ["--with-nth"] = "-1..",
                    },
                    actions = {
                        -- ["ctrl-x"] = { actions.buf_del, actions.resume },
                        ["ctrl-s"] = actions.buf_split,
                        ["ctrl-v"] = actions.buf_vsplit,
                        ["ctrl-t"] = actions.buf_tabedit,
                        ["ctrl-d"] = { actions.buf_del, actions.resume },
                    },
                },
                tabs = {
                    prompt = "Tabs❯ ",
                    tab_title = "Tab",
                    tab_marker = "<<",
                    file_icons = true, -- show file icons?
                    color_icons = true, -- colorize file|git icons
                    actions = {
                        -- actions inherit from 'actions.buffers' and merge
                        ["default"] = actions.buf_switch,
                        ["ctrl-x"] = { actions.buf_del, actions.resume },
                    },
                    fzf_opts = {
                        -- hide tabnr
                        ["--delimiter"] = "'[\\):]'",
                        ["--with-nth"] = "2..",
                    },
                },
                lines = {
                    -- previewer = "bat", -- uncomment to override previewer
                    prompt = "Lines❯ ",
                    show_unlisted = false, -- exclude 'help' buffers
                    no_term_buffers = true, -- exclude 'term' buffers
                    fzf_opts = {
                        -- do not include bufnr in fuzzy matching
                        -- tiebreak by line no.
                        ["--delimiter"] = "'[\\]:]'",
                        ["--nth"] = "2..",
                        ["--tiebreak"] = "index",
                        ["--tabstop"] = "1",
                    },
                    -- actions inherit from 'actions.buffers' and merge
                    actions = {
                        ["default"] = actions.buf_edit_or_qf,

                        ["alt-l"] = actions.buf_sel_to_ll,
                        ["ctrl-q"] = actions.buf_sel_to_qf,

                        ["ctrl-s"] = actions.buf_split,
                        ["ctrl-v"] = actions.buf_vsplit,
                        ["ctrl-t"] = actions.buf_tabedit,
                    },
                },
                blines = {
                    -- previewer = "bat", -- uncomment to override previewer
                    prompt = "BLines❯ ",
                    show_unlisted = true, -- include 'help' buffers
                    no_term_buffers = false, -- include 'term' buffers
                    fzf_opts = {
                        -- Cara menghilangkan filepath
                        -- https://github.com/ibhagwan/fzf-lua/issues/228#issuecomment-983262485
                        ["--delimiter"] = "'[\\]:]'",
                        ["--with-nth"] = "3..",
                        ["--tiebreak"] = "index",
                        ["--tabstop"] = "1",
                    },
                    -- actions inherit from 'actions.buffers' and merge
                    actions = {
                        ["default"] = actions.buf_edit_or_qf,

                        ["alt-l"] = actions.buf_sel_to_ll,
                        ["ctrl-q"] = actions.buf_sel_to_qf,

                        ["ctrl-s"] = actions.buf_split,
                        ["ctrl-v"] = actions.buf_vsplit,
                        ["ctrl-t"] = actions.buf_tabedit,
                    },
                },
                tags = {
                    prompt = "Tags❯ ",
                    ctags_file = nil, -- auto-detect from tags-option
                    multiprocess = true,
                    file_icons = true,
                    git_icons = true,
                    color_icons = true,
                    -- 'tags_live_grep' options, `rg` prioritizes over `grep`
                    rg_opts = "--no-heading --color=always --smart-case",
                    grep_opts = "--color=auto --perl-regexp",
                    actions = {
                        -- actions inherit from 'actions.files' and merge
                        -- this action toggles between 'grep' and 'live_grep'
                        ["ctrl-g"] = { actions.grep_lgrep },
                    },
                    no_header = false, -- hide grep|cwd header?
                    no_header_i = false, -- hide interactive header?
                },
                btags = {
                    prompt = "BTags❯ ",
                    ctags_file = nil, -- auto-detect from tags-option
                    ctags_autogen = false, -- dynamically generate ctags each call
                    multiprocess = true,
                    file_icons = true,
                    git_icons = true,
                    color_icons = true,
                    rg_opts = "--no-heading --color=always",
                    grep_opts = "--color=auto --perl-regexp",
                    fzf_opts = {
                        ["--delimiter"] = "'[\\]:]'",
                        ["--with-nth"] = "2..",
                        ["--tiebreak"] = "index",
                    },
                    -- actions inherit from 'actions.files'
                },
                colorschemes = {
                    prompt = "Colorschemes❯ ",
                    live_preview = true, -- apply the colorscheme on preview?
                    actions = { ["default"] = actions.colorscheme },
                    winopts = { height = 0.55, width = 0.30 },
                    post_reset_cb = function()
                        -- reset statusline highlights after
                        -- a live_preview of the colorscheme
                        -- require('feline').reset_highlights()
                    end,
                },
                quickfix = {
                    file_icons = true,
                    git_icons = true,
                },
                quickfix_stack = {
                    prompt = "",
                    marker = ">", -- current list marker
                    winopts = { title = format_title("Stack List", "+") },
                },
                lsp = {
                    prompt_postfix = "❯ ", -- will be appended to the LSP label
                    -- to override use 'prompt' instead
                    cwd_only = false, -- LSP/diagnostics for cwd only?
                    async_or_timeout = 5000, -- timeout(ms) or 'true' for async calls
                    file_icons = true,
                    git_icons = false,
                    -- The equivalent of using `includeDeclaration` in lsp buf calls, e.g:
                    -- :lua vim.lsp.buf.references({includeDeclaration = false})
                    includeDeclaration = true, -- include current declaration in LSP context
                    -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
                    symbols = {
                        async_or_timeout = true, -- symbols are async by default
                        symbol_style = 1, -- style for document/workspace symbols
                        -- false: disable,    1: icon+kind
                        --     2: icon only,  3: kind only
                        -- NOTE: icons are extracted from
                        -- vim.lsp.protocol.CompletionItemKind
                        -- icons for symbol kind
                        -- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
                        -- see https://github.com/neovim/neovim/blob/829d92eca3d72a701adc6e6aa17ccd9fe2082479/runtime/lua/vim/lsp/protocol.lua#L117
                        actions = {
                            ["default"] = actions.buf_edit_or_qf,
                            -- ["alt-q"] = actions.buf_sel_to_qf,
                            -- ["alt-l"] = actions.buf_sel_to_ll,

                            ["ctrl-s"] = actions.buf_split,
                            ["ctrl-v"] = actions.buf_vsplit,
                            ["ctrl-t"] = actions.buf_tabedit,
                        },

                        symbol_icons = {
                            File = icons.kind.File,
                            Module = icons.kind.Module,
                            Namespace = icons.kind.Namespace,
                            Package = icons.kind.Package,
                            Class = icons.kind.Class,
                            Method = icons.kind.Method,
                            Property = icons.kind.Property,
                            Field = icons.kind.Field,
                            Constructor = icons.kind.Constructor,
                            Enum = icons.kind.Enum,
                            Interface = icons.kind.Interface,
                            Function = icons.kind.Function,
                            Variable = icons.kind.Variable,
                            Constant = icons.kind.Constant,
                            String = icons.kind.String,
                            Number = icons.kind.Number,
                            Boolean = icons.kind.Boolean,
                            Array = icons.kind.Array,
                            Object = icons.kind.Object,
                            Key = icons.kind.Keyword,
                            Null = icons.kind.Null,
                            EnumMember = "",
                            Struct = icons.kind.Struct,
                            Event = icons.kind.Event,
                            Operator = icons.kind.Operator,
                            TypeParameter = icons.kind.TypeParameter,
                        },
                    },
                    code_actions = {
                        prompt = "Code Actions❯ ",
                        async_or_timeout = 5000,
                        winopts = {
                            row = 0.40,
                            height = 0.35,
                            width = 0.60,
                        },
                    },
                    finder = {
                        prompt = "LSP Finder❯ ",
                        file_icons = true,
                        color_icons = true,
                        git_icons = false,
                        async = true, -- async by default
                        silent = true, -- suppress "not found"
                        separator = "| ", -- separator after provider prefix, `false` to disable
                        includeDeclaration = true, -- include current declaration in LSP context
                        -- by default display all LSP locations
                        -- to customize, duplicate table and delete unwanted providers
                        providers = {
                            {
                                "references",
                                prefix = require("fzf-lua").utils.ansi_codes.blue "ref ",
                            },
                            {
                                "definitions",
                                prefix = require("fzf-lua").utils.ansi_codes.green "def ",
                            },
                            {
                                "declarations",
                                prefix = require("fzf-lua").utils.ansi_codes.magenta "decl",
                            },
                            {
                                "typedefs",
                                prefix = require("fzf-lua").utils.ansi_codes.red "tdef",
                            },
                            {
                                "implementations",
                                prefix = require("fzf-lua").utils.ansi_codes.green "impl",
                            },
                            {
                                "incoming_calls",
                                prefix = require("fzf-lua").utils.ansi_codes.cyan "in  ",
                            },
                            {
                                "outgoing_calls",
                                prefix = require("fzf-lua").utils.ansi_codes.yellow "out ",
                            },
                        },
                    },
                },
                diagnostics = {
                    prompt = "Diagnostics❯ ",
                    cwd_only = false,
                    file_icons = true,
                    git_icons = false,
                    diag_icons = true,
                    icon_padding = "", -- add padding for wide diagnostics signs
                    -- by default icons and highlights are extracted from 'DiagnosticSignXXX'
                    -- and highlighted by a highlight group of the same name (which is usually
                    -- set by your colorscheme, for more info see:
                    --   :help DiagnosticSignHint'
                    --   :help hl-DiagnosticSignHint'
                    -- only uncomment below if you wish to override the signs/highlights
                    -- define only text, texthl or both (':help sign_define()' for more info)
                    -- signs = {
                    --   ["Error"] = { text = "", texthl = "DiagnosticError" },
                    --   ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
                    --   ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
                    --   ["Hint"]  = { text = "", texthl = "DiagnosticHint" },
                    -- },
                    -- limit to specific severity, use either a string or num:
                    --   1 or "hint"
                    --   2 or "information"
                    --   3 or "warning"
                    --   4 or "error"
                    -- severity_only:   keep any matching exact severity
                    -- severity_limit:  keep any equal or more severe (lower)
                    -- severity_bound:  keep any equal or less severe (higher)
                },
                complete_path = {
                    cmd = nil, -- default: auto detect fd|rg|find
                    actions = { ["default"] = actions.complete_insert },
                },
                complete_file = {
                    cmd = nil, -- default: auto detect rg|fd|find
                    file_icons = true,
                    color_icons = true,
                    git_icons = false,
                    -- actions inherit from 'actions.files' and merge
                    actions = { ["default"] = actions.complete_insert },
                    -- previewer hidden by default
                    winopts = { preview = { hidden = "hidden" } },
                },
                -- uncomment to use the old help previewer which used a
                -- minimized help window to generate the help tag preview
                -- helptags = { previewer = "help_tags" },
                -- uncomment to use `man` command as native fzf previewer
                -- (instead of using a neovim floating window)
                -- manpages = { previewer = "man_native" },
                --
                -- optional override of file extension icon colors
                -- available colors (terminal):
                --    clear, bold, black, red, green, yellow
                --    blue, magenta, cyan, grey, dark_grey, white
                file_icon_colors = {
                    ["sh"] = "green",
                },
                -- padding can help kitty term users with
                -- double-width icon rendering
                file_icon_padding = "",
                -- uncomment if your terminal/font does not support unicode character
                -- 'EN SPACE' (U+2002), the below sets it to 'NBSP' (U+00A0) instead
                -- nbsp = '\xc2\xa0',
            }
            require("fzf-lua").register_ui_select()
        end,
    },
    -- TELESCOPE (disabled)
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        enabled = function()
            if as.use_search_telescope then
                return true
            end
            return false
        end,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Telescope",
                    description = "Gaze deeply into unknown regions using the power of the moon",
                    icon = as.ui.icons.misc.telescope,
                    keymaps = {

                        {
                            "<Leader>fb",
                            "<CMD>Telescope buffers<CR>",
                            description = "Telescope: find buffers",
                        },

                        {
                            "<Leader>fw",
                            "<CMD>Telescope current_buffer_fuzzy_find theme=ivy<CR>",
                            description = "Telescope: live_grep on curbuf",
                        },

                        -- {
                        --     "<Leader>fW",
                        --     function(opts)
                        --         local builtin = require "telescope.builtin"
                        --         opts = opts or {}
                        --         local opt = require("telescope.themes").get_ivy {
                        --
                        --             cwd = opts.dir,
                        --             prompt_title = "Live Grep for all Buffers",
                        --             grep_open_files = true,
                        --             shorten_path = true,
                        --             -- sorter = require("telescope.sorters").get_substr_matcher {},
                        --         }
                        --         return builtin.live_grep(opt)
                        --     end,
                        --     description = "Telescope: live_grep on buffers",
                        -- },

                        {
                            "<Leader>fo",
                            "<CMD>Telescope oldfiles<CR>",
                            description = "Telescope: oldfiles",
                        },
                        {
                            "<Leader>fh",
                            "<CMD>Telescope help_tags<CR>",
                            description = "Telescope: help tags",
                        },
                        {
                            "<Leader>fl",
                            "<CMD>Telescope resume<CR>",
                            description = "Telescope: resume (last search)",
                        },

                        {
                            "z=",
                            "<CMD> Telescope spell_suggest theme=get_cursor<CR>",
                            description = "Telescope: spell suggest",
                        },

                        -- {
                        --     "<Leader>fF",
                        --     function()
                        --         local plugins_directory = vim.fn.stdpath "data"
                        --             .. "/lazy"
                        --         return require("telescope.builtin").find_files {
                        --             cwd = plugins_directory,
                        --             prompt_title = "Find plugin files",
                        --         }
                        --     end,
                        --     description = "Find plugin files",
                        -- },

                        -- TELESCOPE-LAZY
                        {
                            "<Leader>fF",
                            "<CMD>Telescope lazy theme=ivy<CR>",
                            description = "Telescope-lazy: check plugins dir",
                        },
                        -- TELESCOPE-MENUFACTURE
                        {
                            "<Leader>ff",
                            function()
                                return require("telescope").extensions.menufacture.find_files()
                            end,
                            description = "Telescope-manufacture: find files",
                        },
                        -- {
                        --     "<Leader>fg",
                        --     function()
                        --         return require("telescope").extensions.menufacture.live_grep()
                        --     end,
                        --     description = "Telescope-manufacture: live_grep",
                        -- },

                        -- {
                        --     "<Leader>fg",
                        --     function()
                        --         return require("telescope").extensions.menufacture.grep_string()
                        --     end,
                        --     description = "Telescope-manufacture: grep string under cursor",
                        --     mode = { "v" },
                        -- },

                        -- TELESCOPE-GREPQF
                        {
                            "<Leader>fq",
                            "<CMD> Telescope grepqf theme=ivy<CR>",
                            description = "Telescope-grepqf: live_grep qf items",
                        },

                        -- TELESCOPE-SYMBOLS
                        {
                            "<Leader>f1",
                            "<CMD> Telescope symbols theme=ivy<CR>",
                            description = "Telescope-symbol: emoji",
                        },

                        -- CONDUCT-NVIM
                        {
                            "<Leader>fp",
                            "<CMD>Telescope conduct projects theme=ivy<CR>",
                            description = "Telescope-conductt: projects",
                        },
                    },
                    commands = {
                        {
                            ":Telescope highlights",
                            description = "Telescope: highlights",
                        },

                        {
                            ":Telescope keymaps",
                            description = "Telescope: keymaps",
                        },

                        {
                            ":Telescope colorscheme",
                            description = "Telescope: colorscheme",
                        },

                        {
                            ":Telescope commands",
                            description = "Telescope: commands",
                        },

                        -- TELESCOPE-LUASNIP
                        {
                            ":Telescope luasnip",
                            description = "Telescope-luasnip: open",
                        },
                    },
                },
            }
        end,
        dependencies = {
            "nvim-telescope/telescope-symbols.nvim",
            {
                "aaditeynair/conduct.nvim",
                init = function()
                    require("legendary").keymaps {
                        {
                            itemgroup = "Sessions",
                            keymaps = {
                                {
                                    "<Leader>sf",
                                    "<CMD>Telescope conduct sessions<CR>",
                                    description = "Telescope-conduct: session",
                                },
                            },
                        },
                    }
                end,
                config = function()
                    require("conduct").setup {}
                end,
            },
            "molecule-man/telescope-menufacture",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "tsakirist/telescope-lazy.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-lua/plenary.nvim",
            "benfowler/telescope-luasnip.nvim",
        },
        config = function()
            local telescope = require "telescope"
            local trouble = require "trouble.providers.telescope"
            local actions = require "telescope.actions"
            local themes = require "telescope.themes"

            local layout_actions = require "telescope.actions.layout"

            -- local foldMaps = function(_, _)
            --     require("telescope.actions.set").select:enhance {
            --         post = function()
            --             vim.cmd.normal { args = { "zx" }, bang = true }
            --         end,
            --     }
            --     return true
            -- end

            ---@param opts table
            ---@return table
            ---@diagnostic disable-next-line: redefined-local
            local function dropdown(opts)
                return require("telescope.themes").get_dropdown(
                    vim.tbl_extend("keep", opts or {}, {
                        borderchars = {
                            {
                                "─",
                                "│",
                                "─",
                                "│",
                                "┌",
                                "┐",
                                "┘",
                                "└",
                            },
                            prompt = {
                                "─",
                                "│",
                                " ",
                                "│",
                                "┌",
                                "┐",
                                "│",
                                "│",
                            },
                            results = {
                                "─",
                                "│",
                                "─",
                                "│",
                                "├",
                                "┤",
                                "┘",
                                "└",
                            },
                            preview = {
                                "─",
                                "│",
                                "─",
                                "│",
                                "┌",
                                "┐",
                                "┘",
                                "└",
                            },
                        },
                    })
                )
            end

            -- Telescope issue: kadang fold nya nge-bug, untuk sementara solusinya check the issue di github
            -- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-1311441898
            local function stopinsert(callback)
                return function(prompt_bufnr)
                    vim.cmd.stopinsert()
                    vim.schedule(function()
                        callback(prompt_bufnr)
                    end)
                end
            end

            -- local function stopinsert_fb(callback, callback_dir)
            --     return function(prompt_bufnr)
            --         local entry =
            --             require("telescope.actions.state").get_selected_entry()
            --         if entry and not entry.Path:is_dir() then
            --             stopinsert(callback)(prompt_bufnr)
            --         elseif callback_dir then
            --             callback_dir(prompt_bufnr)
            --         end
            --     end
            -- end

            telescope.setup {
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--hidden",
                        "--follow",
                        "--color=never",
                        "--column",
                        "--line-number",
                        "--with-filename",
                        "--no-heading",
                        "--smart-case",
                        "--trim", -- remove indentation
                    },
                    file_ignore_patterns = {
                        "%.jpg",
                        "%.jpeg",
                        "%.png",
                        "%.otf",
                        "%.ttf",
                        "%.DS_Store",
                        "^.git/",
                        "node%_modules/.*",
                        "^site-packages/",
                        "%.yarn/.*",
                    },
                    -- path_display = function(opts, path)
                    --     local tail = require("telescope.utils").path_tail(path)
                    --     return string.format("%s (%s)", tail, path)
                    -- end,
                    -- path_display = "smart",
                    sorting_strategy = "descending",
                    scroll_strategy = "cycle",
                    layout_strategy = "flex",
                    layout_config = {
                        horizontal = { preview_width = 0.55 },
                    },
                    prompt_prefix = "  ",
                    selection_caret = " ",
                    cycle_layout_list = { -- digunakan ketika use <c-l>
                        "flex",
                        "horizontal",
                        "vertical",
                        "bottom_pane",
                        "center",
                    },
                    borderchars = {
                        "─",
                        "│",
                        "─",
                        "│",
                        "┌",
                        "┐",
                        "┘",
                        "└",
                    },
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<c-c>"] = actions.close,

                            ["<c-o>"] = trouble.open_with_trouble,

                            ["<c-j>"] = actions.cycle_history_next,
                            ["<c-k>"] = actions.cycle_history_prev,

                            ["<CR>"] = stopinsert(actions.select_default),
                            ["<C-x>"] = stopinsert(actions.select_horizontal),
                            ["<C-v>"] = stopinsert(actions.select_vertical),
                            ["<C-t>"] = stopinsert(actions.select_tab),

                            -- ["<C-s>"] = actions.select_horizontal,
                            -- ["<C-v>"] = actions.select_vertical,
                            -- ["<C-t>"] = actions.select_tab,

                            ["<c-r>"] = actions.to_fuzzy_refine,
                            ["<C-/>"] = actions.which_key, -- keys from pressing <C-/>

                            ["<F6>"] = layout_actions.cycle_layout_next,
                            ["<F4>"] = layout_actions.toggle_preview,

                            ["<hh>"] = function()
                                vim.cmd.stopinsert()
                            end,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    highlights = {
                        theme = "ivy",
                    },
                    buffers = dropdown {
                        sort_mru = true,
                        sort_lastused = true,
                        show_all_buffers = true,
                        ignore_current_buffer = true,
                        previewer = false,
                        mappings = {
                            i = { ["<c-x>"] = "delete_buffer" },
                            n = { ["<c-x>"] = "delete_buffer" },
                        },
                    },
                    oldfiles = dropdown {},
                    find_files = themes.get_ivy { hidden = true },
                    help_tags = { theme = "ivy" },
                    live_grep = themes.get_ivy {
                        file_ignore_patterns = { ".git/", "%.svg", "%.lock" },
                        max_results = 2000,
                    },
                    current_buffer_fuzzy_find = dropdown {
                        previewer = false,
                        shorten_path = false,
                    },
                    diagnostics = dropdown {},
                    colorscheme = { enable_preview = true },
                    keymaps = dropdown {
                        layout_config = { height = 18, width = 0.5 },
                    },
                    lsp_references = {
                        sorting_strategy = "descending",
                        layout_strategy = "vertical", -- ivy, cursor, dropdown
                        theme = "dropdown",
                        preview_title = false,
                        path_display = { "shorten" },
                        prompt_title = "References",
                        layout_config = {
                            width = 0.80,
                            height = 0.80,
                            -- preview_width = 0.70,
                        },
                    },
                },

                extensions = {
                    file_browser = {
                        theme = "ivy",
                        mappings = {
                            i = {
                                ["<CR>"] = stopinsert(actions.select_default),
                                ["<C-x>"] = stopinsert(
                                    actions.select_horizontal
                                ),
                                ["<C-v>"] = stopinsert(actions.select_vertical),
                                ["<C-t>"] = stopinsert(actions.select_tab),
                            },
                        },
                    },
                    persisted = dropdown {},
                    live_grep_args = {
                        auto_quoting = false, -- enable/disable auto-quoting
                    },
                },
            }

            telescope.load_extension "fzf"
            telescope.load_extension "file_browser"
            telescope.load_extension "conduct" -- sessions telescope
            telescope.load_extension "aerial"
            telescope.load_extension "luasnip"
            telescope.load_extension "lazy"
            telescope.load_extension "menufacture"
            telescope.load_extension "live_grep_args"

            -- My extensions
            telescope.load_extension "grepqf"
            -- telescope.load_extension "conventional_commits"
        end,
    },
    -- SPECTRE
    {
        "windwp/nvim-spectre",
        -- init = function()
        --     require("legendary").keymaps {
        --         {
        --             itemgroup = "Misc",
        --             keymaps = {
        --                 {
        --                     "<Leader><s-f>",
        --                     function()
        --                         require("r.utils.tiling").force_win_close(
        --                             {},
        --                             true
        --                         )
        --                         return require("spectre").open()
        --                     end,
        --                     description = "Spectre: open",
        --                 },
        --                 {
        --                     "<Leader><s-f>",
        --                     function()
        --                         require("r.utils.tiling").force_win_close(
        --                             {},
        --                             true
        --                         )
        --                         return require("spectre").open_visual {
        --                             select_word = true,
        --                         }
        --                     end,
        --                     description = "Spectre: open [visual]",
        --                     mode = { "v" },
        --                 },
        --             },
        --         },
        --     }
        -- end,
        config = function()
            local spectre = require "spectre"

            as.augroup("SpectreClose", {
                event = { "FileType" },
                pattern = { "spectre_panel" },
                command = [[setlocal nofoldenable | nnoremap <buffer>q <cmd>q<CR>]],
            })

            highlight.plugin("Spectre", {
                {
                    TargetKeyword = {
                        fg = as.ui.palette.bright_yellow,
                        bold = true,
                        italic = true,
                    },
                },
                {
                    TargetFileDirectory = {
                        bg = "DarkCyan",
                        fg = "black",
                        bold = true,
                    },
                },

                {
                    TargetFilename = {
                        bg = "Cyan",
                        fg = "black",
                        bold = true,
                    },
                },
                {
                    TargetReplace = {
                        bg = as.ui.palette.light_red,
                        fg = "black",
                        italic = true,
                    },
                },
            })
            spectre.setup {
                color_devicons = true,
                open_cmd = "vnew",
                live_update = false, -- auto excute search again when you write any file in vim
                line_sep_start = "┌-----------------------------------------",
                result_padding = "¦  ",
                line_sep = "└-----------------------------------------",
                highlight = {
                    ui = "String",
                    filename = "TargetFilename",
                    filedirectory = "TargetFileDirectory",
                    search = "TargetKeyword",
                    replace = "TargetReplace",
                },
                mapping = {
                    ["toggle_line"] = {
                        map = "dd",
                        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                        desc = "toggle current item",
                    },
                    ["enter_file"] = {
                        map = "<cr>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                        desc = "goto current file",
                    },
                    ["send_to_qf"] = {
                        map = "<c-q>",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all item to quickfix",
                    },
                    ["replace_cmd"] = {
                        map = "<c-c>",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "input replace vim command",
                    },
                    ["show_option_menu"] = {
                        map = "<leader>o",
                        cmd = "<cmd>lua require('spectre').show_options()<CR>",
                        desc = "show option",
                    },
                    ["run_current_replace"] = {
                        map = "rc",
                        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                        desc = "replace current line",
                    },
                    ["run_replace"] = {
                        map = "R",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "replace all",
                    },
                    ["change_view_mode"] = {
                        map = "<leader>v",
                        cmd = "<cmd>lua require('spectre').change_view()<CR>",
                        desc = "change result view mode",
                    },
                    ["change_replace_sed"] = {
                        map = "ts",
                        cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
                        desc = "use sed to replace",
                    },
                    ["toggle_live_update"] = {
                        map = "tu",
                        cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
                        desc = "update change when vim write file.",
                    },
                    ["toggle_ignore_case"] = {
                        map = "ti",
                        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                        desc = "toggle ignore case",
                    },
                    ["toggle_ignore_hidden"] = {
                        map = "th",
                        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                        desc = "toggle search hidden",
                    },
                    -- you can put your mapping here it only use normal mode
                },
                find_engine = {
                    -- rg is map with finder_cmd
                    ["rg"] = {
                        cmd = "rg",
                        -- default args
                        args = {
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                        },
                        options = {
                            ["ignore-case"] = {
                                value = "--ignore-case",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                            ["hidden"] = {
                                value = "--hidden",
                                desc = "hidden file",
                                icon = "[H]",
                            },
                            -- you can put any rg search option you want here it can toggle with
                            -- show_option function
                        },
                    },
                    ["ag"] = {
                        cmd = "ag",
                        args = {
                            "--vimgrep",
                            "-s",
                        },
                        options = {
                            ["ignore-case"] = {
                                value = "-i",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                            ["hidden"] = {
                                value = "--hidden",
                                desc = "hidden file",
                                icon = "[H]",
                            },
                        },
                    },
                },
                replace_engine = {
                    ["sed"] = {
                        cmd = "sed",
                        args = nil,
                        options = {
                            ["ignore-case"] = {
                                value = "--ignore-case",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                        },
                    },
                },
                default = {
                    find = {
                        --pick one of item in find_engine
                        cmd = "rg",
                        options = { "ignore-case", "hidden" },
                    },
                    replace = {
                        --pick one of item in replace_engine
                        cmd = "sed",
                    },
                },
                replace_vim_cmd = "cdo",
                is_open_target_win = true, --open file on opener window
                is_insert_mode = false, -- start open panel on is_insert_mode
            }
        end,
    },
    -- TODO-COMMENTS
    {
        "mrowegawd/todo.nvim",
        cmd = { "TODOQuickFixList" },
        event = "BufReadPost",
        -- init = function()
        --     require("legendary").keymaps {
        --         {
        --             itemgroup = "Todo Comment",
        --             description = "Searching todo!",
        --             icon = as.ui.icons.misc.tag,
        --             keymaps = {
        --                 {
        --                     "<Leader>tq",
        --                     function()
        --                         return cmd(
        --                             fmt(
        --                                 "TODOQuickfixList cwd=%s",
        --                                 fn.expand "%:p"
        --                             )
        --                         )
        --                     end,
        --                     description = "Todocomment: find todo comment curbuf",
        --                     mode = { "n", "v" },
        --                 },
        --                 {
        --                     "<Leader>tQ",
        --                     fmt(
        --                         "<CMD>TODOQuickfixList cwd=%s<CR>",
        --                         fn.getcwd()
        --                     ),
        --                     description = "Todocomment: find all todo comments on repo",
        --                 },

        --                 -- TELESCOPE
        --                 -- {
        --                 --     "<Leader>ft",
        --                 --     "<CMD>TodoTelescope<CR>",
        --                 --     description = "Telescope: open todotroble with telescope",
        --                 -- },
        --             },
        --         },
        --     }
        -- end,
        opts = {
            signs = {
                enable = true, -- show icons in the sign column
                priority = 8,
            },
            keywords = {
                FIX = {
                    icon = " ", -- used for the sign, and search results
                    -- can be a hex color, or a named color
                    -- named colors definitions follow below
                    color = "error",
                    -- a set of other keywords that all map to this FIX keywords
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                    -- signs = false -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                WARN = {
                    icon = " ",
                    color = "warning",
                    alt = { "WARNING" },
                },
                -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            },
            merge_keywords = false, -- wheather to merge custom keywords with defaults
            highlight = {
                -- highlights before the keyword (typically comment characters)
                before = "", -- "fg", "bg", or empty
                -- highlights of the keyword
                -- wide is the same as bg, but also highlights the colon
                keyword = "wide", -- "fg", "bg", "wide", or empty
                -- highlights after the keyword (TODO text)
                after = "fg", -- "fg", "bg", or empty
                -- pattern can be a string, or a table of regexes that will be checked
                -- vim regex
                pattern = [[.*<(KEYWORDS)\s*:]],
                comments_only = true, -- highlight only inside comments using treesitter
                max_line_len = 400, -- ignore lines longer than this
                exclude = {}, -- list of file types to exclude highlighting
            },
            -- list of named colors
            -- a list of hex colors or highlight groups
            -- will use the first valid one
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
            },
            -- rg_rege = {
            --     "--color=always",
            --     "--no-heading",
            --     "--follow",
            --     "--hidden",
            --     "--with-filename",
            --     "--line-number",
            --     "--column",
            --     "-g",
            --     "!node_modules/**",
            --     "-g",
            --     "!.git/**",
            -- },
            search = {
                command = "rg",

                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
            },
            -- signs = true, -- show icons in the signs column
            -- sign_priority = 8, -- sign priority
            -- -- keywords recognized as todo comments
            -- keywords = {
            --     FIX = {
            --         icon = " ", -- icon used for the sign, and in search results
            --         color = "error", -- can be a hex color, or a named color (see below)
            --         alt = {
            --             "FIXME",
            --             "BUG",
            --             "FIXIT",
            --             "ISSUE",
            --             "fix",
            --             "fixme",
            --             "bug",
            --         }, -- a set of other keywords that all map to this FIX keywords
            --         -- alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            --         -- signs = false, -- configure signs for some keywords individually
            --     },
            --     TODO = { icon = " ", color = "info" },
            --     HACK = { icon = " ", color = "warning" },
            --     WARN = {
            --         icon = " ",
            --         color = "warning",
            --         alt = { "WARNING", "XXX" },
            --     },
            --     PERF = {
            --         icon = " ",
            --         alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
            --     },
            --     -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            -- },
            -- merge_keywords = false, -- when true, custom keywords will be merged with the defaults
            -- -- highlighting of the line containing the todo comment
            -- -- * before: highlights before the keyword (typically comment characters)
            -- -- * keyword: highlights of the keyword
            -- -- * after: highlights after the keyword (todo text)
            -- highlight = {
            --     before = "", -- "fg" or "bg" or empty
            --     keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
            --     after = "", -- "fg" or "bg" or empty
            --     pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
            --     comments_only = true, -- uses treesitter to match keywords in comments only
            --     exclude = {
            --         -- "org",
            --         -- "norg",
            --         "git",
            --         ".git",
            --         "gitcommit",
            --         "grc",
            --         "snippets",
            --         "fugitive",
            --         "help",
            --         "markdown",
            --         "qf",
            --         "fugitiveblame",
            --         "DiffviewFileHistory",
            --     }, -- list of file types to exclude highlighting
            -- },
            -- -- list of named colors where we try to extract the guifg from the
            -- -- list of hilight groups or use the hex color if hl not found as a fallback
            -- -- colors = {
            -- --     error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
            -- --     warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
            -- --     info = { "DiagnosticInformation", "#2563EB" },
            -- --     hint = { "DiagnosticInformation", "#10B981" },
            -- --     default = { "Identifier", "#7C3AED" },
            -- -- },
            -- search = {
            --     command = "rg",
            --     args = {
            --         "--color=never",
            --         "--no-heading",
            --         "--follow",
            --         "--hidden",
            --         "--with-filename",
            --         "--line-number",
            --         "--column",
            --         "-g",
            --         "!node_modules/**",
            --         "-g",
            --         "!.git/**",
            --     },
            --     -- regex that will be used to match keywords.
            --     -- don't replace the (KEYWORDS) placeholder
            --     pattern = [[\b(KEYWORDS):]], -- ripgrep regex
            --     -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            -- },
        },
    },
}
