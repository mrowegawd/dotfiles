local cmd = vim.cmd

return {
    -- NEO-TREE
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        init = function()
            require("r.utils").disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    icon = as.ui.icons.misc.smiley,
                    description = "Task functionality",
                    keymaps = {
                        {
                            "<Leader>e",
                            function()
                                require("r.utils.tiling").force_win_close(
                                    { "OverseerList", "undotree", "aerial" },
                                    false
                                )
                                for _, w in ipairs(vim.api.nvim_list_wins()) do
                                    if
                                        vim.api.nvim_buf_get_option(
                                            vim.api.nvim_win_get_buf(w),
                                            "ft"
                                        )
                                        == "neo-tree"
                                    then
                                        return vim.api.nvim_win_close(w, false)
                                    else
                                        return cmd "Neotree toggle"
                                    end
                                end
                            end,
                            description = "Neo-tree: open File explore",
                        },
                        {
                            "<Leader>E",
                            "<CMD>Neotree reveal<CR>",
                            description = "Neo-tree: open find file on File Explore",
                        },
                    },
                },
            }
        end,
        dependencies = {
            "mrbjarksen/neo-tree-diagnostics.nvim",
            -- module = "neo-tree.sources.diagnostics",
        },
        config = function()
            vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

            require("neo-tree").setup {
                source_selector = {
                    winbar = true, -- toggle to show selector on winbar
                    statusline = false, -- toggle to show selector on statusline
                    show_scrolled_off_parent_node = false, -- boolean
                    sources = { -- table
                        {
                            source = "filesystem", -- string
                            display_name = "  Files ", -- string | nil
                        },
                        {
                            source = "buffers", -- string
                            display_name = "  Buffers ", -- string | nil
                        },
                        {
                            source = "git_status", -- string
                            display_name = "  Git ", -- string | nil
                        },
                    },
                    content_layout = "start", -- string
                    tabs_layout = "equal", -- string
                    truncation_character = "…", -- string
                    tabs_min_width = nil, -- int | nil
                    tabs_max_width = nil, -- int | nil
                    padding = 0, -- int | { left: int, right: int }
                    -- separator = { left = "▏", right = "▕" }, -- string | { left: string, right: string, override: string | nil }
                    separator = { left = "", right = "" }, -- string | { left: string, right: string, override: string | nil }
                    separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
                    show_separator_on_edge = false, -- boolean
                    highlight_tab = "Normal", -- string
                    highlight_tab_active = "BufferLineBufferSelected", -- string
                    highlight_background = "NeoTreeTabInactive", -- string
                    highlight_separator = "Normal", -- string
                    highlight_separator_active = "Normal", -- string
                },
                close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
                popup_border_style = "rounded",
                enable_git_status = true,
                enable_diagnostics = true,
                open_files_do_not_replace_types = {
                    "terminal",
                    "trouble",
                    "qf",
                }, -- when opening files, do not use windows containing these filetypes or buftypes
                sort_case_insensitive = false, -- used when sorting files and directories in the tree
                sort_function = nil, -- use a custom function for sorting files and directories in the tree
                -- sort_function = function (a,b)
                --       if a.type == b.type then
                --           return a.path > b.path
                --       else
                --           return a.type > b.type
                --       end
                --   end , -- this sorts files and directories descendantly
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                    },
                    indent = {
                        indent_size = 2,
                        padding = 1, -- extra padding on left hand side
                        -- indent guides
                        with_markers = true,
                        indent_marker = "│",
                        last_indent_marker = "└",
                        highlight = "NeoTreeIndentMarker",
                        -- expander config, needed for nesting files
                        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "ﰊ",
                        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                        -- then these will never be used.
                        default = "*",
                        highlight = "NeoTreeFileIcon",
                    },
                    modified = {
                        symbol = "[+]",
                        highlight = "NeoTreeModified",
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                        highlight = "NeoTreeFileName",
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added = "A", -- or "✚", but this is redundant info if you use git_status_colors on the name
                            modified = "M", -- or "", but this is redundant info if you use git_status_colors on the name
                            deleted = "D", -- this can only be used in the git_status source
                            renamed = "", -- this can only be used in the git_status source
                            -- Status type
                            untracked = "",
                            ignored = "",
                            unstaged = "",
                            staged = "",
                            conflict = "",
                        },
                    },
                },
                -- A list of functions, each representing a global custom command
                -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
                -- see `:h neo-tree-global-custom-commands`
                commands = {},
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["l"] = {
                            "toggle_node",
                            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                        },
                        ["<2-LeftMouse>"] = "open",
                        ["<cr>"] = "open",
                        ["<esc>"] = "revert_preview",
                        ["P"] = {
                            "toggle_preview",
                            config = { use_float = true },
                        },
                        ["<c-s>"] = "open_split",
                        ["<c-v>"] = "open_vsplit",
                        -- ["S"] = "split_with_window_picker",
                        -- ["s"] = "vsplit_with_window_picker",
                        ["<c-t>"] = "open_tabnew",
                        -- ["<cr>"] = "open_drop",
                        -- ["t"] = "open_tab_drop",
                        ["w"] = "open_with_window_picker",
                        --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
                        ["C"] = "close_node",
                        -- ["z"] = "close_all_nodes",
                        ["zM"] = "close_all_subnodes",
                        ["zO"] = "expand_all_nodes",
                        ["gh"] = "prev_source",
                        ["gl"] = "next_source",
                    },
                },
                nesting_rules = {},
                filesystem = {
                    filtered_items = {
                        visible = false, -- when true, they will just be displayed differently than normal items
                        hide_dotfiles = false,
                        hide_gitignored = true,
                        hide_hidden = true, -- only works on Windows for hidden files/directories
                        hide_by_name = {
                            "node_modules",
                            ".git",
                            "node_modules",
                        },
                        hide_by_pattern = { -- uses glob style patterns
                            --"*.meta",
                            --"*/src/*/tsconfig.json",
                        },
                        always_show = { -- remains visible even if other settings would normally hide it
                            --".gitignored",
                        },
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            ".DS_Store",
                            "__pycache__",
                            ".pytest_cache",
                            ".mypy_cache",
                        },
                        never_show_by_pattern = { -- uses glob style patterns
                            --".null-ls_*",
                        },
                    },
                    follow_current_file = false, -- This will find and focus the file in the active buffer every
                    -- time the current file is changed while the tree is open.
                    group_empty_dirs = false, -- when true, empty folders will be grouped together
                    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                    -- in whatever position is specified in window.position
                    -- "open_current",  -- netrw disabled, opening a directory opens within the
                    -- window like netrw would, regardless of window.position
                    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                    -- instead of relying on nvim autocmd events.
                    window = {
                        mappings = {
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                            ["H"] = "toggle_hidden",
                            ["<a-f>"] = "fuzzy_finder",
                            ["<a-d>"] = "fuzzy_finder_directory",
                            ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                            -- ["D"] = "fuzzy_sorter_directory",
                            ["f"] = "filter_on_submit",
                            ["<c-x>"] = "clear_filter",
                            ["gp"] = "prev_git_modified",
                            ["gn"] = "next_git_modified",
                        },
                        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
                            ["<down>"] = "move_cursor_down",
                            ["<C-n>"] = "move_cursor_down",
                            ["<up>"] = "move_cursor_up",
                            ["<C-p>"] = "move_cursor_up",
                        },
                    },

                    commands = {}, -- Add a custom command or override a global one using the same function name
                },
                buffers = {
                    bind_to_cwd = false,
                    follow_current_file = true, -- This will find and focus the file in the active buffer every
                    -- time the current file is changed while the tree is open.
                    group_empty_dirs = true, -- when true, empty folders will be grouped together
                    show_unloaded = true,
                    window = {
                        mappings = {
                            ["bd"] = "buffer_delete",
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                        },
                    },
                },
                git_status = {
                    window = {
                        position = "float",
                        mappings = {
                            ["A"] = "git_add_all",
                            ["gu"] = "git_unstage_file",
                            ["ga"] = "git_add_file",
                            ["gr"] = "git_revert_file",
                            ["gc"] = "git_commit",
                            ["gp"] = "git_push",
                            ["gg"] = "git_commit_and_push",
                        },
                    },
                },
            }

            -- vim.cmd [[nnoremap \ :Neotree reveal<cr>]]
        end,
        --     sources = {
        --         "filesystem",
        --         "buffers",
        --         "git_status",
        --         "diagnostics",
        --     },
        --     source_selector = {
        --         winbar = true,
        --         separator_active = " ",
        --     },
        --     enable_git_status = true,
        --     git_status_async = true,
        --     filesystem = {
        --         hijack_netrw_behavior = "open_current",
        --         use_libuv_file_watcher = true,
        --         group_empty_dirs = true,
        --         follow_current_file = false,
        --         filtered_items = {
        --             visible = false,
        --             hide_dotfiles = false,
        --             hide_gitignored = true,
        --             never_show = {
        --                 ".DS_Store",
        --                 "__pycache__",
        --                 ".pytest_cache",
        --                 ".mypy_cache",
        --                 ".git",
        --                 "node_modules",
        --             },
        --         },
        --         window = {
        --             mappings = {
        --                 ["/"] = "noop",
        --                 ["g/"] = "fuzzy_finder",
        --                 ["e"] = function()
        --                     ---@diagnostic disable-next-line: undefined-field
        --                     vim.api.nvim_exec(
        --                         "Neotree focus filesystem",
        --                         true
        --                     )
        --                 end,
        --                 ["b"] = function()
        --                     ---@diagnostic disable-next-line: undefined-field
        --                     vim.api.nvim_exec("Neotree focus buffers", true)
        --                 end,
        --                 ["g"] = function()
        --                     ---@diagnostic disable-next-line: undefined-field
        --                     vim.api.nvim_exec(
        --                         "Neotree focus git_status",
        --                         true
        --                     )
        --                 end,
        --             },
        --         },
        --     },
        --     default_component_configs = {
        --         icon = {
        --             folder_empty = "",
        --         },
        --         diagnostics = {
        --             highlights = {
        --                 hint = "DiagnosticHint",
        --                 info = "DiagnosticInfo",
        --                 warn = "DiagnosticWarn",
        --                 error = "DiagnosticError",
        --             },
        --         },
        --         modified = {
        --             symbol = "" .. " ",
        --         },
        --         git_status = {
        --             symbols = {
        --                 added = "",
        --                 deleted = "",
        --                 modified = "",
        --                 renamed = "",
        --                 untracked = "",
        --                 ignored = "",
        --                 unstaged = "",
        --                 staged = "",
        --                 conflict = "",
        --             },
        --         },
        --     },
        --     window = {
        --         -- How to disable default mappings:
        --         -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/265#discussioncomment-2547198
        --         mappings = {
        --             ["l"] = "toggle_node",
        --             ["zM"] = "close_all_nodes",
        --             ["z"] = "",
        --             ["<CR>"] = "open",
        --             --
        --             -- ["<c-s>"] = "split_with_window_picker",
        --             ["<c-v>"] = "open_vsplit",
        --             ["<c-s>"] = "open_split",
        --             ["<c-t>"] = "open_tabnew",
        --
        --             ["t"] = "none",
        --             ["w"] = "none",
        --
        --             ["<esc>"] = "revert_preview",
        --             ["P"] = {
        --                 "toggle_preview",
        --                 config = { use_float = true },
        --             },
        --         },
        --     },
        -- }
        -- end,
    },
    -- NVIM-TREE (disabled)
    {
        "nvim-tree/nvim-tree.lua",
        -- tag = "nightly", -- optional, updated every week. (see issue #1193)
        cmd = {
            "NvimTreeToggle",
            "NvimTreeClose",
            "NvimTreeFindFileToggle",
        },
        enabled = false,

        config = function()
            -- disable netrw at the very start of your init.lua (strongly advised)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true

            local nvimtree = require "nvim-tree"

            -- require("base46").load_highlight "nvimtree"

            local options = {
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
                sort_by = "case_sensitive",
                select_prompts = true,
                view = {
                    adaptive_size = true,
                    mappings = {
                        list = {
                            { key = "u", action = "dir_up" },
                            {
                                key = { "<CR>", "<2-LeftMouse>", "l" },
                                action = "edit",
                                mode = "n",
                            },
                            {
                                key = { "<2-RightMouse>", "<C-}>" },
                                action = "cd",
                            },
                            { key = "<C-v>", action = "vsplit" },
                            { key = "<C-s>", action = "split" },
                            { key = "<C-t>", action = "tabnew" },
                            -- { key = "<", action = "prev_sibling" },
                            -- { key = ">", action = "next_sibling" },
                            { key = "P", action = "parent_node" },
                            { key = "<BS>", action = "close_node" },
                            { key = "<S-CR>", action = "close_node" },
                            { key = "<S-l>", action = "close_node" },
                            { key = "<Tab>", action = "preview" },
                            -- { key = "K", action = "first_sibling" },
                            -- { key = "J", action = "last_sibling" },
                            { key = "I", action = "toggle_ignored" },
                            { key = "H", action = "toggle_dotfiles" },
                            { key = "R", action = "refresh" },
                            { key = "a", action = "create" },
                            { key = "d", action = "remove" },
                            { key = "r", action = "rename" },
                            { key = "<C-r>", action = "full_rename" },
                            { key = "x", action = "cut" },
                            { key = "c", action = "copy" },
                            { key = "p", action = "paste" },
                            { key = "y", action = "copy_name" },
                            { key = "Y", action = "copy_path" },
                            { key = "gy", action = "copy_absolute_path" },
                            { key = "<", action = "dir_up" },
                            { key = "q", action = "close" },
                            { key = "g?", action = "toggle_help" },
                            { key = "gp", action = "prev_git_item" },
                            { key = "gn", action = "next_git_item" },
                            -- ["<CR>"] = ":YourVimFunction()<cr>",
                            -- ["u"] = ":lua require'some_module'.some_function()<cr>",
                        },
                    },
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                disable_netrw = false,
                hijack_netrw = true,
                respect_buf_cwd = true,
            }

            nvimtree.setup(options)
        end,
    },
}
