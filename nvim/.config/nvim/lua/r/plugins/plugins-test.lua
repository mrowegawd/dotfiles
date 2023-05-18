-------------------------------------------------------------------------------
-- NOTE: disini hanya lah tempat testing plugin2s nvim, nothing more
-------------------------------------------------------------------------------
return {
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
}
