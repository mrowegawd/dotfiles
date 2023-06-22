local border = as.ui.border.rectangle
local icons = as.ui.icons
local fmt = string.format

return {
    -- CMP
    {
        "hrsh7th/nvim-cmp",
        event = "BufRead",
        -- event = "UIEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "rcarriga/cmp-dap",
            "saadparwaiz1/cmp_luasnip",
            "lukas-reineke/cmp-under-comparator",

            "hrsh7th/cmp-nvim-lsp-document-symbol",
        },
        config = function()
            local cmp = require "cmp"
            -- local compare = require "cmp.config.compare"

            -- compare.lsp_scores = function(entry1, entry2)
            --     local diff
            --     if
            --         entry1.completion_item.score
            --         and entry2.completion_item.score
            --     then
            --         diff = (entry2.completion_item.score * entry2.score)
            --             - (entry1.completion_item.score * entry1.score)
            --     else
            --         diff = entry2.score - entry1.score
            --     end
            --     return (diff < 0)
            -- end

            -- Based on (private) function in LuaSnip/lua/luasnip/init.lua.
            local in_snippet = function()
                local session = require "luasnip.session"
                local node =
                    session.current_nodes[vim.api.nvim_get_current_buf()]
                if not node then
                    return false
                end
                local snippet = node.parent.snippet
                local snip_begin_pos, snip_end_pos =
                    snippet.mark:pos_begin_end()
                local pos = vim.api.nvim_win_get_cursor(0)
                if
                    pos[1] - 1 >= snip_begin_pos[1]
                    and pos[1] - 1 <= snip_end_pos[1]
                then
                    return true
                end
            end

            -- local function deprioritize_snippet(entry1, entry2)
            --     if
            --         entry1:get_kind() == types.lsp.CompletionItemKind.Snippet
            --     then
            --         return false
            --     end
            --     if
            --         entry2:get_kind() == types.lsp.CompletionItemKind.Snippet
            --     then
            --         return true
            --     end
            -- end
            --
            -- local has_words_before = function()
            --     ---@diagnostic disable-next-line: redundant-parameter
            --     if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
            --         return false
            --     end
            --     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            --     return col ~= 0
            --         and vim.api
            --                 .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
            --                 :match "^%s*$"
            --             == nil
            -- end

            local check_backspace = function()
                local col = vim.fn.col "." - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
            end

            local callme = 0

            cmp.setup {
                enabled = function()
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                        or require("cmp_dap").is_dap_buffer()
                end,
                window = {
                    completion = {
                        border = border, --single
                        -- winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
                        scrollbar = "║",
                        col_offset = -1,
                        winhighlight = "Normal:Pmenu,FloatBorder:FzfLuaBorder,CursorLine:PmenuSel",
                        -- side_padding = 0,
                    },
                    documentation = {
                        border = border, -- "shadow", "rounded"
                        winhighlight = "Normal:Pmenu,FloatBorder:FzfLuaBorder,Search:None",
                        scrollbar = "║",
                    },
                },

                preselect = cmp.PreselectMode.None,
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                mapping = {
                    ["<c-n>"] = cmp.mapping(function()
                        local c_cmp = require "cmp"
                        if c_cmp.visible() then
                            c_cmp.select_next_item()
                        else
                            require("cmp").complete()
                        end
                    end, { "i", "s" }),
                    ["<c-p>"] = cmp.mapping(function(fallback)
                        local c_cmp = require "cmp"
                        if c_cmp.visible() then
                            c_cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<TAB>"] = cmp.mapping(function(fallback)
                        local has_luasnip, sp = pcall(require, "luasnip")
                        -- if cmp.visible() then
                        --     cmp.select_next_item()
                        -- if cmp.visible() and has_words_before() then
                        --     cmp.select_next_item {
                        --         behavior = cmp.SelectBehavior.Select,
                        --     }
                        if has_luasnip and sp.expandable() then
                            sp.expand()
                        elseif sp.expand_or_jumpable() then
                            sp.expand_or_jump()
                        elseif check_backspace() then
                            fallback()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-TAB>"] = cmp.mapping(function(fallback)
                        local has_luasnip, sp = pcall(require, "luasnip")

                        if has_luasnip and in_snippet() and sp.jumpable(-1) then
                            sp.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-u>"] = cmp.mapping(
                        cmp.mapping.scroll_docs(-4),
                        { "i", "c" }
                    ),
                    ["<C-d>"] = cmp.mapping(
                        cmp.mapping.scroll_docs(4),
                        { "i", "c" }
                    ),
                    ["<CR>"] = cmp.mapping.confirm { select = false },
                    -- ["<c-space>"] = cmp.mapping.confirm { select = false },

                    ["<C-q>"] = cmp.mapping(function(_)
                        local c_cmp = require "cmp"
                        if c_cmp.visible() then
                            c_cmp.abort()
                        elseif callme == 0 then
                            callme = 1
                            c_cmp.complete {
                                config = {
                                    sources = {
                                        { name = "luasnip" },
                                    },
                                },
                            }
                        elseif callme == 1 then
                            callme = 2
                            cmp.complete {
                                config = {
                                    sources = {
                                        {
                                            name = "buffer",
                                            option = {
                                                get_bufnrs = function()
                                                    return vim.api.nvim_list_bufs()
                                                end,
                                            },
                                        },
                                    },
                                },
                            }
                        else
                            if callme == 2 then
                                callme = 0
                                cmp.complete {
                                    config = {
                                        sources = {
                                            { name = "nvim_lsp" },
                                        },
                                    },
                                }
                            end
                        end
                    end, {
                        "i",
                        "s",
                    }),
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        function(entry1, entry2)
                            local _, entry1_under =
                                entry1.completion_item.label:find "^_+"
                            local _, entry2_under =
                                entry2.completion_item.label:find "^_+"
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                formatting = {
                    fields = { "abbr", "kind", "menu" },

                    format = function(entry, vim_item)
                        local MAX = math.floor(vim.o.columns * 0.5)
                        if #vim_item.abbr >= MAX then
                            vim_item.abbr = vim_item.abbr:sub(1, MAX)
                                .. icons.misc.ellipsis
                        end

                        local item = entry:get_completion_item()
                        if item.detail then
                            vim_item.menu = item.detail
                        end

                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[Lua]",
                            emoji = "[Emoji]",
                            path = "[Path]",
                            neorg = "[Neorg]",
                            luasnip = "[Snip]",
                            dictionary = "[Dict]",
                            treesitter = "串",
                            buffer = "[Buffer]",
                            spell = "[Spell]",
                            cmdline = "[Cmd]",
                            cmdline_history = "[Hist]",
                            orgmode = "[Org]",
                            rg = "[Rg]",
                            git = "[Git]",
                        })[entry.source.name]

                        vim_item.kind = fmt(
                            "%s  %s",
                            icons.kind[vim_item.kind],
                            vim_item.kind
                        )

                        if string.find(vim_item.kind, "Color") then
                            vim_item.kind = "Color"
                            local tailwind_item =
                                require("cmp-tailwind-colors").format(
                                    entry,
                                    vim_item
                                )
                            vim_item.menu = "[Color]"
                            vim_item.kind = " " .. tailwind_item.kind
                        end

                        -- remove duplicates
                        vim_item.dup = ({
                            buffer = 1,
                            path = 1,
                            nvim_lsp = 0,
                        })[entry.source.name] or 0

                        return vim_item
                    end,
                },
                -- experimental = {
                --     ghost_text = {
                --         hl_group = "LspCodeLens",
                --     },
                -- },
                sources = cmp.config.sources {
                    {
                        name = "nvim_lsp",
                        -- Remove snippet from lsp, use luasnip instead
                        ---@diagnostic disable-next-line: unused-local
                        entry_filter = function(entry, ctx)
                            if entry:get_kind() == 15 then
                                return false
                            end
                            return true
                        end,
                        -- group_index = 1,
                    },
                    { name = "luasnip" },
                    { name = "nvim_lsp_document_symbol" },
                    {
                        name = "buffer",
                        option = {
                            keyword_pattern = [[\k\+]],
                            -- Enable completion from all visible buffers
                            get_bufnrs = function()
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end,
                        },
                    },
                    { name = "path" },
                    { name = "neorg" },
                    { name = "nvim_lsp_signature_help" },
                },
            }

            cmp.setup.filetype("markdown", {
                sources = cmp.config.sources({
                    { name = "emoji" },
                    { name = "luasnip" },
                    { name = "path" },
                    -- { name = "spell", group_index = 2 },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.filetype("norg", {
                sources = cmp.config.sources({
                    { name = "neorg" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.filetype("org", {
                sources = cmp.config.sources({
                    { name = "orgmode" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.filetype({ "gitcommit", "NeogitPopup" }, {
                sources = cmp.config.sources {
                    { name = "path" },
                    { name = "emoji" },
                    { name = "buffer" },
                },
            })

            cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
                sources = cmp.config.sources({
                    { name = "vim-dadbod-completion" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
                sources = cmp.config.sources {
                    { name = "dap" },
                },
                mapping = {
                    ["<c-n>"] = cmp.mapping(function()
                        local c_cmp = require "cmp"
                        if c_cmp.visible() then
                            c_cmp.select_next_item()
                        else
                            require("cmp").complete()
                        end
                    end, { "i", "s" }),
                    ["<c-p>"] = cmp.mapping(function(fallback)
                        local c_cmp = require "cmp"
                        if c_cmp.visible() then
                            c_cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
            })

            cmp.setup.cmdline(":", {
                mapping = {
                    ["<esc>"] = {
                        c = function()
                            require("r.utils").feedkey("<c-c>", "n")
                        end,
                    },
                    ["<c-q>"] = {
                        c = function(fallback)
                            if require("cmp").visible() then
                                require("cmp").abort()
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<TAB>"] = {
                        c = function()
                            if require("cmp").visible() then
                                require("cmp").select_next_item()
                            else
                                require("cmp").complete()
                            end
                        end,
                    },
                    ["<S-TAB>"] = {
                        c = function(fallback)
                            if require("cmp").visible() then
                                require("cmp").select_prev_item()
                            else
                                fallback()
                            end
                        end,
                    },
                },
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = {
                    ["<esc>"] = {
                        c = function()
                            require("r.utils").feedkey("<c-c>", "n")
                        end,
                    },
                    ["<c-q>"] = {
                        c = function(fallback)
                            if require("cmp").visible() then
                                require("cmp").abort()
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<TAB>"] = {
                        c = function()
                            if require("cmp").visible() then
                                require("cmp").select_next_item()
                            else
                                require("cmp").complete()
                            end
                        end,
                    },
                    ["<S-TAB>"] = {
                        c = function(fallback)
                            if require("cmp").visible() then
                                require("cmp").select_prev_item()
                            else
                                fallback()
                            end
                        end,
                    },
                },
                sources = {
                    { name = "buffer" },
                },
            })

            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            require("cmp").event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done { map_char = { tex = "" } }
            )
        end,
    },
    -- NEOGEN
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("neogen").setup { snippet_engine = "luasnip" }
        end,
    },
    -- LUASNIP
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        config = function()
            local luasnip = require "luasnip"
            require "neogen"

            luasnip.config.setup {
                history = true,
                enable_autosnippets = true,
                -- Update more often, :h events for more info.
                -- updateevents = "TextChanged,TextChangedI",
            }

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = "~/Dropbox/friendly-snippets",
            }

            luasnip.filetype_extend("django-html", { "html" })
            luasnip.filetype_extend("htmldjango", { "html" })
            luasnip.filetype_extend("javascript", { "html" })
            luasnip.filetype_extend("javascript", { "javascriptreact" })
            luasnip.filetype_extend("javascriptreact", { "html" })
            luasnip.filetype_extend("python", { "django" })
            luasnip.filetype_extend("typescript", { "html" })
            luasnip.filetype_extend("typescriptreact", { "html" })
            luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })

            -- vim.keymap.set({ "i", "s" }, "<c-e>", function()
            --     if luasnip.expand_or_jumpable() then
            --         luasnip.expand_or_jump()
            --     end
            -- end, { silent = true })

            -- jump backwards key.
            -- this always moves to the previous item within the snippet
            -- vim.keymap.set({ "i", "s" }, "<c-y>", function()
            --     if luasnip.jumpable(-1) then
            --         luasnip.jump(-1)
            --     end
            -- end, { silent = true })
        end,
    },
    -- CMP-TAILWIND-COLORS
    {
        -- Support cmp color for tailwind
        "js-everts/cmp-tailwind-colors",
        config = function()
            require("cmp-tailwind-colors").setup()
        end,
    },
}
