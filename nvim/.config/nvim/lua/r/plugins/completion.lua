local border = as.ui.border.rectangle
local icons = as.ui.icons
local fmt = string.format

return {
    -- CMP
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
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
            "lukas-reineke/cmp-rg",
            "saadparwaiz1/cmp_luasnip",

            -- "lukas-reineke/cmp-rg",
        },
        config = function()
            local cmp = require "cmp"
            local compare = require "cmp.config.compare"

            local has_luasnip, luasnip = pcall(require, "luasnip")

            local function rhs(strmsg)
                return vim.api.nvim_replace_termcodes(strmsg, true, true, true)
            end

            -- Returns the current column number.
            local column = function()
                ---@diagnostic disable-next-line: unused-local
                local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col
            end

            -- Returns true if the cursor is in leftmost column or at a whitespace
            -- character.
            local in_whitespace = function()
                local col = column()
                return col == 0
                    or vim.api.nvim_get_current_line():sub(col, col):match "%s"
            end

            local shift_width = function()
                if vim.o.softtabstop <= 0 then
                    return vim.fn.shiftwidth()
                else
                    return vim.o.softtabstop
                end
            end

            -- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
            --
            --    - Inserts a tab on the left (for indentation).
            --    - Inserts spaces everywhere else (for alignment).
            --
            -- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
            ---@diagnostic disable-next-line: unused-local
            local smart_tab = function(opts)
                local keys = nil
                if vim.o.expandtab then
                    keys = "<Tab>" -- Neovim will insert spaces.
                else
                    local col = column()
                    local line = vim.api.nvim_get_current_line()
                    local prefix = line:sub(1, col)
                    local in_leading_indent = prefix:find "^%s*$"
                    if in_leading_indent then
                        keys = "<Tab>" -- Neovim will insert a hard tab.
                    else
                        -- virtcol() returns last column occupied, so if cursor is on a
                        -- tab it will report `actual column + tabstop` instead of `actual
                        -- column`. So, get last column of previous character instead, and
                        -- add 1 to it.
                        local sw = shift_width()
                        local previous_char = prefix:sub(#prefix, #prefix)
                        local previous_column = #prefix - #previous_char + 1
                        local current_column = vim.fn.virtcol {
                            vim.fn.line ".",
                            previous_column,
                        } + 1
                        local remainder = (current_column - 1) % sw
                        local move = remainder == 0 and sw or sw - remainder
                        keys = (" "):rep(move)
                    end
                end

                vim.api.nvim_feedkeys(rhs(keys), "nt", true)
            end

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

            local callme = 0

            cmp.setup {

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

                completion = {
                    completeopt = "menu,menuone,noselect",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                mapping = {
                    ["<C-n>"] = cmp.mapping(function()
                        if cmp.visible() then
                            -- If there is only one completion candidate, use it.
                            if #cmp.get_entries() == 1 then
                                cmp.confirm { select = true }
                            else
                                cmp.select_next_item()
                            end
                        elseif
                            has_luasnip and luasnip.expand_or_locally_jumpable()
                        then
                            luasnip.expand_or_jump()
                        else
                            cmp.complete()
                        end
                    end, {
                        "i",
                        "s",
                        -- "c",
                    }),
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif
                            has_luasnip
                            and in_snippet()
                            and luasnip.jumpable(-1)
                        then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                        -- "c",
                    }),

                    ["<C-u>"] = cmp.mapping(
                        cmp.mapping.scroll_docs(-4),
                        { "i", "c" }
                    ),
                    ["<C-d>"] = cmp.mapping(
                        cmp.mapping.scroll_docs(4),
                        { "i", "c" }
                    ),
                    ["<CR>"] = cmp.mapping.confirm { select = false },
                    -- ["<CR>"] = cmp.mapping {
                    --     i = function(fallback)
                    --         if cmp.visible() and cmp.get_active_entry() then
                    --             cmp.confirm { select = false }
                    --         else
                    --             fallback()
                    --         end
                    --     end,
                    --     s = cmp.mapping.confirm {
                    --         select = true,
                    --         behavior = cmp.ConfirmBehavior.Replace,
                    --     },
                    --     c = cmp.mapping.confirm { select = true },
                    -- },
                    ---@diagnostic disable-next-line: unused-local
                    ["<C-e>"] = cmp.mapping(function(fallback)
                        cmp.mapping.abort()
                        cmp.mapping.close()

                        if callme == 0 then
                            callme = 1
                            cmp.complete {
                                config = {
                                    sources = {
                                        { name = "luasnip" },
                                    },
                                },
                            }

                            cmp.mapping.close()
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
                            cmp.mapping.close()
                        else
                            callme = 0
                            cmp.complete {
                                config = {
                                    sources = {
                                        { name = "nvim_lsp" },
                                    },
                                },
                            }

                            cmp.mapping.close()
                        end
                    end, {
                        "i",
                        "s",
                        -- "c",
                    }),
                    ["<C-space>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm { select = true }
                        else
                            fallback()
                        end
                    end, { "i", "s", "c" }),

                    ["<C-q>"] = cmp.mapping.abort(),
                    ---@diagnostic disable-next-line: unused-local
                    ["<TAB>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- If there is only one completion candidate, use it.
                            if #cmp.get_entries() == 1 then
                                cmp.confirm { select = true }
                            else
                                cmp.select_next_item()
                            end
                        elseif
                            has_luasnip and luasnip.expand_or_locally_jumpable()
                        then
                            luasnip.expand_or_jump()
                        elseif in_whitespace() then
                            smart_tab()
                        else
                            cmp.complete()
                        end
                    end, {
                        -- "i",
                        -- "s",
                        "c",
                    }),
                    ["<s-TAB>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif
                            has_luasnip
                            and in_snippet()
                            and luasnip.jumpable(-1)
                        then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {
                        -- "i",
                        -- "s",
                        "c",
                    }),
                },
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
                        group_index = 1,
                    },
                    {
                        name = "luasnip",
                        group_index = 1,
                    },
                    {
                        name = "buffer",
                        options = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end,
                        },
                        group_index = 2,
                    },

                    {
                        name = "rg",
                        keyword_length = 4,
                        max_item_count = 10,
                        option = { additional_arguments = "--max-depth 8" },
                        group_index = 1,
                    },
                    {
                        name = "path",
                        group_index = 1,
                    },
                    { name = "neorg", group_index = 2 },
                    { name = "nvim_lsp_signature_help" },
                },
                -- sorting = {
                --     comparators = {
                --         compare.offset,
                --         compare.exact,
                --         compare.score,
                --         -- Taken from https://github.com/lukas-reineke/cmp-under-comparator
                --         function(entry1, entry2)
                --             local _, entry1_under =
                --                 entry1.completion_item.label:find "^_+"
                --             local _, entry2_under =
                --                 entry2.completion_item.label:find "^_+"
                --             entry1_under = entry1_under or 0
                --             entry2_under = entry2_under or 0
                --             if entry1_under > entry2_under then
                --                 return false
                --             elseif entry1_under < entry2_under then
                --                 return true
                --             end
                --         end,
                --         compare.recently_used,
                --         compare.kind,
                --         compare.sort_text,
                --         compare.length,
                --         compare.order,
                --     },
                -- },
                formatting = {
                    fields = { "abbr", "kind", "menu" },

                    format = function(entry, vim_item)
                        local MAX = math.floor(vim.o.columns * 0.5)
                        if #vim_item.abbr >= MAX then
                            vim_item.abbr = vim_item.abbr:sub(1, MAX)
                                .. icons.misc.ellipsis
                        end
                        vim_item.kind = fmt(
                            "%s  %s",
                            icons.kind[vim_item.kind],
                            vim_item.kind
                        )

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

            -- cmp.setup.filetype("norg", {
            --     sources = cmp.config.sources({
            --         { name = "neorg" },
            --         { name = "luasnip" },
            --         { name = "path" },
            --     }, {
            --         { name = "buffer" },
            --     }),
            -- })
            --
            -- cmp.setup.filetype("org", {
            --     sources = cmp.config.sources({
            --         { name = "orgmode" },
            --         { name = "luasnip" },
            --         { name = "path" },
            --     }, {
            --         { name = "buffer" },
            --     }),
            -- })

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "emoji" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
                sources = cmp.config.sources({
                    { name = "vim-dadbod-completion" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = cmp.config.sources {
                    { name = "dap" },
                },
            })

            cmp.setup.cmdline(":", {
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
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

            vim.keymap.set({ "i", "s" }, "<c-e>", function()
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end, { silent = true })

            -- jump backwards key.
            -- this always moves to the previous item within the snippet
            vim.keymap.set({ "i", "s" }, "<c-y>", function()
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, { silent = true })
        end,
    },
}
