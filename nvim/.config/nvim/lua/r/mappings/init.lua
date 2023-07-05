local cmd, fn = vim.cmd, vim.fn

local M = {}

--  ╭──────────────────────────────────────────────────────────╮
--  │                     Default Commands                     │
--  ╰──────────────────────────────────────────────────────────╯
function M.default_keymaps()
    return {
        --  ════════════════════════════════════════════════════════════
        --  MISC
        --  ════════════════════════════════════════════════════════════
        {
            itemgroup = "Misc",
            icon = as.ui.icons.misc.smiley,
            description = "General functionality",
            keymaps = {

                -- {
                --     ":SudaRead",
                --     description = "Sudovim: read file sudo",
                -- },
                -- {
                --     ":SudaWrite",
                --     description = "Sudovim: write file sudo",
                -- },
                {
                    "<Leader>us",
                    function()
                        local mymodes = {
                            ["norg"] = { "set spell!" },
                        }

                        if mymodes[vim.bo.filetype] then
                            for _, value in ipairs(mymodes[vim.bo.filetype]) do
                                return cmd(value)
                            end
                        else
                            require("r.utils").toggle_vi()
                        end
                    end,
                    description = "Misc: toggle spell",
                },
            },
        },
    }
end
function M.default_commands()
    return {

        --  ════════════════════════════════════════════════════════════
        --  MISC
        --  ════════════════════════════════════════════════════════════
        {
            itemgroup = "Misc",
            commands = {
                --  +----------------------------------------------------------+
                --  Basic
                --  +----------------------------------------------------------+
                {
                    ":InfoBaseColorsTheme",
                    function()
                        return require("r.utils").infoBaseColorsTheme()
                    end,
                    description = "Misc: base color (untuk theme bspwm)",
                },

                {
                    ":InfoOption",
                    function()
                        return require("r.utils").infoFoldPreview()
                    end,
                    description = "Misc: echo options",
                },
                {
                    ":ToggleSemantic",
                    function()
                        require("r.utils").toggle_buffer_semantic_tokens(
                            vim.api.nvim_get_current_buf()
                        )
                    end,
                    description = "Misc: toggle semantics tokens",
                },

                {
                    ":Uuid",
                    function()
                        local uuid = fn.system("uuidgen"):gsub("\n", ""):lower()
                        local line = fn.getline "."
                        return vim.schedule(function()
                            fn.setline(
                                ---@diagnostic disable-next-line: param-type-mismatch
                                ".",
                                fn.strpart(line, 0, fn.col ".")
                                    .. uuid
                                    .. fn.strpart(line, fn.col ".")
                            )
                        end)
                    end,
                    description = "Misc: Generate a UUID and insert it into the buffer",
                },

                --  +----------------------------------------------------------+
                --  Plugins
                --  +----------------------------------------------------------+
                {
                    ":Snippets",
                    function()
                        require("r.utils").EditSnippet()
                    end,
                    description = "Misc: edit Snippets",
                },

                {
                    ":Neogen",
                    description = "Generate annotation",
                },

                {
                    ":CBcatalog",
                    function()
                        return require("comment-box").catalog()
                    end,
                    description = "Comment-box: show catalog",
                },

                {
                    ":ShowPackageInfo",
                    "<cmd>lua require('package-info').show()<cr>",
                    description = "ShowPackageInfo: ShowPackageInfo",
                },
            },
        },

        --  ════════════════════════════════════════════════════════════
        --  PLUGINS
        --  ════════════════════════════════════════════════════════════

        {
            itemgroup = "Copilot",
            commands = {
                {
                    ":CopilotToggle",
                    function()
                        return require("copilot.suggestion").toggle_auto_trigger()
                    end,
                    description = "Toggle on/off for buffer",
                },
            },
        },

        {
            itemgroup = "Git",
            commands = {
                {
                    ":GitBranchList",
                    function()
                        return require("r.utils").ListBranches()
                    end,
                    description = "List the Git branches in this repo",
                },
            },
        },

        {
            itemgroup = "Lazy",
            icon = "",
            description = "Lazy commands",
            commands = {
                {
                    ":Lazy sync",
                    description = "Sync",
                },

                {
                    ":Lazy show",
                    description = "Show",
                },

                {
                    ":Lazy log",
                    description = "Log",
                },

                {
                    ":Lazy profile",
                    description = "Profile",
                },

                {
                    ":Lazy debug",
                    description = "Debug",
                },
            },
        },
    }
end

return M
