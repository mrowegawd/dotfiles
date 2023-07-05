return {
    -- LUALINE
    {
        "nvim-lualine/lualine.nvim",
        event = "BufRead",
        enabled = true,
        config = function()
            if vim.g.started_by_firenvim then
                return
            end

            local config = {
                options = {
                    theme = require "r.plugins.colorthemes.lualine.themes",
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
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = {},
                    -- lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = { "nvim-tree", "misc", "dap-neotest" },
            }

            local components =
                require "r.plugins.colorthemes.lualine.components"

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

            ins_right(components.python_env())
            ins_right(components.noice_status())
            ins_right(components.trailing())
            ins_right(components.mixindent())
            ins_right(components.diagnostics())
            ins_right(components.diff())
            ins_right(components.lazy_updates())
            ins_right(components.overseer())
            ins_right(components.check_loaded_buf())
            ins_right(components.get_lsp_client_notify())

            ins_right(components.sessions())
            ins_right(components.root_dir())
            ins_right(components.filetype())
            ins_right(components.location_mod())
            ins_right(components.clock())

            require("lualine").setup(config)
        end,
    },
    {
        "rebelot/heirline.nvim",
        event = "UIEnter",
        -- event = "VeryLazy",
        enabled = false,
        priority = 500,
        config = function()
            -- Filetypes where certain elements of the statusline will not be shown
            local filetypes = {
                "^git.*",
                "fugitive",
                "alpha",
                "^neo--tree$",
                "^neotest--summary$",
                "^neo--tree--popup$",
                "^NvimTree$",
                "^toggleterm$",
            }

            -- Buftypes which should cause elements to be hidden
            local buftypes = {
                "nofile",
                "prompt",
                "help",
                "quickfix",
                "norg",
                "org",
            }

            -- Filetypes which force the statusline to be inactive
            local force_inactive_filetypes = {
                "^aerial$",
                "^alpha$",
                "^chatgpt$",
                "^DressingInput$",
                "^frecency$",
                "^lazy$",
                "^netrw$",
                "^oil$",
                "^TelescopePrompt$",
                "^undotree$",
            }

            local align = { provider = "%=" }
            local spacer = { provider = " " }

            local heirline = require "heirline"
            local conditions = require "heirline.conditions"

            -- local winbar =
            --     require(config_namespace .. ".plugins.heirline.winbar")
            -- local bufferline =
            --     require(config_namespace .. ".plugins.heirline.bufferline")
            local statusline =
                require "r.plugins.colorthemes.heirline.statusline"
            local statuscolumn =
                require "r.plugins.colorthemes.heirline.statuscol"

            heirline.setup {
                statusline = {
                    static = {
                        filetypes = filetypes,
                        buftypes = buftypes,
                        force_inactive_filetypes = force_inactive_filetypes,
                    },
                    condition = function(self)
                        return not conditions.buffer_matches {
                            filetype = self.force_inactive_filetypes,
                        }
                    end,
                    statusline.VimMode,
                    statusline.GitBranch,
                    statusline.FileNameBlock,
                    align,
                    statusline.LspDiagnostics,
                    statusline.Lazy,
                    statusline.LspAttached,
                    -- statusline.Overseer,
                    -- statusline.Dap,
                    -- statusline.FileEncoding,
                    -- statusline.Session,
                    -- statusline.MacroRecording,
                    -- statusline.SearchResults,
                    statusline.FileType,
                    statusline.Ruler,
                    -- statusline.Clock,
                },
                statuscolumn = {
                    condition = function()
                        -- TODO: Update this when 0.9 is released
                        return not conditions.buffer_matches {
                            buftype = buftypes,
                            filetype = force_inactive_filetypes,
                        }
                    end,
                    static = statuscolumn.static,
                    init = statuscolumn.init,
                    statuscolumn.signs,
                    align,
                    statuscolumn.line_numbers,
                    spacer,
                    statuscolumn.folds,
                    statuscolumn.git_signs,
                },
            }
        end,
    },
}
