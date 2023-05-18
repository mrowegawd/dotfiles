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
                    open = "<leader>qo",
                    on_cursor = "<leader>qq", -- add current position to the list
                    add_note = "<leader>qn", -- add current position with your note to the list
                    clear = "<leader>qd", -- clear all items
                    close = "<leader>qc",
                    next = "]q",
                    prev = "[q",
                },
                locallist = {
                    open = "<leader>wo",
                    on_cursor = "<leader>ww",
                    add_note = "<leader>wn",
                    clear = "<leader>wd",
                    close = "<leader>wc",
                    next = "]w",
                    prev = "[w",
                },
            }
        end,
    },
    -- NVIM-BQF
    {

        "kevinhwang91/nvim-bqf",
        event = "VeryLazy",
        dependencies = {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "qf" },
                callback = function()
                    local ft, _ = as.get_bo_buft()

                    vim.keymap.set("n", "<c-d>", function()
                        local pvs = require "bqf.preview.session"

                        if ft ~= "qf" then
                            if pvs.validate() then
                                return require("bqf.preview.handler").scroll(1)
                            else
                                return vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes(
                                        "<C-d>",
                                        true,
                                        true,
                                        true
                                    ),
                                    "n",
                                    true
                                )
                            end
                        end
                    end, {
                        silent = true,
                        buffer = vim.api.nvim_get_current_buf(),
                    })

                    vim.keymap.set("n", "<c-u>", function()
                        local pvs = require "bqf.preview.session"

                        if pvs.validate() then
                            if pvs.validate() then
                                return require("bqf.preview.handler").scroll(-1)
                            else
                                return vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes(
                                        "<C-u>",
                                        true,
                                        true,
                                        true
                                    ),
                                    "n",
                                    true
                                )
                            end
                        end
                    end, {
                        silent = true,
                        buffer = vim.api.nvim_get_current_buf(),
                    })
                end,
            })
        end,

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
                    pscrollup = "<a-u>",
                    pscrolldown = "<a-d>",
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
}
