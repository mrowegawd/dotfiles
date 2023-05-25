local highlight = as.highlight
local border, icons, api, fn =
    as.ui.border.rectangle, as.ui.icons, vim.api, vim.fn

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

            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    commands = {
                        {
                            ":IndentBlanklineToggle",
                            description = "Indentblankline: toggle",
                        },
                    },
                },
            }
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
        event = "VeryLazy",
        config = function()
            require("dressing").setup {
                backend = { "telescope", "fzf", "builtin" },
            }
        end,
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
        "folke/noice.nvim",
        event = "VeryLazy",
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Noice",
                    commands = {
                        {
                            ":NoiceLast",
                            function()
                                return require("noice").cmd "last"
                            end,
                            description = "Show last message",
                        },

                        {
                            ":NoiceHistory",
                            function()
                                return require("noice").cmd "history"
                            end,
                            description = "Show history message",
                        },
                        {
                            ":NoiceLog",
                            function()
                                return require("noice").cmd "log"
                            end,
                            description = "Show log",
                        },

                        {
                            ":NoiceAll",
                            function()
                                return require("noice").cmd "all"
                            end,
                            description = "Show all message",
                        },
                    },
                    keymaps = {
                        {
                            "<F6>",
                            function()
                                return require("noice").redirect(
                                    vim.fn.getcmdline()
                                )
                            end,
                            description = "Redirect Cmdline",
                        },
                    },
                },
            }
        end,
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
                -- cmdline = { enabled = true },
                -- messages = { enabled = true },
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
        config = function()
            local builtin = require "statuscol.builtin"

            require("statuscol").setup {
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
    -- NVIM-UFO
    {
        -- NOTE ufo ini selalu jalan ketika buka ft apapun, seharusnya bisa di
        -- disable. Contoh ketika open AerialToggle, map zM harusnya milik Aerial bukan Ufo.
        -- Solusi lain mungkin dari issue ini:
        -- https://github.com/kevinhwang91/nvim-ufo/issues/33#issuecomment-1478102255
        "kevinhwang91/nvim-ufo",
        event = "BufRead",
        enabled = false,
        dependencies = {
            "kevinhwang91/promise-async",
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

            require("legendary").keymaps {
                {
                    itemgroup = "Fold",
                    description = "Fold in nvim",
                    icon = as.ui.icons.misc.double_chevron_right,
                    keymaps = {

                        -- {
                        --     "<Localleader>z",
                        --     [[zMzvzz]], --> command ini bikin foldlevel menjadi 0
                        --     description = "Misc: refocus folds",
                        -- },
                        --
                        -- {
                        --     "zY",
                        --     [[zCzO]],
                        --     description = "Misc: open folds whatever top fold we're in",
                        -- },
                        --
                        -- {
                        --     "<BS>",
                        --     [[@=(foldlevel('.')?'za':"\<Space>")<CR>]],
                        --     description = "Misc: toggle fold under cursor",
                        -- },

                        -- UFO --------------------------------------------------------
                        {
                            "zM",
                            function()
                                -- Unwanted autofolding triggered by insert
                                -- return require("ufo").closeAllFolds()

                                -- Taken from https://github.com/kevinhwang91/nvim-ufo/issues/85
                                local row, _ =
                                    unpack(vim.api.nvim_win_get_cursor(0))

                                vim.cmd "normal gg"

                                for i = 1, vim.api.nvim_buf_line_count(0) do
                                    vim.cmd(
                                        "silent! normal "
                                            .. tostring(i)
                                            .. "GzC"
                                    )
                                end
                                vim.cmd("normal " .. tostring(row) .. "G")
                            end,
                            description = "Ufo: close all folds",
                        },

                        {
                            "zm",
                            function()
                                return require("ufo").closeFoldsWith()
                            end,
                            description = "Ufo: close fold",
                        },

                        {
                            "zR",
                            function()
                                return require("ufo").openAllFolds()
                            end,
                            description = "Ufo: open all folds",
                        },
                        --
                        -- {
                        --     "zr",
                        --     function()
                        --         return require("ufo").openFoldsExceptKinds()
                        --     end,
                        --     description = "Ufo: Open folds except kinds",
                        -- },

                        {
                            "zP",
                            function()
                                return require("ufo").peekFoldedLinesUnderCursor()
                            end,
                            description = "Ufo: open peek folds",
                        },

                        {
                            "zp",
                            function()
                                return require("ufo").goPreviousClosedFold()
                            end,
                            description = "Ufo: go prev closed fold",
                        },
                        {
                            "zn",
                            function()
                                return require("ufo").goNextClosedFold()
                            end,
                            description = "Ufo: go next closed fold",
                        },

                        -- FOLDCYCLE --------------------------------------------------
                        -- {
                        --     "<Localleader>z",
                        --     function()
                        --         return require("fold-cycle").open()
                        --     end,
                        --
                        --     description = "Foldcyle: toggle",
                        --     mode = { "n", "v" },
                        -- },
                    },
                    commands = {
                        {
                            ":UfoInspect",
                            description = "Ufo: inspect",
                        },
                    },
                },
            }
        end,

        config = function()
            vim.o.foldlevel = 99 -- feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.foldcolumn = "1"

            local function handler(
                virt_text,
                lnum,
                end_lnum,
                width,
                truncate,
                ctx
            )
                local result = {}

                local counts = ("    %d    "):format(end_lnum - lnum)
                local suffix = " ⋯⋯  "
                local padding = ""

                local end_virt_text = ctx.get_fold_virt_text(end_lnum)

                local sufWidth = (2 * api.nvim_strwidth(suffix))
                    + api.nvim_strwidth(counts)

                local target_width = width - sufWidth
                local cur_width = 0

                for _, chunk in ipairs(virt_text) do
                    local chunk_text = chunk[1]

                    local chunk_width = api.nvim_strwidth(chunk_text)
                    if target_width > cur_width + chunk_width then
                        table.insert(result, chunk)
                    else
                        chunk_text =
                            truncate(chunk_text, target_width - cur_width)
                        local hl_group = chunk[2]
                        table.insert(result, { chunk_text, hl_group })
                        chunk_width = api.nvim_strwidth(chunk_text)

                        if cur_width + chunk_width < target_width then
                            padding = padding
                                .. (" "):rep(
                                    target_width - cur_width - chunk_width
                                )
                        end
                        break
                    end
                    cur_width = cur_width + chunk_width
                end

                if end_virt_text[1] and end_virt_text[1][1] then
                    end_virt_text[1][1] =
                        end_virt_text[1][1]:gsub("[%s\t]+", "")
                end

                table.insert(result, { suffix, "UfoFoldedEllipsis" })
                table.insert(result, { counts, "MoreMsg" })
                table.insert(result, { suffix, "UfoFoldedEllipsis" })

                vim.list_extend(result, end_virt_text)
                table.insert(result, { padding, "" })

                return result
            end

            local ufo = require "ufo"

            ufo.setup {
                open_fold_hl_timeout = 0,
                fold_virt_text_handler = handler,
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
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Buffertabs",
                    keymaps = {
                        {
                            "gl",
                            "<CMD>BufferLineCycleNext<CR>",
                            description = "Bufferline: next buffer",
                        },
                        {
                            "gh",
                            "<CMD>BufferLineCyclePrev<CR>",
                            description = "Bufferline: prev buffer",
                        },

                        {
                            "<leader><BS>",
                            "<CMD>BufferLineGroupToggle docs<CR>",
                            description = "Bufferline: group close docs",
                        },
                    },
                },
            }
        end,
        config = function()
            local col_base_bg_attr = "Normal"
            local col_base_fg_attr = "Normal"

            local col_unselected_bg_attr = "bufferline_unselected"
            local col_unselected_fg_attr = "Comment"

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
}
