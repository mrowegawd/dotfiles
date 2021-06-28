local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
    event = "BufReadPre",
    config = conf.nvim_lsp,
    opt = true,
    wants = {"null-ls.nvim"},
    requires = {
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        "jose-elias-alvarez/null-ls.nvim"
        -- {'folke/lsp-colors.nvim', opt=true}
    }
}

completion["glepnir/lspsaga.nvim"] = {
    cmd = "Lspsaga"
}

-- completion["dense-analysis/ale"] = {
--     event = "InsertEnter"
--     config = function()
--         -- These settings need to load first,
--         vim.g.ale_fixers = {
--             ["css"] = {"prettier"},
--             ["dart"] = {"dartfmt"},
--             ["javascript"] = {"prettier-standard"},
--             ["typescript"] = {"prettier", "eslint"},
--             ["json"] = {"prettier"},
--             ["ruby"] = {"standardrb"},
--             ["scss"] = {"prettier"},
--             ["yml"] = {"prettier"},
--             ["lua"] = {"luafmt"}
--         }
--         vim.g.ale_linters = {
--             ["css"] = {"csslint"},
--             ["eruby"] = {"erb"},
--             ["javascript"] = {"standard"},
--             ["typescript"] = {"eslint"},
--             ["json"] = {"jsonlint"},
--             ["markdown"] = {"mdl"},
--             ["ruby"] = {"standardrb"},
--             ["scss"] = {"sasslint"},
--             ["yaml"] = {"yamllint"}
--         }
--         vim.g.ale_completion_enabled = 0
--         vim.g.ale_fix_on_save = 1
--         vim.g.ale_hover_cursor = 0
--         vim.g.ale_lint_on_enter = 0
--         vim.g.ale_lint_on_filetype_changed = 0
--         vim.g.ale_lint_on_insert_leave = 0
--         vim.g.ale_lint_on_save = 1
--         vim.g.ale_lint_on_text_changed = "never"
--         vim.g.ale_linters_explicit = 1
--         vim.g.ale_open_list = 0
--         vim.g.ale_sign_error = "▶"
--         vim.g.ale_sign_warning = "▶"
--         vim.g.ale_sign_info = "▶"
--         vim.g.ale_sign_priority = 9
--         vim.g.ale_echo_cursor = 0
--         vim.g.ale_virtualtext_cursor = 1
--         vim.g.ale_virtualtext_prefix = " ▶ "
--     end
-- }

completion["hrsh7th/nvim-compe"] = {
    event = "InsertEnter",
    config = conf.nvim_compe
}

completion["hrsh7th/vim-vsnip"] = {
    event = "InsertCharPre",
    config = conf.vim_vsnip
}

completion["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = conf.telescope,
    requires = {
        {"nvim-lua/popup.nvim", opt = true},
        {"nvim-lua/plenary.nvim", opt = true},
        {"nvim-telescope/telescope-fzf-native.nvim", opt = true, run = "make"}
    }
}

-- completion['mattn/vim-sonictemplate'] = {
--   cmd = 'Template',
--   ft = {'go','typescript','lua','javascript','vim','rust','markdown'},
--   config = conf.vim_sonictemplate,
-- }

-- completion['mattn/emmet-vim'] = {
--   event = 'InsertEnter',
--   ft = {'html','css','javascript','javascriptreact','vue','typescript','typescriptreact'},
--   config = conf.emmet,
-- }

return completion
