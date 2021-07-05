local config = {}

function config.nvim_lsp()
    require("modules.completion.lspconfig")
end

function config.nvim_compe()
    require "compe".setup {
        enabled = true,
        debug = false,
        autocomplete = true,
        min_length = 1,
        allow_prefix_unmatch = true,
        preselect = "always",
        source = {
            -- vsnip = {kind = "S ", priority = 2000, sort = true, fuzzy = false},
            vsnip = {kind = "S ", fuzzy = false},
            path = {kind = " "},
            buffer = {kind = " "},
            calc = {kind = "  "},
            nvim_lsp = {kind = " "},
            nvim_lua = {kind = " "},
            treesitter = {kind = " "},
            orgmode = true,
            -- spell = {kind = " "},
            spell = false,
            tags = false,
            snippets_nvim = false -- { kind = " " },
            -- emoji = { kind = " ﲃ " },
            -- for emoji press : (idk how make this work?)
        }
    }

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
