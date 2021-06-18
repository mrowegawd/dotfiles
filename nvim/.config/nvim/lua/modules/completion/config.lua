local config = {}

function config.nvim_lsp()
    require("modules.completion.lspconfig")
end

function config.nvim_compe()
    require "compe".setup {
        enabled = true,
        debug = false,
        min_length = 1,
        preselect = "always",
        allow_prefix_unmatch = false,
        source = {
            path = {kind = " "},
            buffer = {kind = " "},
            calc = {kind = "  "},
            vsnip = {kind = "S "},
            nvim_lsp = {kind = " "},
            nvim_lua = {kind = " "},
            spell = {kind = " "},
            treesitter = {kind = " "},
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
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd popup.nvim]]
        vim.cmd [[packadd telescope-fzy-native.nvim]]
    end
    require("telescope").setup {
        defaults = {
            prompt_prefix = "🔭 ",
            prompt_position = "top",
            selection_caret = " ",
            sorting_strategy = "ascending",
            results_width = 0.6,
            file_previewer = require "telescope.previewers".vim_buffer_cat.new,
            grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
            qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true
            }
        }
    }
    require "telescope".load_extension("fzy_native")
    require "telescope".load_extension("dotfiles")
    require "telescope".load_extension("gosource")
    require "telescope".load_extension("grep_myprompt")
    require "telescope".load_extension("grep_mypromptword")
    require "telescope".load_extension("find_myfiles")

    -- Dap extensions
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
