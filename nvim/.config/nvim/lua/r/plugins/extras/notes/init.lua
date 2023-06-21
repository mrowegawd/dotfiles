return {
    -- HEADLINES (disabled)
    {
        "lukas-reineke/headlines.nvim",
        config = true,
        enabled = false,

        ft = { "markdown", "org", "norg" },
    },

    -- CALENDAR
    {
        "itchyny/calendar.vim",
        cmd = { "Calendar" },
        -- init = function()
        -- vim.g.calendar_google_calendar = 1
        -- vim.g.calendar_google_task = 1
        -- end,
    },
}
