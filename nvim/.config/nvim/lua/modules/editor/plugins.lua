local editor = {}
local conf = require("modules.editor.config")

editor["Raimondi/delimitMate"] = {
    event = "InsertEnter",
    config = conf.delimimate
}

editor["editorconfig/editorconfig-vim"] = {
    ft = {"go", "typescript", "javascript", "vim", "rust", "zig", "c", "cpp"}
}

editor["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    requires = "tpope/vim-commentary"
}

editor["norcalli/nvim-colorizer.lua"] = {
    -- ft = {"html", "css", "sass", "vim", "typescript", "typescriptreact", "xdefaults"},
    cmd = "ColorizerToggle",
    opt = true,
    event = "BufWinEnter",
    config = conf.nvim_colorizer
}

editor["itchyny/vim-cursorword"] = {
    event = {"BufRead", "BufNewFile"},
    config = conf.vim_cursorwod
}

editor["hrsh7th/vim-eft"] = {
    opt = true,
    config = function()
        vim.g.eft_ignorecase = true
    end
}

editor["AndrewRadev/splitjoin.vim"] = {
    event = "BufRead",
    opt = true
}

editor["kana/vim-operator-replace"] = {
    keys = {{"x", "p"}},
    config = function()
        vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)", {silent = true})
    end,
    requires = "kana/vim-operator-user"
}

editor["rhysd/vim-operator-surround"] = {
    event = "BufRead",
    requires = "kana/vim-operator-user"
}

-- editor["kana/vim-niceblock"] = {
--     event = "BufRead",
--     opt = true
-- }

editor["rcarriga/nvim-dap-ui"] = {
    event = "BufRead",
    config = conf.nvim_dap,
    -- disable = not true,
    requires = {
        "nvim-telescope/telescope-dap.nvim",
        {
            "mfussenegger/nvim-dap",
            requires = {
                "mfussenegger/nvim-dap-python"
            }
        },
        {"theHamsta/nvim-dap-virtual-text", opt = true}
    }
}

editor["vim-test/vim-test"] = {
    cmd = {"TestFile", "TestNearest", "TestSuite"},
    opt = true,
    config = conf.vim_test
}

-- editor['rcarriga/vim-ultest'] = {
--   cmd = {"Ultest", "UltestNearest"},
--   run = ":UpdateRemotePlugins",
--   -- opt = true,
--   config = conf.vim_ultest,
--   requires = {
--     {"vim-test/vim-test"}
--   }
-- }

editor["tpope/vim-projectionist"] = {
    ft = {"html", "css", "sass", "typescript", "typescriptreact", "python", "golang"},
    config = conf.vim_projectionist
}

return editor
