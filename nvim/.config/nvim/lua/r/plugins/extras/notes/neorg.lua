local fmt, cmd, api = string.format, vim.cmd, vim.api

return {
    {
        "nvim-neorg/neorg",
        cmd = { "Neorg" },
        ft = "norg",
        build = ":Neorg sync-parsers", -- This is the important bit!
        init = function()
            as.augroup("ManageNotesNeorg", {
                event = { "FileType" },
                pattern = { "norg" },
                command = function()
                    require("r.mappings.utils.notes").neorg_mappings_ft(
                        api.nvim_get_current_buf()
                    )
                end,
            })

            require("legendary").keymaps {
                {
                    itemgroup = "Notes",
                    keymaps = {
                        {
                            "<Localleader>``",
                            function()
                                if vim.bo.filetype == "norg" then
                                    return cmd [[Neorg return]]
                                else
                                    return cmd [[Neorg workspace wiki]]
                                end
                            end,

                            description = "Neorg: open neorg workspace",
                        },

                        {
                            "<Leader>fn",
                            function()
                                cmd [[Lazy load neorg]]

                                if as.use_search_telescope then
                                    -- TELESCOPE-MENUFACTURE
                                    return require("telescope").extensions.menufacture.find_files {
                                        cwd = as.wiki_path,
                                        prompt_title = "Find Neorg Wiki Files",
                                        theme = "cursor",
                                    }
                                end

                                return require("fzf-lua").files {
                                    prompt = "[Neorg] Files> ",
                                    cwd = as.wiki_path,
                                    winopts = { fullscreen = true },
                                }
                            end,
                            description = "Fzflua: find neorg files",
                        },

                        {
                            "<Leader>fN",
                            function()
                                cmd [[Lazy load neorg]]

                                if as.use_search_telescope then
                                    -- TELESCOPE-MENUFACTURE
                                    return require("telescope").extensions.menufacture.live_grep {
                                        cwd = as.wiki_path,
                                        prompt_title = "Live Grep Neorg Wiki",
                                        vimgrep_arguments = {
                                            "rg",
                                            "--follow",
                                            "--hidden",
                                            "--color=never",
                                            "--no-heading",
                                            "--with-filename",
                                            "--line-number",
                                            "--column",
                                            "--smart-case",
                                            "--trim", -- remove indentation
                                            "-g",
                                            "*.norg",
                                            "-g",
                                            "*.org",
                                            "-g",
                                            "!config/",
                                            "-g",
                                            "!.obsidian/",
                                        },
                                    }
                                end
                                return require("fzf-lua").live_grep_glob {
                                    prompt = "[Neorg] GrepGlob> ",
                                    cwd = as.wiki_path,
                                    winopts = { fullscreen = true },
                                    -- cmd = "rg --follow hidden no-heading with-filename line-number column smart-case trim -- remove indentation -g *.norg -g *.org -g !config/ -g !.obsidian/",
                                }
                            end,
                            description = "Fzflua: live grep neorg files",
                        },
                    },
                },
            }
        end,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-neorg/neorg-telescope",
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
        },
        opts = {
            -- configure_parsers = true,
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        icon_preset = "diamond",
                        fold = true,
                        dim_code_blocks = {
                            padding = { left = 2, right = 2 },
                            width = "content",
                        },
                    },
                },
                ["core.ui.calendar"] = {},
                ["core.highlights"] = {
                    config = {
                        -- highlights = {
                        --
                        --     headings = {
                        --         ["1"] = {
                        --             title = "+NeorgCodeBlock",
                        --         },
                        --     },
                        -- },
                        dim = {
                            tags = {
                                ranged_verbatim = {
                                    code_block = {
                                        reference = "ColorColumn",
                                        percentage = 40,
                                        affect = "background",
                                    },
                                },
                            },

                            markup = { -- hi code line
                                verbatim = {
                                    reference = "ErrorMsg",
                                    percentage = 50,
                                },

                                -- inline_comment = {
                                --     reference = "Normal",
                                --     percentage = 90,
                                -- },
                            },
                        },
                    },
                    -- },
                },
                -- ["core.export.markdown"] = {
                --     config = {
                --         extensions = "all",
                --     },
                -- },
                -- ["core.norg.qol.toc"] = {
                --     config = {
                --         close_split_on_jump = false,
                --         toc_split_placement = "right",
                --     },
                -- },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            -- work = fmt("%s/work", as.wiki_path),
                            gtd = fmt("%s/gtd", as.wiki_path),
                            wiki = as.wiki_path,
                        },
                        -- index = "index.norg",
                        -- autochdir = false,
                        -- autodetect = true,
                    },
                },
                ["core.esupports.metagen"] = {
                    config = {
                        type = "auto",
                    },
                },
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                ["core.integrations.nvim-cmp"] = {},
                -- ["core.integrations.telescope"] = {},
                ["core.keybinds"] = {
                    config = {
                        default_keybinds = false,
                        hook = function(keybinds)
                            -- EXAMPLE ================================================
                            -- Unmaps any Neorg key from the `norg` mode
                            -- keybinds.unmap("norg", "n", "gtd")

                            -- Binds the `gtd` key in `norg` mode to execute `:echo 'Hello'`
                            -- keybinds.map("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")

                            -- Want to move one keybind into the other? `remap_key` moves the data of the
                            -- first keybind to the second keybind, then unbinds the first keybind.
                            -- keybinds.remap_key("norg", "n", "<C-Space>", "<Leader>t")

                            -- Remap unbinds the current key then rebinds it to have a different action
                            -- associated with it.
                            -- The following is the equivalent of the `unmap` and `map` calls you saw above:
                            --
                            -- Sometimes you may simply want to rebind the Neorg action something is bound to
                            -- versus remapping the entire keybind. This remap is essentially the same as if you
                            -- did `keybinds.remap("norg", "n", "<C-Space>, "<cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>")
                            -- keybinds.remap_event(
                            --     "norg",
                            --     "n",
                            --     "<C-Space>",
                            --     "core.norg.qol.todo_items.todo.task_done"
                            -- )
                            -- ========================================================

                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<TAB>",
                                "core.esupports.hop.hop-link"
                            )
                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<M-CR>",
                                "core.esupports.hop.hop-link",
                                "vsplit"
                            )
                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<right>",
                                "core.promo.promote"
                            )
                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<left>",
                                "core.promo.demote"
                            )

                            -- go next heading fold
                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<down>",
                                "core.integrations.treesitter.next.heading"
                            )
                            -- go prev heading fold
                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<up>",
                                "core.integrations.treesitter.previous.heading"
                            )

                            keybinds.remap_event(
                                "norg",
                                "n",
                                ">>",
                                "core.promo.promote"
                            )

                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<<",
                                "core.promo.demote"
                            )

                            keybinds.remap_event(
                                "norg",
                                "n",
                                "<C-c>",
                                "core.qol.todo_items.todo.task_cycle"
                            )

                            -- keybinds.remap_event(
                            --     "norg",
                            --     "n",
                            --     "<left>",
                            --     -- "nested",
                            --     "core.promo.demote"
                            -- )
                            --
                            -- keybinds.remap_event(
                            --     "norg",
                            --     "n",
                            --     "<right>",
                            --     -- "nested",
                            --     "core.promo.promote"
                            -- )
                        end,
                    },
                },
            },
        },
    },
}

-- { ">.", "core.promo.promote", opts = { desc = "Promote Object (Non-Recursively)" } },
-- { "<,", "core.promo.demote", opts = { desc = "Demote Object (Non-Recursively)" } },
--
-- { ">>", "core.promo.promote", "nested", opts = { desc = "Promote Object (Recursively)" } },
-- { "<<", "core.promo.demote", "nested", opts = { desc = "Demote Object (Recursively)" } },
--
-- { leader .. "lt", "core.pivot.toggle-list-type", opts = { desc = "Toggle (Un)ordered List" } },
-- { leader .. "li", "core.pivot.invert-list-type", opts = { desc = "Invert (Un)ordered List" } },
--
-- { leader .. "id", "core.tempus.insert-date", opts = { desc = "Insert Date" } },
