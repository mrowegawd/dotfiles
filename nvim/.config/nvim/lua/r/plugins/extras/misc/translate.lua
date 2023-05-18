return {
    -- TRANSLATE.NVIM
    {
        "uga-rosa/translate.nvim",
        cmd = { "Translate" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {
                            "<Leader>tra",
                            "y<ESC>:Translate id<CR>",
                            description = "Translate: translate it [visual]",
                            mode = { "v" },
                        },
                    },
                },
            }
        end,
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
