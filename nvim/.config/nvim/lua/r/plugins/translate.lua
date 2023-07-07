return {
    -- TRANSLATE.NVIM
    {
        "uga-rosa/translate.nvim",
        cmd = { "Translate" },
        keys = {
            {
                "<Leader>ua",
                "y<ESC>:Translate id<CR>",
                desc = "Translate: toggle translate it (visual)",
                mode = { "v" },
            },
        },
        config = function()
            require("translate").setup {
                preset = {
                    output = {
                        split = {
                            append = true,
                        },
                    },
                },
            }
        end,
    },
}
