local config = {}

function config.nvim_lsp()
    require("modules.completion.lspconfig")
end

function config.neoformat()
    require("core.event").nvim_create_augroups {
        au_neoformat = {
            {
                "BufWritePre",
                "*",
                [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
            }
        }
    }

    vim.g.neoformat_basic_format_trim = 1 -- -- end
    -- vim.g.neoformat_run_all_formatters = 0
    -- vim.g.neoformat_enabled_python = {"autopep8", "yapf", "docformatter"}
    -- vim.g.neoformat_enabled_javascript = {"prettier"}
    -- -- if not O.format_on_save then
end

function config.nvim_compe()
    local opt = {
        enabled = O.plugin.lsp.completion,
        debug = false,
        autocomplete = true,
        min_length = 1,
        preselect = "enable",
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,
        source = {
            path = {kind = "   (Path)"},
            buffer = {kind = "   (Buffer)"},
            -- vsnip = {kind = "S ", priority = 2000, sort = true, fuzzy = false},
            vsnip = {kind = "   (Snippet)"},
            nvim_lsp = {kind = "   (LSP)"},
            neorg = {kind = " + (Norg)"},
            orgmode = {kind = " + (Orgmode)"},
            calc = {kind = "   (Calc)"},
            treesitter = {kind = " (TreeSitter)"},
            emoji = {kind = " ﲃ  (Emoji)", filetypes = {"markdown", "text"}},
            nvim_lua = false,
            spell = false,
            tags = false,
            snippets_nvim = false -- { kind = " " },
        }
    }

    local status_ok, compe = pcall(require, "compe")
    if not status_ok then
        print("+ compe not active")
        return
    end

    compe.setup(opt)

    vim.lsp.protocol.CompletionItemKind = {
        " text",
        " method",
        " function",
        " constructor",
        "ﰠ field",
        " variable",
        " class",
        " interface",
        " module",
        " property",
        " unit",
        " value",
        " enum",
        " key",
        "﬌ snippet",
        " color",
        " file",
        " reference",
        " folder",
        " enum member",
        " constant",
        " struct",
        "⌘ event",
        " operator",
        "♛ type"
    }

    local check_back_space = function()
        local col = vim.fn.col "." - 1
        if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
            return true
        else
            return false
        end
    end

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
        elseif vim.fn.call("vsnip#available", {1}) == 1 then
            return t "<Plug>(vsnip-expand-or-jump)"
        elseif check_back_space() then
            return t "<Tab>"
        else
            return vim.fn["compe#complete"]()
        end
    end

    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
        elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
            return t "<Plug>(vsnip-jump-prev)"
        else
            return t "<S-Tab>"
        end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

    vim.api.nvim_set_keymap("i", "<C-space>", "compe#complete()", {noremap = true, silent = true, expr = true})
    vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {noremap = true, silent = true, expr = true})
    vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {noremap = true, silent = true, expr = true})
    vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {noremap = true, silent = true, expr = true})
    vim.api.nvim_set_keymap("i", "<C-b>", "compe#scroll({ 'delta': -4 })", {noremap = true, silent = true, expr = true})
end

