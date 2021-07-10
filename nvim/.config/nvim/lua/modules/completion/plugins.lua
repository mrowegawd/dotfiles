local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
    event = "BufRead",
    config = conf.nvim_lsp,
    opt = true,
    requires = {
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils"
        -- "jose-elias-alvarez/null-ls.nvim"
        -- "folke/lsp-colors.nvim"
    }
}

completion["sbdchd/neoformat"] = {
    event = "BufRead",
    config = conf.neoformat
}

completion["hrsh7th/nvim-compe"] = {
    event = "InsertEnter",
    config = conf.nvim_compe
}

completion["hrsh7th/vim-vsnip"] = {
    event = "InsertCharPre",
    config = conf.vim_vsnip
}

completion["nvim-lua/plenary.nvim"] = {
    event = "BufRead"
}

completion["nvim-telescope/telescope-fzf-native.nvim"] = {
    event = "BufRead",
    run = "make"
}

completion["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = conf.telescope,
    requires = {
        {"nvim-lua/popup.nvim", opt = true}
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
