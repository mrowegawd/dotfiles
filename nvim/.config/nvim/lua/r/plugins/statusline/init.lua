return {
    -- LUALINE
    {
        "nvim-lualine/lualine.nvim",
        event = "BufRead",
        config = function()
            if vim.g.started_by_firenvim then
                return
            end

            local config = {
                options = {
                    theme = require "r.plugins.statusline.themes",
                    -- or use 'auto'
                    -- normal = { c = { fg = col_fg, bg = col_bg } },
                    -- inactive = { c = { fg = col_fg, bg = col_bg } },

                    -- component_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },
                    -- section_separators = { left = "" },
                    component_separators = { left = "", right = "" }, -- "" "" "" ""
                    icons_enabled = true,
                    globalstatus = false,
                    disabled_filetypes = {
                        statusline = { "alpha", "lazy" },
                        winbar = {
                            "help",
                            "alpha",
                            "lazy",
                        },
                    },
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = {},
                    -- lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                -- winbar = {
                --   lualine_a = {},
                --   lualine_b = {},
                --   lualine_c = { "filename" },
                --   lualine_x = {},
                --   lualine_y = {},
                --   lualine_z = {},
                -- },
                --
                -- inactive_winbar = {
                --   lualine_a = {},
                --   lualine_b = {},
                --   lualine_c = { "filename" },
                --   lualine_x = {},
                --   lualine_y = {},
                --   lualine_z = {},
                -- },
                extensions = { "nvim-tree", "misc" },
            }

            local components = require "r.plugins.statusline.components"

            -- Inserts a component in lualine_c at left section
            local function ins_left(component)
                table.insert(config.sections.lualine_c, component)
            end

            -- Inserts a component in lualine_x ot right section
            local function ins_right(component)
                table.insert(config.sections.lualine_x, component)
            end

            ins_left(components.mode())
            ins_left(components.branch())
            ins_left(components.filename())
            ins_left(components.file_modified())
            ins_left(components.term_akinsho())
            -- ins_left(components.navic())

            ins_right(components.trailing())
            ins_right(components.diagnostics())
            -- ins_right(components.noice_status())
            ins_right(components.diff())
            ins_right(components.overseer())
            ins_right(components.lazy_updates())
            ins_right(components.get_lsp_client_notify())
            ins_right(components.mixindent())
            ins_right(components.root_dir())
            ins_right(components.treesitter())
            ins_right(components.filetype())
            ins_right(components.sessions())
            ins_right(components.location_mod())
            ins_right(components.clock())

            require("lualine").setup(config)
        end,
    },
}