function config.vim_vsnip()
    vim.g.vsnip_snippet_dir = os.getenv("HOME") .. "/Dropbox/data.programming.forprivate/vsnip"
    --   vim.g.vsnip_filetypes = {}
    --   vim.g.vsnip_filetypes['typescript'] = ['javascript']
    --   vim.g.vsnip_filetypes['svelte'] = ['javascript', 'typescript', 'html']
    --
    local remap = vim.api.nvim_set_keymap

    remap("i", "<C-f>", 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-f>"', {silent = true, expr = true})
    remap("s", "<C-f>", 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-f>"', {silent = true, expr = true})
    remap("i", "<C-b>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-b>"', {silent = true, expr = true})
    remap("s", "<C-b>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-b>"', {silent = true, expr = true})
end

function config.telescope()
    if not packer_plugins["popup.nvim"].loaded then
        vim.cmd([[packadd popup.nvim]])
        vim.cmd([[packadd cfilter]]) -- for filter quickfix, :h cfilter-plugin
        vim.cmd([[packadd telescope-fzf-native.nvim]])
    end
    local action_state = require("telescope.actions.state")
    local actions = require("telescope.actions")
    local global_state = require("telescope.state")

    local entry_to_qf = function(entry)
        return {
            bufnr = entry.bufnr,
            filename = entry.filename,
            lnum = entry.lnum,
            col = entry.col,
            text = entry.text or entry.value.text or entry.value
        }
    end

    local send_allqf = function(prompt_bufnr, mode, target)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local manager = picker.manager

        local qf_entries = {}
        for entry in manager:iter() do
            table.insert(qf_entries, entry_to_qf(entry))
        end

        actions.close(prompt_bufnr)

        local title = global_state.get_global_key("current_line")

        if title == "" then
            title = "Yo"
        end

        if target == "loclist" then
            vim.fn.setloclist(picker.original_win_id, qf_entries, mode)
        else
            vim.fn.setqflist({}, " ", {title = title, id = "$", items = qf_entries})
        end
    end

    local send_to_allqf = function(prompt_bufnr)
        send_allqf(prompt_bufnr, "r")
        vim.api.nvim_command("copen")
    end

    require("telescope").setup {
        defaults = {
            vimgrep_arguments = O.default.vimgrep_arguments,
            prompt_prefix = "🔭 ",
            layout_config = {
                prompt_position = "top",
                horizontal = {
                    mirror = false
                },
                vertical = {
                    mirror = false
                }
            },
            selection_caret = " ",
            sorting_strategy = "ascending",
            file_previewer = require "telescope.previewers".vim_buffer_cat.new,
            grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
            qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
            mappings = {
                i = {
                    ["<F1>"] = send_to_allqf
                }
            }
        },
        extensions = {
            fzf = {
                fuzzy = false, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    }
    require "telescope".load_extension("fzf")
    require "telescope".load_extension("dotfiles")
    require "telescope".load_extension("gosource")
    require "telescope".load_extension("grepword")
    require "telescope".load_extension("grepcword")
    require "telescope".load_extension("notes")
    require "telescope".load_extension("notes_browser")
    require "telescope".load_extension("find_myfiles")

    -- zettel
    require "telescope".load_extension("grepzettel")

    -- dap
    require "telescope".load_extension("dap")
end

function config.fzf_lua()
    local actions = require "fzf-lua.actions"
    -- local vimrg = table.concat(O.default.vimgrep_arguments, " ")
    require "fzf-lua".setup {
        win_height = 0.85, -- window height
        win_width = 0.80, -- window width
        win_row = 0.30, -- window row position (0=top, 1=bottom)
        win_col = 0.50, -- window col position (0=left, 1=right)
        -- win_border          = false,         -- window border? or borderchars?
        win_border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
        fzf_args = "", -- adv: fzf extra args, empty unless adv
        fzf_layout = "reverse", -- fzf '--layout='
        preview_cmd = "", -- 'head -n $FZF_PREVIEW_LINES',
        preview_border = "border", -- border|noborder
        preview_wrap = "nowrap", -- wrap|nowrap
        preview_opts = "nohidden", -- hidden|nohidden
        preview_vertical = "down:45%", -- up|down:size
        preview_horizontal = "right:60%", -- right|left:size
        preview_layout = "flex", -- horizontal|vertical|flex
        flip_columns = 120, -- #cols to switch to horizontal on flex
        bat_theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
        bat_opts = "--style=numbers,changes --color always",
        files = {
            prompt = "Files❯ ",
            cmd = "", -- "find . -type f -printf '%P\n'",
            git_icons = true, -- show git icons?
            file_icons = true, -- show file icons?
            color_icons = true, -- colorize file|git icons
            actions = {
                ["default"] = actions.file_edit,
                ["ctrl-s"] = actions.file_split,
                ["ctrl-v"] = actions.file_vsplit,
                ["ctrl-t"] = actions.file_tabedit,
                ["ctrl-q"] = actions.file_sel_to_qf,
                ["ctrl-y"] = function(selected)
                    print(selected[2])
                end
            }
        },
        grep = {
            prompt = "Rg❯ ",
            input_prompt = "Grep For❯ ",
            -- cmd = "rg --hidden --follow --no-ignore-vcs -g !{node_modules.git__pycache__.pytest_cache} --no-heading --with-filename --line-number --column --smart-case",
            rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*'",
            -- cmd = O.grep_concatstring,
            git_icons = true, -- show git icons?
            file_icons = true, -- show file icons?
            color_icons = true, -- colorize file|git icons
            actions = {
                ["default"] = actions.file_edit,
                ["ctrl-s"] = actions.file_split,
                ["ctrl-v"] = actions.file_vsplit,
                ["ctrl-t"] = actions.file_tabedit,
                ["ctrl-q"] = actions.file_sel_to_qf,
                ["ctrl-y"] = function(selected)
                    print(selected[2])
                end
            }
        },
        oldfiles = {
            prompt = "History❯ ",
            cwd_only = false
        },
        git = {
            prompt = "GitFiles❯ ",
            cmd = "git ls-files -m",
            git_icons = true, -- show git icons?
            file_icons = true, -- show file icons?
            color_icons = true -- colorize file|git icons
        },
        buffers = {
            prompt = "Buffers❯ ",
            file_icons = true, -- show file icons?
            color_icons = true, -- colorize file|git icons
            sort_lastused = true, -- sort buffers() by last used
            actions = {
                ["default"] = actions.buf_edit,
                ["ctrl-s"] = actions.buf_split,
                ["ctrl-v"] = actions.buf_vsplit,
                ["ctrl-t"] = actions.buf_tabedit,
                ["ctrl-x"] = actions.buf_del
            }
        },
        colorschemes = {
            prompt = "Colorschemes❯ ",
            live_preview = true,
            actions = {
                ["default"] = actions.colorscheme,
                ["ctrl-y"] = function(selected)
                    print(selected[2])
                end
            },
            winopts = {
                win_height = 0.55,
                win_width = 0.30,
                window_on_create = function()
                    vim.cmd("set winhl=Normal:Normal")
                end
            },
            post_reset_cb = function()
                require("feline").reset_highlights()
            end
        },
        quickfix = {
            cwd = vim.loop.cwd(),
            file_icons = true
        },
        -- placeholders for additional user customizations
        loclist = {},
        helptags = {},
        manpages = {},
        file_icon_colors = {
            -- override colors for extensions
            ["lua"] = "blue"
        },
        git_icons = {
            -- override colors for git icons
            ["M"] = "M", --"★",
            ["D"] = "D", --"✗",
            ["A"] = "A", --"+",
            ["?"] = "?"
        },
        git_icon_colors = {
            -- override colors for git icon colors
            ["M"] = "yellow",
            ["D"] = "red",
            ["A"] = "green",
            ["?"] = "magenta"
        },
        fzf_binds = {
            -- fzf '--bind=' options
            "f2:toggle-preview",
            "f3:toggle-preview-wrap",
            "shift-down:preview-page-down",
            "shift-up:preview-page-up",
            "ctrl-d:half-page-down",
            "ctrl-u:half-page-up",
            "ctrl-f:page-down",
            "ctrl-b:page-up",
            "ctrl-a:toggle-all",
            "ctrl-u:clear-query"
        },
        window_on_create = function()
            -- nvim window options override
            vim.cmd("set winhl=Normal:Normal") -- popup bg match normal windows
        end
    }
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

function config.smart_input()
    require("smartinput").setup {
        ["go"] = {";", ":=", ";"}
    }
end

function config.emmet()
    vim.g.user_emmet_complete_tag = 0
    vim.g.user_emmet_install_global = 0
    vim.g.user_emmet_install_command = 0
    vim.g.user_emmet_mode = "i"
end

return config
