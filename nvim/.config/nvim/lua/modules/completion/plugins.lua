local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
    event = "BufRead",
    config = conf.nvim_lsp,
    opt = true,
    requires = {
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/null-ls.nvim"
    }
}

completion["jose-elias-alvarez/nvim-lsp-ts-utils"] = {
    ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    }
}

completion["sbdchd/neoformat"] = {
    event = "BufRead",
    config = conf.neoformat
}

completion["hrsh7th/nvim-compe"] = {
    -- event = "InsertEnter",
    config = conf.nvim_compe,
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim"
    }
}

completion["hrsh7th/vim-vsnip"] = {
    event = "InsertCharPre",
    config = conf.vim_vsnip
}

completion["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = conf.telescope
}

completion["nvim-telescope/telescope-fzf-native.nvim"] = {
    cmd = "Telescope",
    run = "make"
}

completion["ibhagwan/fzf-lua"] = {
    config = conf.fzf_lua,
    requires = {
        "vijaymarupudi/nvim-fzf" -- as backend
        -- "ibhagwan/nvim-fzf"
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
