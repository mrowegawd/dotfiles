local config = {}

function config.nvim_lsp()
    require("modules.completion.lspconfig")
end

function config.neoformat()
    -- if O.format_on_save then
    -- require("lv-utils").define_augroups {
    --     autoformat = {
    --         {
    --             "BufWritePre",
    --             "*",
    --             [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
    --         }
    --     }
    -- }
    vim.g.neoformat_basic_format_trim = 1 -- -- end
    -- vim.g.neoformat_run_all_formatters = 0
    -- vim.g.neoformat_enabled_python = {"autopep8", "yapf", "docformatter"}
    -- vim.g.neoformat_enabled_javascript = {"prettier"}
    -- -- if not O.format_on_save then
    -- vim.cmd [[if exists('#autoformat#BufWritePre')
    --     :autocmd! autoformat
    --     endif]]
    -- -- end
end

function config.nvim_compe()
    local opt = {
        enabled = true,
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
            calc = {kind = "   (Calc)"},
            -- vsnip = {kind = "S ", priority = 2000, sort = true, fuzzy = false},
            vsnip = {kind = "   (Snippet)"},
            nvim_lsp = {kind = "   (LSP)"},
            treesitter = {kind = " (TreeSitter)"},
            emoji = {kind = " ﲃ  (Emoji)", filetypes = {"markdown", "text"}},
            orgmode = {kind = " + (Orgmode)"},
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
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd popup.nvim]]
        vim.cmd [[packadd cfilter]] -- for filter quickfix, :h cfilter-plugin
        vim.cmd [[packadd telescope-fzf-native.nvim]]
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
    require "telescope".load_extension("find_myfiles")

    -- zettel
    require "telescope".load_extension("grepzettel")

    -- dap
    require "telescope".load_extension("dap")
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
