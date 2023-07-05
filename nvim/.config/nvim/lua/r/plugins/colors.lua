return {
    -- NVIM-COLORIZER (disabled)
    {
        "NvChad/nvim-colorizer.lua",
        enabled = false,
        opts = {},
        -- init = function()
        --     require("legendary").keymaps {
        --         {
        --             itemgroup = "Color",
        --             commands = {
        --                 {
        --                     ":ColorizerToggle",
        --                     description = "Colorizer: toggle",
        --                 },
        --             },
        --         },
        --     }
        -- end,
        cmd = {
            "ColorizerToggle",
            "ColorizerAttachToBuffer",
            "ColorizerDetachFromBuffer",
            "ColorizerReloadAllBuffers",
        },
    },
    -- CCC
    {
        "uga-rosa/ccc.nvim",
        -- init = function()
        --     require("legendary").keymaps {
        --         {
        --             itemgroup = "Color",
        --             icon = as.ui.icons.misc.squirrel,
        --             description = "Hello there...",
        --             commands = {
        --             },
        --         },
        --     }
        -- end,
        -- keys = {
        --     {
        --         ":CccPick",
        --         desc = "Ccc: pick color",
        --     },
        --     {
        --         ":CccConvert",
        --         desc = "Ccc: pick color",
        --     },
        --     {
        --         ":CccHighlighterToggle",
        --         desc = "Ccc: toggle",
        --     },
        -- },
        opts = function()
            local ccc = require "ccc"
            local p = ccc.picker
            p.hex.pattern = {
                [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)>]=],
                [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)(\x\x)>]=],
            }
            ccc.setup {
                win_opts = { border = as.ui.border.line },
                pickers = {
                    p.hex,
                    p.css_rgb,
                    p.css_hsl,
                    p.css_hwb,
                    p.css_lab,
                    p.css_lch,
                    p.css_oklab,
                    p.css_oklch,
                },
                highlighter = {
                    auto_enable = true,
                    excludes = {
                        "dart",
                        "lazy",
                        "orgagenda",
                        "org",
                        "NeogitStatus",
                        "toggleterm",
                    },
                },
            }
        end,
        cmd = {
            "CccPick",
            "CccConvert",
            "CccHighlighterToggle",
        },
    },
}
