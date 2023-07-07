local highlight = as.highlight
local border, icons, api, fn =
    as.ui.border.rectangle, as.ui.icons, vim.api, vim.fn

local ufo_config_handler = require("r.utils").ufo_handler

return {
    -- INDENTBLANK
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "UIEnter",

        init = function()
            highlight.plugin("indentline", {
                {
                    IndentBlanklineContextChar = {
                        fg = { from = "Directory", alter = -0.5 },
                    },
                },
                {
                    IndentBlanklineContextStart = {
                        sp = { from = "Directory", attr = "fg", alter = -0.5 },
                    },
                },
            })
        end,
        opts = {
            char = "│", -- ┆ ┊ 
            use_treesitter_scope = false,
            show_trailing_blankline_indent = false,
            show_foldtext = false,
            context_char = "▎", -- "▎",
            char_priority = 12,
            show_current_context = true,
            show_current_context_start = false,
            show_current_context_start_on_current_line = false,
            show_first_indent_level = true,
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "",
                "DiffviewFileHistory",
                "DiffviewFiles",
                "NvimTree",
                "TelescopePrompt",
                "TelescopeResults",
                "Trouble",
                "aerial",
                "alpha",
                "dashboard",
                "help",
                "lazy",
                "lspinfo",
                "mason",
                "neo-tree",
                "neogitstatus",
                "neorg",
                "norg",
                "org",
                "packer",
                "qf",
                "sagahover",
                "sagasignature",
                "startify",
                "terminal",
            },
            -- context_patterns = {
            --     "class",
            --     "return",
            --     "function",
            --     "method",
            --     "^if",
            --     "^while",
            --     "jsx_element",
            --     "^for",
            --     "^object",
            --     "^table",
            --     "block",
            --     "arguments",
            --     "if_statement",
            --     "else_clause",
            --     "jsx_element",
            --     "jsx_self_closing_element",
            --     "try_statement",
            --     "catch_clause",
            --     "import_statement",
            --     "operation_type",
            -- },
        },
    },
    -- DRESSING
    {
        "stevearc/dressing.nvim",
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.select(...)
            end
        end,
        opts = {
            input = { enabled = false },
            select = {
                backend = { "fzf_lua", "builtin" },
                builtin = {
                    border = border,
                    min_height = 10,
                    win_options = { winblend = 10 },
                    mappings = { n = { ["q"] = "Close" } },
                },
                get_config = function(opts)
                    opts.prompt = opts.prompt and opts.prompt:gsub(":", "")
                    if opts.kind == "codeaction" then
                        return {
                            backend = "fzf_lua",
                            fzf_lua = as.fzf.cursor_dropdown {
                                winopts = { title = opts.prompt },
                            },
                        }
                    end
                    if opts.kind == "orgmode" then
                        return {
                            backend = "nui",
                            nui = {
                                position = "97%",
                                -- border = { style = border.rectangle },
                                min_width = vim.o.columns - 2,
                            },
                        }
                    end
                    return {
                        backend = "fzf_lua",
                        fzf_lua = as.fzf.dropdown {
                            winopts = {
                                title = opts.prompt,
                                height = 0.33,
                                row = 0.5,
                            },
                        },
                    }
                end,
                nui = {
                    min_height = 10,
                    win_options = {
                        winhighlight = table.concat({
                            "Normal:Italic",
                            "FloatBorder:PickerBorder",
                            "FloatTitle:Title",
                            "CursorLine:Visual",
                        }, ","),
                    },
                },
            },
        },
    },
    -- NVIM-NOTIFY
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            local notify = require "notify"

            highlight.plugin("notify", {
                { NotifyERRORBorder = { bg = { from = "Pmenu" } } },
                { NotifyWARNBorder = { bg = { from = "Pmenu" } } },
                { NotifyINFOBorder = { bg = { from = "Pmenu" } } },
                { NotifyDEBUGBorder = { bg = { from = "Pmenu" } } },
                { NotifyTRACEBorder = { bg = { from = "Pmenu" } } },
                { NotifyERRORBody = { link = "Pmenu" } },
                { NotifyWARNBody = { link = "Pmenu" } },
                { NotifyINFOBody = { link = "Pmenu" } },
                { NotifyDEBUGBody = { link = "Pmenu" } },
                { NotifyTRACEBody = { link = "Pmenu" } },
            })

            notify.setup {
                timeout = 5000,
                stages = "fade_in_slide_out",
                -- top_down = false,
                background_colour = "NormalFloat",
                max_width = function()
                    return math.floor(vim.o.columns * 0.6)
                end,
                max_height = function()
                    return math.floor(vim.o.lines * 0.8)
                end,
                on_open = function(win)
                    if not api.nvim_win_is_valid(win) then
                        return
                    end
                    api.nvim_win_set_config(win, { border = border })
                end,
            }
        end,
    },
    -- NOICE
    {
        -- :nmap output is having wrong linebreaks
        -- https://github.com/folke/noice.nvim/issues/259
        "folke/noice.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<s-enter>",
                function()
                    return require("noice").redirect(vim.fn.getcmdline())
                end,
                mode = "c",
                desc = "Noice: redirect cmdline",
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("noice").setup {

                -- debug = false,
                popupmenu = {
                    -- cmp-cmdline has more sources and can be extended
                    backend = "cmp", -- backend to use to show regular cmdline completions
                },
                -- lsp = {
                --     -- can not filter null-ls's data
                --     -- j-hui/fidget.nvim
                --     progress = {
                --         enabled = false,
                --     },
                -- },
                -- messages = {
                --     -- Using kevinhwang91/nvim-hlslens because virtualtext is hard to read
                --     view_search = false,
                -- },

                -- notify = { enabled = true },
                -- cmdline = { enabled = true }
                -- messages = { enabled = false },
                lsp = {
                    progress = {
                        enabled = false,
                        -- view = "mini",
                    },
                    documentation = {
                        opts = {
                            border = { style = "rounded" },
                            position = { row = 2 },
                        },
                    },
                    signature = {
                        auto_open = { enabled = false },
                    },
                    hover = { enabled = true },
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },

                views = {
                    cmdline_popup = {
                        position = {
                            row = -5,
                            col = "50%",

                            -- row = vim.o.lines - 3, -- posisi sama dengan yang cmd lama
                            -- col = 0,
                        },
                        size = {
                            width = "auto",
                            height = "auto",
                        },
                    },
                },

                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = false, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = true, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
                -- `Route` gunanya untuk memfilter noitifikasi yang ga terlalu
                -- berguna di noice
                -- https://github.com/folke/noice.nvim#-routes
                routes = {
                    {
                        opts = { skip = true },
                        filter = {
                            any = {
                                { event = "msg_show", kind = "search_count" },
                                { event = "msg_show", find = "written" },
                                { event = "notify", find = "SUCCESS" },
                                {
                                    event = "msg_show",
                                    find = "%d+ lines, %d+ bytes",
                                },
                                { event = "msg_show", find = "%d+L, %d+B" },
                                {
                                    event = "msg_show",
                                    find = "^Hunk %d+ of %d",
                                },
                                { event = "msg_show", find = "%d+ change" },
                                { event = "msg_show", find = "%d+ more line" },
                                {
                                    event = "notify",
                                    find = "No information available",
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
    -- STATUSCOL
    {
        "luukvbaal/statuscol.nvim",
        event = "BufReadPre",
        opts = function()
            local builtin = require "statuscol.builtin"

            return {
                -- hl = "FoldColumn", -- %# highlight group label, applies to each text element
                relculright = true,
                segments = {
                    -- {
                    --     text = { builtin.foldfunc },
                    --     click = "v:lua.ScFa",
                    -- },
                    {
                        text = { "%s" },
                        -- hl = "FoldColumn", -- %# highlight group label
                        click = "v:lua.ScSa",
                    },
                    {
                        text = { builtin.lnumfunc, " " },
                        -- hl = "FoldColumn",
                        -- hl = "Pmenu",
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScLa",
                    },
                    {
                        text = { " ", builtin.foldfunc, " " },
                        -- hl = "FoldColumn",
                        click = "v:lua.ScFa",
                    },
                },
                clickhandlers = {
                    Lnum = builtin.lnum_click,
                    FoldClose = builtin.foldclose_click,
                    FoldOpen = builtin.foldopen_click,
                    FoldOther = builtin.foldother_click,
                    DapBreakpointRejected = builtin.toggle_breakpoint,
                    DapBreakpoint = builtin.toggle_breakpoint,
                    DapBreakpointCondition = builtin.toggle_breakpoint,
                    DiagnosticSignError = builtin.diagnostic_click,
                    DiagnosticSignHint = builtin.diagnostic_click,
                    DiagnosticSignInfo = builtin.diagnostic_click,
                    DiagnosticSignWarn = builtin.diagnostic_click,
                    GitSignsTopdelete = builtin.gitsigns_click,
                    GitSignsUntracked = builtin.gitsigns_click,
                    GitSignsAdd = builtin.gitsigns_click,
                    GitSignsChangedelete = builtin.gitsigns_click,
                    GitSignsDelete = builtin.gitsigns_click,
                },
            }
        end,
    },
    -- FOLD CYCLE
    {
        "jghauser/fold-cycle.nvim",
        opts = {},
        keys = {
            {
                "<space><space>",
                function()
                    require("fold-cycle").open()
                end,
                desc = "Fold(fold-cycle): toggle",
            },
        },
    },
    -- NVIM-UVO
    {
        -- NOTE ufo ini selalu jalan ketika buka ft apapun, seharusnya bisa di
        -- disable. Contoh ketika open AerialToggle, map zM harusnya milik Aerial bukan Ufo.
        -- Solusi lain mungkin dari issue ini:
        -- https://github.com/kevinhwang91/nvim-ufo/issues/33#issuecomment-1478102255
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        keys = {
            {
                "zM",
                function()
                    -- Unwanted autofolding triggered by insert
                    -- return require("ufo").closeAllFolds()

                    -- Taken from https://github.com/kevinhwang91/nvim-ufo/issues/85
                    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

                    vim.cmd "normal gg"

                    for i = 1, vim.api.nvim_buf_line_count(0) do
                        vim.cmd("silent! normal " .. tostring(i) .. "GzC")
                    end
                    vim.cmd("normal " .. tostring(row) .. "G")
                end,
                desc = "Fold(ufo): close all folds",
            },

            {
                "zm",
                function()
                    return require("ufo").closeFoldsWith()
                end,
                desc = "Fold(ufo): close fold",
            },

            {
                "zR",
                function()
                    return require("ufo").openAllFolds()
                end,
                desc = "Fold(ufo): open all folds",
            },

            {
                "zP",
                function()
                    return require("ufo").peekFoldedLinesUnderCursor()
                end,
                desc = "Fold(ufo): open peek folds",
            },

            {
                -- "zp",
                "<UP>",
                function()
                    return require("ufo").goPreviousClosedFold()
                end,
                desc = "Fold(ufo): go prev closed fold",
            },
            {
                -- "zn",
                "<DOWN>",
                function()
                    return require("ufo").goNextClosedFold()
                end,
                desc = "Fold(ufo): go next closed fold",
            },
        },

        init = function()
            as.augroup("UfoSettings", {
                event = "FileType",
                pattern = {
                    "org",
                    "alpha",
                    "norg",
                    "aerial",
                    "Outline",
                    "neo-tree",
                    "DiffviewFileHistory",
                },
                command = function()
                    local ufo = require "ufo"
                    ufo.detach()
                end,
            })

            highlight.plugin("UfoNcolor", {
                {
                    Folded = {
                        bg = "NONE",
                    },
                },
            })

            --     commands = {
            --         {
            --             ":UfoInspect",
            --             description = "Ufo: inspect",
            --         },
            --     },
            -- },
            -- }
        end,

        config = function()
            vim.o.foldlevel = 99 -- feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.foldcolumn = "1"

            local ufo = require "ufo"

            ufo.setup {
                open_fold_hl_timeout = 0,
                fold_virt_text_handler = ufo_config_handler,
                close_fold_kinds = { "imports", "comment" },
                enable_get_fold_virt_text = true,
                ---@diagnostic disable-next-line: unused-local
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
                preview = {
                    win_config = {
                        winhighlight = "Normal:Normal,FloatBorder:Normal",
                    },
                },
            }
        end,
    },
    -- BUFFERLINE
    {
        "akinsho/nvim-bufferline.lua",
        event = "VeryLazy",
        keys = {
            {
                "gl",
                "<CMD>BufferLineCycleNext<CR>",
                desc = "Buffer(Bufferline): next buffer",
            },
            {
                "gh",
                "<CMD>BufferLineCyclePrev<CR>",
                desc = "Buffer(Bufferline): prev buffer",
            },

            {
                "<leader><BS>",
                "<CMD>BufferLineGroupToggle docs<CR>",
                desc = "Buffer(Bufferline): group close docs",
            },
        },
        config = function()
            local col_base_bg_attr = "Normal"
            local col_base_fg_attr = "Normal"

            local col_unselected_bg_attr = "bufferline_unselected"
            local col_unselected_fg_attr = "Normal"

            local col_selected_fg_attr = "Boolean"
            local col_selected_bg_attr = "bufferline_unselected"

            local bufferline = require "bufferline"
            bufferline.setup {
                options = {
                    -- mode = "tabs",
                    modified_icon = "●",
                    show_buffer_close_icon = false,
                    buffer_close_icon = "",
                    -- sort_by = "insert_after_current",
                    show_close_icon = true,
                    diagnostics = "nvim_lsp",
                    diagnostics_update_in_insert = false,
                    hover = { enabled = true, reveal = { "close" } },
                    separator_style = "thick",
                    diagnostics_indicator = function(count, level)
                        level = level:match "warn" and "warn" or level
                        return (icons.diagnostics[level] or "?") .. count
                    end,
                    offsets = {
                        {
                            text = "EXPLORER",
                            filetype = "NvimTree",
                            highlight = "Directory",
                            -- text_align = "left",
                        },

                        {
                            text = " DIFF VIEW",
                            filetype = "DiffviewFiles",
                            highlight = "PanelHeading",
                            separator = true,
                        },

                        {
                            text = " DATABASE VIEWER",
                            filetype = "dbui",
                            highlight = "PanelHeading",
                            separator = true,
                        },

                        {
                            text = "NEOTREE",
                            filetype = "neo-tree",
                            highlight = "Directory",
                            -- text_align = "left",
                        },
                        {
                            filetype = "UNDOTREE",
                            text = "Undotree",
                            highlight = "PanelHeading",
                            text_align = "left",
                        },
                    },
                    groups = {
                        options = { toggle_hidden_on_enter = true },
                        items = {
                            bufferline.groups.builtin.pinned:with {
                                icon = "",
                            },
                            bufferline.groups.builtin.ungrouped,
                            {
                                name = "Dependencies",
                                icon = "",
                                highlight = { fg = "#ECBE7B" },
                                matcher = function(buf)
                                    return vim.startswith(
                                        buf.path,
                                        vim.env.VIMRUNTIME
                                    )
                                end,
                            },
                            {
                                name = "Terraform",
                                matcher = function(buf)
                                    return buf.name:match "%.tf" ~= nil
                                end,
                            },
                            {
                                name = "Kubernetes",
                                matcher = function(buf)
                                    return buf.name:match "kubernetes"
                                        and buf.name:match "%.yaml"
                                end,
                            },
                            {
                                name = "SQL",
                                matcher = function(buf)
                                    return buf.name:match "%.sql$"
                                end,
                            },
                            {
                                name = "tests",
                                icon = "",
                                matcher = function(buf)
                                    local name = buf.name
                                    return name:match "[_%.]spec"
                                        or name:match "[_%.]test"
                                end,
                            },
                            {
                                name = "docs",
                                icon = "",
                                matcher = function(buf)
                                    if
                                        vim.bo[buf.id].filetype == "man"
                                        or buf.path:match "man://"
                                    then
                                        return true
                                    end
                                    for _, ext in ipairs {
                                        "md",
                                        "txt",
                                        "org",
                                        "norg",
                                        "wiki",
                                    } do
                                        if
                                            ext
                                            == fn.fnamemodify(buf.path, ":e")
                                        then
                                            return true
                                        end
                                    end
                                end,
                            },
                        },
                    },
                },

                highlights = {
                    fill = {
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },

                        fg = {
                            attribute = "bg",
                            highlight = col_base_fg_attr,
                        },
                    },
                    background = {
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },

                    -- TAB ----------------------------------------------------
                    tab = {
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },
                    tab_close = {
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },
                    -- tab_visible = {
                    --     fg = {
                    --         attribute = "fg",
                    --         highlight = col_unselected_fg_attr,
                    --     },
                    --     bg = {
                    --         attribute = "bg",
                    --         highlight = col_unselected_bg_attr,
                    --     },
                    -- },
                    tab_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        italic = false,
                    },

                    -- INDICATOR ----------------------------------------------
                    indicator_visible = {
                        fg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },
                    indicator_selected = {
                        fg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },
                    -- SEPARATOR ----------------------------------------------
                    separator = {
                        fg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                    },
                    separator_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    separator_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -- CLOSE --------------------------------------------------
                    close_button = {
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    close_button_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    close_button_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -- BUFFER -------------------------------------------------
                    buffer = {
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    buffer_visible = {
                        italic = true,
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    buffer_selected = {
                        italic = false,

                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -- PICK ---------------------------------------------------
                    pick = {
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                        italic = false,
                    },
                    pick_selected = {
                        italic = false,
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    pick_visible = {
                        italic = false,
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -- MODIFIED -----------------------------------------------
                    modified = {
                        fg = {
                            attribute = "fg",
                            highlight = "ErrorMsg",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                    },
                    modified_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = "ErrorMsg",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    modified_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = "ErrorMsg",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -- DUPLICATE ----------------------------------------------
                    duplicate = {
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                        italic = false,
                    },
                    duplicate_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = false,
                    },
                    duplicate_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -- OFFSET -------------------------------------------------
                    offset_separator = {
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },

                        fg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                    },

                    -----------------------------------------------------------
                    -- DIAGNOSTICS
                    -----------------------------------------------------------
                    -- diagnostic = {
                    --     bg = {
                    --         attribute = "fg",
                    --         highlight = "Boolean",
                    --     },
                    -- },
                    diagnostic_visible = {
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    -- diagnostic_selected = {
                    --     bg = {
                    --         attribute = "fg",
                    --         highlight = "Boolean",
                    --     },
                    -- },

                    -- WARNING ------------------------------------------------
                    warning = {
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                    },
                    warning_visible = {
                        italic = true,
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                    },
                    warning_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        italic = false,
                    },
                    warning_diagnostic = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticWarn",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },
                    warning_diagnostic_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticWarn",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    warning_diagnostic_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticWarn",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        italic = false,
                    },

                    -- ERROR --------------------------------------------------
                    error = {
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                    },
                    error_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    error_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },

                        italic = false,
                    },
                    error_diagnostic = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticError",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },
                    error_diagnostic_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticError",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    error_diagnostic_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticError",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        italic = false,
                    },

                    -- HINT ---------------------------------------------------
                    hint = {
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                    },
                    hint_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    hint_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },

                        italic = false,
                    },
                    hint_diagnostic = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticHint",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },
                    hint_diagnostic_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticHint",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    hint_diagnostic_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticHint",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        italic = false,
                    },

                    -- INFO ---------------------------------------------------
                    info = {
                        bg = {
                            attribute = "bg",
                            highlight = "Normal",
                        },
                    },
                    info_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = col_unselected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    info_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = col_selected_fg_attr,
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },

                        italic = false,
                    },
                    info_diagnostic = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticInfo",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_base_bg_attr,
                        },
                    },
                    info_diagnostic_visible = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticInfo",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_unselected_bg_attr,
                        },
                        italic = true,
                    },
                    info_diagnostic_selected = {
                        fg = {
                            attribute = "fg",
                            highlight = "DiagnosticInfo",
                        },
                        bg = {
                            attribute = "bg",
                            highlight = col_selected_bg_attr,
                        },
                        italic = false,
                    },
                },
            }
        end,
    },
    -- SATELLITE (disabled)
    {
        "lewis6991/satellite.nvim",
        event = "VeryLazy",
        enabled = false,
        opts = {
            current_only = true,
            excluded_filetypes = {
                "help",
                "alpha",
                "undotree",
                "neo-tree",
                "gitcommit",
                "gitrebase",
            },
        },
    },
    -- NVIM-SCROLLBAR (disabled)
    {
        "petertriho/nvim-scrollbar",
        event = "BufRead",
        enabled = false,
        config = function()
            local scrollbar = require "scrollbar"

            -- PERF: throttle scrollbar refresh
            -- Disable, throttle, since it was caused by comment TS
            -- local render = scrollbar.render
            -- scrollbar.render = require("util").throttle(300, render)

            local linenr_bg = highlight.get("LineNr", "fg")
            -- local bg = h.alter_color(linenr_bg, 13)

            scrollbar.setup {
                handle = {
                    color = linenr_bg,
                },
                excluded_filetypes = {
                    "prompt",
                    "TelescopePrompt",
                    "noice",
                    "lazy",
                    "notify",
                },
                -- marks = {
                --     -- Search = { color = colors.orange },
                --     Error = { color = O.default.palette.error },
                --     Warn = { color = O.default.palette.warn },
                --     Info = { color = O.default.palette.info },
                --     Hint = { color = O.default.palette.hint },
                --     Misc = { color = O.default.palette.misc },
                -- },
            }
        end,
    },
    -- NEOSCROLL
    {
        "karb94/neoscroll.nvim",
        event = "BufReadPre",
        config = function()
            require("neoscroll").setup {
                mappings = {
                    "<C-u>",
                    "<C-d>",
                    "<C-y>",
                    "<C-e>",
                    "zt",
                    "zz",
                    "zb",
                },
                stop_eof = true, -- Stop at <EOF> when scrolling downwards
                -- performance_mode = true,
                use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
                respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                easing_function = nil, -- Default easing function
                pre_hook = function()
                    vim.opt.eventignore:append {
                        "WinScrolled",
                        "CursorMoved",
                    }
                end,
                post_hook = function()
                    vim.opt.eventignore:remove {
                        "WinScrolled",
                        "CursorMoved",
                    }
                end,
            }

            local map = {}

            map["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
            map["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
            -- map["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
            -- map["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }
            map["<C-y>"] = { "scroll", { "-0.10", "false", "80" } }
            map["<C-e>"] = { "scroll", { "0.10", "false", "80" } }
            map["zt"] = { "zt", { "150" } }
            map["zz"] = { "zz", { "150" } }
            map["zb"] = { "zb", { "150" } }

            require("neoscroll.config").set_mappings(map)
        end,
    },
    -- BLOCK NVIM
    {
        "HampusHauffman/block.nvim",
        cmd = { "BlockOn", "BlockOff", "Block" },
        config = function()
            require("block").setup {}
        end,
    },
    -- SHADE (disabled)
    {
        "sunjon/shade.nvim",
        enabled = false,
        config = function()
            require("shade").setup()
            require("shade").toggle()
        end,
    },
    -- EDGY.NVIM (disabled)
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        enabled = false,
        keys = {
            {
                "<leader>ue",
                function()
                    require("edgy").toggle()
                end,
                desc = "Edgy Toggle",
            },
            {
                "<leader>uE",
                function()
                    require("edgy").select()
                end,
                desc = "Edgy Select Window",
            },
        },
        opts = function()
            local opts = {
                bottom = {
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative
                                == ""
                        end,
                    },
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative
                                == ""
                        end,
                    },
                    {
                        ft = "lazyterm",
                        title = "LazyTerm",
                        size = { height = 0.4 },
                        filter = function(buf)
                            return not vim.b[buf].lazyterm_cmd
                        end,
                    },
                    "Trouble",
                    { ft = "qf", title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- don't open help files in edgy that we're editing
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    -- { ft = "spectre_panel", size = { height = 0.4 } },
                    {
                        title = "Neotest Output",
                        ft = "neotest-output-panel",
                        size = { height = 15 },
                    },
                },
                left = {
                    {
                        title = "Neo-Tree",
                        ft = "neo-tree",
                        filter = function(buf)
                            return vim.b[buf].neo_tree_source == "filesystem"
                        end,
                        pinned = true,
                        open = function()
                            vim.api.nvim_input "<esc><space>e"
                        end,
                        size = { height = 0.5 },
                    },
                    { title = "Neotest Summary", ft = "neotest-summary" },
                    -- {
                    --     title = "Neo-Tree Git",
                    --     ft = "neo-tree",
                    --     filter = function(buf)
                    --         return vim.b[buf].neo_tree_source == "git_status"
                    --     end,
                    --     pinned = true,
                    --     open = "Neotree position=right git_status",
                    -- },
                    -- {
                    --     title = "Neo-Tree Buffers",
                    --     ft = "neo-tree",
                    --     filter = function(buf)
                    --         return vim.b[buf].neo_tree_source == "buffers"
                    --     end,
                    --     pinned = true,
                    --     open = "Neotree position=top buffers",
                    -- },
                    -- "neo-tree",
                },
                keys = {
                    -- increase width
                    ["<a-L>"] = function(win)
                        win:resize("width", 2)
                    end,
                    -- decrease width
                    ["<a-H>"] = function(win)
                        win:resize("width", -2)
                    end,
                    -- increase height
                    ["<a-K>"] = function(win)
                        win:resize("height", 2)
                    end,
                    -- decrease height
                    ["<a-J"] = function(win)
                        win:resize("height", -2)
                    end,
                },
            }
            if as.has "symbols-outline.nvim" then
                table.insert(opts.left, {
                    title = "Outline",
                    ft = "Outline",
                    pinned = true,
                    open = "SymbolsOutline",
                })
            end
            return opts
        end,
    },
}
