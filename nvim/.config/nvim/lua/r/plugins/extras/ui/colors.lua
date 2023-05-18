return {
    {
        "NvChad/nvim-colorizer.lua",
        opts = {},
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    commands = {
                        {
                            ":ColorizerToggle",
                            description = "Colorizer: toggle",
                        },
                    },
                },
            }
        end,
        cmd = {
            "ColorizerToggle",
            "ColorizerAttachToBuffer",
            "ColorizerDetachFromBuffer",
            "ColorizerReloadAllBuffers",
        },
    },
    {
        "uga-rosa/ccc.nvim",
        opts = {},
        cmd = {
            "CccPick",
            "CccConvert",
            "CccHighlighterEnable",
            "CccHighlighterDisable",
            "CccHighlighterToggle",
        },
    },
}
