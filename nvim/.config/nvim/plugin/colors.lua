if not as then
    return
end

local highlight, augroup = as.highlight, as.augroup

local general_overrides = function()
    highlight.all {
        { ColorColumn = { bg = { from = "Normal", alter = 0.1 } } },
        { CursorLine = { bg = { from = "Normal", alter = 0.3 } } },
        -- { MsgArea = { bg = { from = "Normal", alter = -10 } } },
        -- { MsgSeparator = { link = "MsgArea" } },
        {
            FoldColumn = {
                bg = "NONE",
                fg = {
                    from = "ColorColumn",
                    attr = "bg",
                    alter = 0.2,
                },
            },
        },
        {
            LineNr = {
                bg = "NONE",
                fg = { from = "FoldColumn", attr = "fg", alter = 0.2 },
            },
        },
        {
            CursorLineNr = {
                fg = { from = "ColorColumn", attr = "bg", alter = 1.5 },
            },
        },
        { NormalFloat = { bg = { from = "Pmenu" } } },
        {
            FloatBorder = {
                bg = { from = "Normal" },
                fg = { from = "Comment" },
            },
        },
        {
            Pmenu = {
                bg = { from = "Normal", attr = "bg", alter = -0.3 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
            },
        },
        {
            PmenuSel = {
                bold = true,
                fg = "NONE",
            },
        },
        {
            PmenuThumb = {
                bg = { from = "Normal", attr = "bg", alter = 0.3 },
            },
        },
        {
            Comment = {
                fg = { from = "Comment", alter = -0.1 },
                italic = true,
            },
        },
        { Type = { italic = true, bold = true } },
        { -- Add undercurl to existing spellbad highlight
            SpellBad = {
                undercurl = true,
                bg = "NONE",
                fg = "NONE",
                sp = "green",
                bold = true,
            },
        },
        {
            Folded = {
                fg = { from = "Folded", attr = "fg", alter = -0.3 },
                bg = { from = "Folded", attr = "bg", alter = -0.4 },
            },
        },
        {
            QuickFixLine = {
                bg = { from = "Normal", attr = "bg", alter = -0.5 },
            },
        },
        { SpellRare = { undercurl = true } },
        { EndOfBuffer = { bg = "NONE" } },
        { SignColumn = { bg = "NONE" } },
        { MarkSignNumHL = { inherit = "SpecialKey", bg = "NONE" } },
        {
            WinSeparator = {
                bg = { from = "ColorColumn", attr = "bg" },
                fg = {
                    from = "ColorColumn",
                    attr = "bg",
                    alter = 0.2,
                },
            },
        },

        -----------------------------------------------------------------------
        --  SEMANTIC TOKENS
        -----------------------------------------------------------------------
        -- { ["@lsp.type.variable"] = { clear = true } },
        -- { ["@lsp.typemod.method"] = { link = "@method" } },
        -- {
        --     ["@lsp.type.parameter"] = {
        --         italic = true,
        --         fg = { from = "Normal" },
        --     },
        -- },
        --
        -- {
        --     ["@lsp.typemod.variable.global"] = {
        --         bold = true,
        --         inherit = "@constant.builtin",
        --     },
        -- },
        -- { ["@lsp.typemod.variable.defaultLibrary"] = { italic = true } },
        -- { ["@lsp.typemod.variable.readonly.typescript"] = { clear = true } },
        -- { ["@lsp.type.type.lua"] = { clear = true } },
        -- { ["@lsp.typemod.number.injected"] = { link = "@number" } },
        -- { ["@lsp.typemod.operator.injected"] = { link = "@operator" } },
        -- { ["@lsp.typemod.keyword.injected"] = { link = "@keyword" } },
        -- { ["@lsp.typemod.string.injected"] = { link = "@string" } },
        -- { ["@lsp.typemod.variable.injected"] = { link = "@variable" } },
        -----------------------------------------------------------------------
        -- TREESITTER
        -----------------------------------------------------------------------
        -- { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
        -- { ["@type.qualifier"] = { inherit = "@keyword", italic = true } },
        -- { ["@variable"] = { clear = true } },
        -- { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
        -- { ["@error"] = { fg = "fg", bg = "NONE" } },
        -- { ["@text.diff.add"] = { link = "DiffAdd" } },
        -- { ["@text.diff.delete"] = { link = "DiffDelete" } },
        -- { ["@text.title.markdown"] = { underdouble = true } },

        -----------------------------------------------------------------------
        -- Diff
        -----------------------------------------------------------------------
        {
            DiffAdd = {
                -- bg = as.ui.palette.green,
                underline = false,
            },
        },
        {
            DiffDelete = {
                -- bg = as.ui.palette.dark_red,
                underline = false,
            },
        },
        {
            DiffChange = {
                -- bg = as.ui.palette.dark_orange,
                underline = false,
            },
        },
        {
            DiffText = {
                -- bg = as.ui.palette.dark_green,
                fg = "#003300",
                underline = false,
            },
        },

        { diffAdded = { link = "DiffAdd" } },
        { diffChanged = { link = "DiffChange" } },
        { diffRemoved = { link = "DiffDelete" } },
        { diffBDiffer = { link = "WarningMsg" } },
        { diffCommon = { link = "WarningMsg" } },
        { diffDiffer = { link = "WarningMsg" } },
        { diffFile = { link = "Directory" } },
        { diffIdentical = { link = "WarningMsg" } },
        { diffIndexLine = { link = "Number" } },
        { diffIsA = { link = "WarningMsg" } },
        { diffNoEOL = { link = "WarningMsg" } },
        { diffOnly = { link = "WarningMsg" } },

        -----------------------------------------------------------------------
        -- LSP
        -----------------------------------------------------------------------
        { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
        { LspCodeLensSeparator = { bold = false, italic = false } },
        {
            LspReferenceText = {
                bg = "NONE",
                underline = true,
                sp = { from = "Comment", attr = "fg" },
            },
        },
        { LspReferenceRead = { link = "LspReferenceText" } },
        {
            LspReferenceWrite = {
                inherit = "LspReferenceText",
                bold = true,
                italic = true,
                underline = true,
            },
        },
        { LspSignatureActiveParameter = { link = "Visual" } },

        -- { illuminatedWordText = { link = "LspReferenceText" } },
        -- { illuminatedWordWrite = { link = "LspReferenceText" } },
        -- { illuminatedWordRead = { link = "LspReferenceText" } },

        { illuminatedWordText = { link = "LspReferenceText" } },
        {
            illuminatedWordWrite = {
                bg = { from = "Visual", attr = "bg", alter = -0.05 },
                fg = "NONE",
            },
        },
        {
            illuminatedWordRead = {
                bg = { from = "Visual", attr = "bg", alter = -0.05 },
                fg = "NONE",
            },
        },

        -----------------------------------------------------------------------
        -- DIAGNOSTIC
        -----------------------------------------------------------------------
        { DiagnosticHint = { bg = "NONE" } },
        { DiagnosticError = { bg = "NONE" } },
        { DiagnosticWarning = { bg = "NONE" } },
        { DiagnosticInfo = { bg = "NONE" } },
        { DiagnosticSignError = { bg = "NONE" } },
        { DiagnosticSignWarn = { bg = "NONE" } },
        { DiagnosticSignInfo = { bg = "NONE" } },
        { DiagnosticSignHint = { bg = "NONE" } },

        -- Floating windows
        { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
        { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
        { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
        { DiagnosticFloatingError = { link = "DiagnosticError" } },
        { DiagnosticFloatTitle = { inherit = "FloatTitle", bold = true } },
        {
            DiagnosticFloatTitleIcon = {
                inherit = "FloatTitle",
                fg = { from = "@character" },
            },
        },

        -----------------------------------------------------------------------
        -- CUSTOMS
        -----------------------------------------------------------------------
        { MyCursorline = { bg = { from = "Normal", alter = 0.2 } } },
        {
            Mystatusline_fg = {
                fg = { from = "LineNr", alter = 0.1 },
            },
        },
        {
            Mystatusline_bg = {
                bg = { from = "Normal", alter = -0.1 },
            },
        },
        {
            bufferline_unselected = {
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
            },
        },
        {
            Mygreen_fg = {
                fg = { from = "GitSignsAdd", attr = "fg", alter = 0.1 },
            },
        },
        {
            Mymisc_fg = {
                fg = { from = "Boolean", atrr = "fg", alter = 0.1 },
                bg = { from = "Normal", alter = -0.1 },
                -- bg = "NONE",
            },
        },
        {
            MyQuickFixLineLeave = { bg = { from = "PmenuSel", alter = -0.65 } },
        },
        {
            MyQuickFixLineEnter = { bg = { from = "PmenuSel", alter = -0.3 } },
        },
        -----------------------------------------------------------------------
        -- PLUGINS
        -----------------------------------------------------------------------

        -- CMP ================================================================

        {
            CmpItemAbbr = {
                fg = { from = "Normal", attr = "fg", alter = -0.3 },
            },
        },
        {
            CmpItemAbbrMatch = {
                fg = { from = "ErrorMsg", alter = 0.3 },
                bg = "NONE",
                bold = true,
            },
        },
        {
            CmpItemMenu = {
                fg = { from = "Normal", alter = -0.5 },
                italic = true,
            },
        },

        {
            CmpItemAbbrMatchFuzzy = {
                fg = { from = "ErrorMsg", alter = -0.3 },
                italic = true,
            },
        },

        -- TELESCOPE ==========================================================
        { TelescopeNormal = { link = "Normal" } },
        {
            TelescopeBorder = {
                fg = { from = "Normal", alter = -0.4 },
                bg = { from = "Normal", attr = "bg" },
            },
        },

        -- Prompt
        {
            TelescopePromptTitle = {
                bg = { from = "Normal", attr = "bg" },
                fg = { from = "WarningMsg", alter = 0.14, bold = true },
                bold = true,
            },
        },
        {
            TelescopePromptBorder = {
                fg = { from = "Normal", alter = -0.4 },
                bg = { from = "Normal", attr = "bg" },
            },
        },
        { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
        { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },

        -- Preview
        {
            TelescopePreviewTitle = {
                bg = { from = "Normal", attr = "bg" },
                fg = { from = "Normal", alter = 0.14, bold = true },
                bold = true,
            },
        },
        { TelescopeSelection = { link = "PmenuSel" } },
        { TelescopeMatching = { link = "CmpItemAbbrMatch" } },

        -- Results
        {
            TelescopeResultsTitle = {
                bg = "NONE",
            },
        },
        -- FZFLUA =============================================================
        { FzfLuaNormal = { link = "Pmenu" } },
        {
            FzfLuaBorder = {
                fg = { from = "Pmenu", attr = "fg", alter = -0.8 },
                bg = { from = "Pmenu", attr = "bg" },
            },
        },
        {
            FzfLuaTitle = {
                fg = { from = "Boolean", attr = "fg", alter = -0.3 },
            },
        },

        -- NOICE ==============================================================

        { NoicePopupBorder = { link = "Pmenu" } },
        { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
        {
            NoiceCmdlinePopupBorder = {
                fg = { from = "Pmenu", attr = "fg", alter = -0.7 },
            },
        },

        -- ORGMODE ============================================================

        { OrgDONE = { fg = "#00FF00" } },

        -- NEORG ==============================================================
        -- {
        --     NeorgCodeBlock = { bg = { from = "CursorIM", alter = -14 } },
        -- },

        -- INDENTBLANK ========================================================
        {
            IndentBlanklineChar = {
                fg = {
                    from = "ColorColumn",
                    attr = "bg",
                    alter = 0.15,
                },
            },
        },
    }
end

local function colorscheme_overrides()
    local overrides = {
        ["material"] = {}, -- hi set custom hi untuk "material" colorscheme, harus di set config nya
        ["gruvbox"] = {
            {
                CmpItemAbbrMatch = {
                    fg = { from = "ErrorMsg", attr = "bg", alter = 0.2 },
                    bg = "NONE",
                    bold = true,
                },
            },

            {
                PmenuSel = {
                    bold = true,
                    fg = { from = "CmpItemMenu", attr = "fg", alter = 0.9 },
                },
            },

            {
                Error = {
                    bg = "NONE",
                },
            },

            {
                CursorLineNr = {
                    bg = "NONE",
                },
            },
            {
                MyQuickFixLineLeave = {
                    bg = { from = "PmenuSel", alter = -0.5 },
                },
            },

            { LspCodeLens = { fg = { from = "LspCodeLens", alter = -0.5 } } },
            {
                illuminatedWordWrite = {
                    bg = {
                        from = "illuminatedWordWrite",
                        attr = "bg",
                        alter = -0.30,
                    },
                },
            },
            {
                illuminatedWordRead = {
                    bg = {
                        from = "illuminatedWordRead",
                        attr = "bg",
                        alter = -0.30,
                    },
                },
            },

            {
                Comment = {
                    fg = { from = "Comment", alter = -0.4 },
                },
            },
        },
        ["doom-one"] = {
            {
                FzfLuaBorder = {
                    fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.2 },
                },
            },
            {
                CursorLineNr = {
                    bg = "NONE",
                },
            },
            {
                PmenuSel = {
                    bold = true,
                    fg = "NONE",
                    bg = { from = "PmenuSel", alter = -0.3 },
                },
            },
            {
                CmpItemAbbrMatch = {
                    fg = { from = "ErrorMsg", alter = 0.15 },
                    bg = "NONE",
                    bold = true,
                },
            },
            {
                illuminatedWordWrite = {
                    bg = {
                        from = "illuminatedWordWrite",
                        attr = "bg",
                        alter = -0.35,
                    },
                },
            },
            {
                illuminatedWordRead = {
                    bg = {
                        from = "illuminatedWordRead",
                        attr = "bg",
                        alter = -0.35,
                    },
                },
            },
        },
        ["gruvbox-material"] = {
            {
                bufferline_unselected = {
                    bg = { from = "Normal", attr = "fg", alter = -0.75 },
                },
            },
            { Normal = { bg = { from = "Normal", alter = -0.05 } } },
            {
                PmenuSel = {
                    bold = true,
                    fg = "NONE",
                    bg = { from = "PmenuSel", alter = -0.5 },
                },
            },
            {
                Comment = {
                    fg = { from = "Comment", alter = -0.4 },
                },
            },
        },
        ["kanagawa"] = {
            { Normal = { bg = { from = "Normal", alter = -0.05 } } },
            {
                CmpItemAbbrMatch = {
                    fg = { from = "ErrorMsg", alter = 0.5 },
                    bg = "NONE",
                    bold = true,
                },
            },
            {
                CmpItemAbbrMatch = {
                    fg = { from = "ErrorMsg", attr = "fg", alter = 0.5 },
                    bg = "NONE",
                    bold = true,
                },
            },
            {
                FoldColumn = {
                    bg = "NONE",
                    fg = {
                        from = "ColorColumn",
                        attr = "bg",
                        alter = 0.3,
                    },
                },
            },

            { GitSignsAdd = { bg = "NONE" } },
            { GitSignsChange = { bg = "NONE" } },
            { GitSignsDelete = { bg = "NONE" } },

            {
                Comment = {
                    fg = { from = "Comment", alter = -0.4 },
                },
            },

            {
                CursorLineNr = {
                    bg = "NONE",
                },
            },

            { NormalFloat = { bg = { from = "Normal" } } },

            {
                illuminatedWordWrite = {
                    bg = {
                        from = "illuminatedWordWrite",
                        attr = "bg",
                        alter = -0.2,
                    },
                },
            },
            {
                illuminatedWordRead = {
                    bg = {
                        from = "illuminatedWordRead",
                        attr = "bg",
                        alter = -0.2,
                    },
                },
            },
        },

        ["catppuccin"] = {
            { NormalFloat = { bg = { from = "Pmenu" } } },
            { LspCodeLens = { fg = { from = "LspCodeLens", alter = -0.5 } } },
            { CursorLine = { bg = { from = "CursorLine", alter = -0.1 } } },
            {
                Comment = {
                    fg = { from = "Comment", alter = -0.4 },
                },
            },
            {
                FoldColumn = {
                    bg = "NONE",
                    fg = {
                        from = "ColorColumn",
                        attr = "bg",
                        alter = 0.3,
                    },
                },
            },
            {
                CmpItemAbbrMatch = {
                    fg = { from = "ErrorMsg", alter = -0.4 },
                    bg = "NONE",
                    bold = true,
                },
            },
            {
                PmenuSel = {
                    bold = true,
                    bg = { from = "PmenuSel", alter = -0.3 },
                    fg = "NONE",
                },
            },
            {
                MyQuickFixLineLeave = {
                    bg = { from = "PmenuSel", alter = -0.1 },
                },
            },
            {
                MyQuickFixLineEnter = {
                    bg = { from = "PmenuSel", alter = 0.3 },
                },
            },
        },
        ["tokyonight"] = {
            { Normal = { bg = { from = "Normal", alter = -0.05 } } },
            { NormalFloat = { bg = { from = "Pmenu" } } },
            {
                PmenuSel = {
                    bold = true,
                    fg = "NONE",
                    bg = { from = "PmenuSel", alter = 0.6 },
                },
            },
            {
                FoldColumn = {
                    bg = "NONE",
                    fg = {
                        from = "ColorColumn",
                        attr = "bg",
                        alter = 0.3,
                    },
                },
            },
        },
    }

    local hls = overrides[as.colorscheme]
    if not hls then
        return
    end
    highlight.all(hls)
end

local function user_highlights()
    general_overrides()
    colorscheme_overrides()
end

local sidebar_fts = {
    "packer",
    "flutterToolsOutline",
    "undotree",
    "Outline",
    "dbui",
    "neotest-summary",
    "pr",
}

local function on_sidebar_enter()
    vim.opt_local.winhighlight:append {
        Normal = "PanelBackground",
        EndOfBuffer = "PanelBackground",
        StatusLine = "PanelSt",
        StatusLineNC = "PanelStNC",
        SignColumn = "PanelBackground",
        VertSplit = "PanelVertSplit",
        WinSeparator = "PanelWinSeparator",
    }
end

augroup("UserHighlights", {
    event = "ColorScheme",
    command = function()
        user_highlights()
    end,
}, {
    event = "FileType",
    pattern = sidebar_fts,
    command = function()
        on_sidebar_enter()
    end,
})
