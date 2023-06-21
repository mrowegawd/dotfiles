-------------------------------------------------------------------------------
-- NOTE: disini hanya lah tempat testing plugin2s nvim, nothing more
-------------------------------------------------------------------------------
return {
    -- { "TheDreadedAndy/colorschemes.nvim", lazy = false },
    -- { "jan-warchol/selenized", lazy = false },

    {

        "rmagatti/auto-session",
        cmd = { "SaveSession", "RestoreSession" },
        enabled = false,
        -- dependencies = { "rmagatti/session-lens" },
        config = function()
            local opts = {
                log_level = "error",
                auto_session_enable_last_session = false,
                auto_session_root_dir = vim.fn.expand "~/.vim/session/",
                auto_session_enabled = true,
                auto_session_create_enabled = false,
                auto_save_enabled = true,
                auto_restore_enabled = true,
                auto_session_suppress_dirs = nil,
                auto_session_allowed_dirs = nil,
            }

            require("auto-session").setup(opts)
        end,
    },
    {

        "tummetott/unimpaired.nvim",
        enabled = false,
        config = function()
            require("unimpaired").setup {}
        end,
    },

    -- BIONIC
    {
        "HampusHauffman/bionic.nvim", -- A tiny plugin to help people read code faster.
        enabled = false,
        event = "BufRead",
    },

    {
        "kwkarlwang/bufjump.nvim",
        enabled = false,
        event = "BufRead",
        config = function()
            require("bufjump").setup()
        end,
    },
    -- {
    --     "myitcv/vim-common-jumplist",
    --     event = "BufRead",
    -- },
    -- {
    --     "kwkarlwang/bufjump.nvim",
    --     event = "BufRead",
    --     config = function()
    --         require("bufjump").setup {
    --             forward = "<C-i>",
    --             backward = "<C-o>",
    --             -- on_success = function()
    --             --     cmd [[execute "normal! g`\"zz"]]
    --             -- end,
    --         }
    --     end,
    -- },
}
