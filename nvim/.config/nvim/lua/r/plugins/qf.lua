return {
    -- LISTISH
    {
        "arsham/listish.nvim",
        event = "VeryLazy",
        dependencies = { "arsham/arshlib.nvim" },
        config = function()
            require("listish").config {
                theme_list = true,
                clearqflist = "Clearquickfix", -- command
                clearloclist = "Clearloclist", -- command
                clear_notes = "ClearListNotes", -- command
                lists_close = "<leader>cc", -- closes both qf/local lists
                in_list_dd = "dd", -- delete current item in the list
                signs = { -- show signs on the signcolumn
                    locallist = "", -- the icon/sigil/sign on the signcolumn
                    qflist = "", -- the icon/sigil/sign on the signcolumn
                    priority = 10,
                },
                extmarks = { -- annotate with extmarks
                    locallist_text = " Locallist Note",
                    qflist_text = " Quickfix Note",
                },
                quickfix = {
                    open = "<localleader>qo",
                    on_cursor = "<localleader>qq", -- add current position to the list
                    add_note = "<localleader>qn", -- add current position with your note to the list
                    clear = "<localleader>qd", -- clear all items
                    close = "<localleader>qc",
                    next = "]q",
                    prev = "[q",
                },
                locallist = {
                    open = "<localleader>wo",
                    on_cursor = "<localleader>ww",
                    add_note = "<localleader>wn",
                    clear = "<localleader>wd",
                    close = "<localleader>wc",
                    next = "]w",
                    prev = "[w",
                },
            }
        end,
    },
    -- NVIM-BQF
    {

        "kevinhwang91/nvim-bqf",
        ft = { "qf" },
        dependencies = {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
        config = function()
            local bqf = require "bqf"

            bqf.setup {
                preview = {
                    auto_preview = false,
                    show_title = true,
                    wrap = false,
                    buf_label = true,
                    should_preview_cb = nil,
                    win_height = 12,
                    win_vheight = 12,
                    delay_syntax = 80,
                    -- should_preview_cb = function(bufnr, _)
                    --     local ret = true
                    --     local bufname = vim.api.nvim_buf_get_name(bufnr)
                    --     local fsize = vim.fn.getfsize(bufname)
                    --     if fsize > 100 * 1024 then
                    --         -- skip file size greater than 100k
                    --         ret = false
                    --     elseif bufname:match "^fugitive://" then
                    --         -- skip fugitive buffer
                    --         ret = false
                    --     end
                    --     return ret
                    -- end,
                },
                -- make `drop` and `tab drop` to become preferred
                func_map = {
                    drop = "o",
                    openc = "O",
                    split = "<C-s>",
                    vsplit = "<C-v>",
                    tabdrop = "<C-t>",
                    tabc = "",
                    tab = "",
                    ptogglemode = "p",
                    ptoggleauto = "P",

                    ptoggleitem = "",
                    -- pscrollup = "<a-u>",
                    -- pscrolldown = "<a-d>",
                    prevfile = "",
                    nextfile = "",
                    sclear = "z<Tab>",
                    filter = "zn",
                    filterr = "zN",
                    fzffilter = "<c-f>",
                },
                filter = {
                    fzf = {
                        action_for = {
                            ["ctrl-s"] = "split",
                            ["ctrl-t"] = "tab drop",
                        },
                        extra_opts = {
                            "--bind",
                            "ctrl-o:toggle-all",
                            "--prompt",
                            "> ",
                        },
                    },
                },
            }
        end,
    },
    ---------------------------------------------------------------------
    -- MY PLUGINS
    ---------------------------------------------------------------------
    {
        dir = "~/Downloads/qfsilet",
        event = "BufRead",
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {
                            "<leader>QQ",
                            "<CMD>QFSiletLoad<CR>",
                            description = "QFSilet: load",
                        },
                        {
                            "<localleader>qs",
                            "<CMD>QFSiletSave<CR>",
                            description = "QFSilet: save",
                        },
                    },
                },
            }
        end,
        config = function()
            require("qfsilet").setup {
                qf = {
                    use_default_keymaps = true,
                },
            }
        end,
    },
}
