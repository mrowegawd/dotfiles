local cmd, fmt = vim.cmd, string.format

-- local function close_toggleterm(fmt_cmd)
--     for _, winid in pairs(api.nvim_tabpage_list_wins(0)) do
--         local winbufnr = vim.fn.winbufnr(api.nvim_win_get_number(winid))
--
--         if winbufnr > 0 then
--             local winft = api.nvim_buf_get_option(winbufnr, "filetype")
--             if winft == "toggleterm" then
--                 cmd(fmt_cmd)
--             end
--         end
--     end
-- end
--
-- local function check_toggleterm(total_term_spawned)
--     -- log.debug(
--     --     "check_toggleterm, total_term: "
--     --         .. total_term_spawned
--     --         .. " term_count: "
--     --         .. as.term_count
--     -- )
--
--     if as.term_count == total_term_spawned then
--         if vim.bo.filetype ~= "toggleterm" then
--             cmd "ToggleTerm"
--         end
--         return
--     end
--
--     if as.term_count == 1 and total_term_spawned == 0 then
--         cmd "ToggleTerm"
--         return
--     end
-- end
--
-- local function increase_toggleterm(total_term_spawned)
--     if as.term_count == total_term_spawned then
--         return
--     end
--
--     local fmt_cmd = "ToggleTerm"
--     close_toggleterm(fmt_cmd)
--
--     -- log.debug("decreaase_toggleterm: " .. as.term_count)
--
--     as.term_count = as.term_count + 1
--     cmd(fmt("%sToggleTerm", as.term_count))
-- end
--
-- local function decreaase_toggleterm()
--     if as.term_count == 1 then
--         return
--     end
--
--     local fmt_cmd = "ToggleTerm"
--     close_toggleterm(fmt_cmd)
--
--     -- log.debug("decreaase_toggleterm: " .. as.term_count)
--
--     as.term_count = as.term_count - 1
--     cmd(fmt("%sToggleTerm", as.term_count))
-- end

return {
    -- BUFTERM (disabled)
    {
        "boltlessengineer/bufterm.nvim",
        cmd = { "BufTermEnter", "BufTermPrev", "BufTermNext" },
        enabled = false,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Terminal",
                    description = "Terminal commands",
                    icon = as.ui.icons.misc.terminal,
                    keymaps = {

                        -- Bufterm
                        {
                            "<Leader>rr",
                            function()
                                -- this will add Terminal to the list (not starting job yet)
                                local Terminal =
                                    require("bufterm.terminal").Terminal
                                local ui = require "bufterm.ui"

                                local lfrun = Terminal:new {
                                    cmd = "lfrun",
                                    buflisted = false,
                                    termlisted = false,
                                }

                                lfrun:spawn()
                                return ui.toggle_float(lfrun.bufnr)
                            end,
                            description = "Bufterm: open lfrun",
                        },
                    },
                },
            }
        end,
        dependencies = {
            { "akinsho/nvim-bufferline.lua" },
        },
        config = function()
            require("bufterm").setup {
                save_native_terms = true, -- integrate native terminals from `:terminal` command
                start_in_insert = true, -- start terminal in insert mode
                remember_mode = true, -- remember vi_mode of terminal buffer
                enable_ctrl_w = true, -- use <C-w> for window navigating in terminal mode (like vim8)
                terminal = { -- default terminal settings
                    buflisted = false, -- whether to set 'buflisted' option
                    fallback_on_exit = true, -- prevent auto-closing window on terminal exit
                },
            }
        end,
    },
    -- TOGGLETERM
    {
        "akinsho/nvim-toggleterm.lua",
        cmd = { "ToggleTerm" },
        enabled = true,
        init = function()
            as.augroup("ManageToggleTerm", {
                event = { "FileType" },
                pattern = { "*" },
                command = function()
                    if vim.bo.filetype ~= "fzf" then
                        require("legendary").keymaps {
                            {
                                itemgroup = "Terminal",
                                description = "Terminal commands",
                                icon = as.ui.icons.misc.terminal,
                                keymaps = {
                                    {
                                        "<c-t>",
                                        function()
                                            if vim.bo.filetype == "qf" then
                                                require("r.utils.tiling").force_win_close(
                                                    { "qf" },
                                                    false
                                                )

                                                cmd [[wincmd w]]
                                            end

                                            cmd(
                                                fmt(
                                                    "%sToggleTerm",
                                                    as.term_count
                                                )
                                            )
                                        end,
                                        description = "Toggle togglerterm",
                                        mode = { "n", "t" },
                                        opts = {
                                            buffer = vim.api.nvim_get_current_buf(),
                                        },
                                    },

                                    {
                                        "<Localleader>rl",
                                        "<CMD>ToggleTermSendCurrentLine<CR>",
                                        description = "Send current line",
                                    },
                                    {
                                        "<Localleader>rl",
                                        "<CMD>ToggleTermSendVisualSelection<CR>",
                                        description = "Send visual selections",
                                        mode = { "v" },
                                    },
                                },
                            },
                        }
                    end
                end,
            })

            -- require("legendary").keymaps {
            --     {
            --         itemgroup = "Terminal",
            --         description = "Terminal commands",
            --         icon = as.ui.icons.misc.terminal,
            --         keymaps = {
            --             {
            --                 "<s-t>",
            --                 function()
            --                     if vim.bo.filetype == "fzf" then
            --                         return vim.notify "yooo"
            --                     end
            --
            --                     if vim.bo.filetype == "qf" then
            --                         require("r.utils.tiling").force_win_close(
            --                             { "qf" },
            --                             false
            --                         )
            --
            --                         cmd [[wincmd w]]
            --                     end
            --
            --                     cmd(fmt("%sToggleTerm", as.term_count))
            --                 end,
            --                 description = "Toggle togglerterm",
            --                 mode = { "n", "t" },
            --             },
            --
            --             -- {
            --             --     "<a-t>",
            --             --     "<CMD>ToggleTermToggleAll<CR>",
            --             --     description = "Open togglerterm all",
            --             --     mode = { "n", "t" },
            --             -- },
            --             -- {
            --             --     "<a-p>",
            --             --     function()
            --             --         local terms = require "toggleterm.terminal"
            --             --         local total_term_spawned = #terms.get_all()
            --             --
            --             --         check_toggleterm(total_term_spawned)
            --             --         increase_toggleterm(total_term_spawned)
            --             --     end,
            --             --     description = "Prev terminal",
            --             --     mode = { "n", "t" },
            --             -- },
            --             --
            --             -- {
            --             --     "<a-n>",
            --             --     function()
            --             --         local terms = require "toggleterm.terminal"
            --             --         local total_term_spawned = #terms.get_all()
            --             --
            --             --         check_toggleterm(total_term_spawned)
            --             --         decreaase_toggleterm()
            --             --     end,
            --             --     description = "Next terminal",
            --             --     mode = { "n", "t" },
            --             -- },
            --             --
            --             -- {
            --             --     "<a-N>",
            --             --     function()
            --             --         local terms = require "toggleterm.terminal"
            --             --         local total_term_spawned = #terms.get_all()
            --             --
            --             --         local fmt_cmd = "ToggleTerm"
            --             --         for _, winid in pairs(api.nvim_tabpage_list_wins(0)) do
            --             --             local winbufnr =
            --             --                 vim.fn.winbufnr(api.nvim_win_get_number(winid))
            --             --
            --             --             if winbufnr > 0 then
            --             --                 local winft = api.nvim_buf_get_option(
            --             --                     winbufnr,
            --             --                     "filetype"
            --             --                 )
            --             --                 if winft == "toggleterm" then
            --             --                     fmt(fmt_cmd)
            --             --                 end
            --             --             end
            --             --         end
            --             --
            --             --         if total_term_spawned == 0 then
            --             --             cmd(fmt_cmd)
            --             --         else
            --             --             as.term_count = as.term_count + 1
            --             --             fmt_cmd = fmt(
            --             --                 [[%sToggleTerm]],
            --             --                 as.term_count
            --             --             )
            --             --             cmd(fmt_cmd)
            --             --         end
            --             --     end,
            --             --     description = "Create new terminal",
            --             -- },
            --
            --             -- {
            --             --     "<a-N>",
            --             --     function()
            --             --         local term = require("toggleterm.terminal").Terminal
            --             --         local fmt_cmd = "ToggleTerm"
            --             --         if not term:is_open() then
            --             --             term:close()
            --             --             cmd(fmt_cmd)
            --             --         end
            --             --
            --             --         as.term_count = as.term_count + 1
            --             --         fmt_cmd = fmt(
            --             --             [[%sToggleTerm]],
            --             --             as.term_count
            --             --         )
            --             --         cmd(fmt_cmd)
            --             --     end,
            --             --     description = "Create new terminal",
            --             --     mode = { "t" },
            --             -- },
            --
            --             -- BufTerm
            --             -- {
            --             --     "<c-t>",
            --             --     function()
            --             --         if vim.bo.filetype == "BufTerm" then
            --             --             cmd [[stopinsert]]
            --             --             return vim.api.nvim_feedkeys(
            --             --                 vim.api.nvim_replace_termcodes(
            --             --                     "<c-^>",
            --             --                     true,
            --             --                     true,
            --             --                     true
            --             --                 ),
            --             --                 "n",
            --             --                 true
            --             --             )
            --             --         else
            --             --             cmd [[BufTermEnter]]
            --             --             return cmd [[startinsert]]
            --             --         end
            --             --     end,
            --             --     description = "Toggle bufterm",
            --             --     mode = { "n", "t" },
            --             -- },
            --             -- NOTE conflict with tmux mapping
            --             -- {
            --             --     "<a-t>",
            --             --     function()
            --             --         local term = require "bufterm.terminal"
            --             --         local ui = require "bufterm.ui"
            --             --
            --             --         local recent_term = term.get_recent_term()
            --             --         if recent_term == nil then
            --             --             vim.notify "[!] There is no opened bufterm, so lemme help you.."
            --             --             return fmt [[BufTermEnter]]
            --             --         end
            --             --         return ui.toggle_float(recent_term.bufnr)
            --             --     end,
            --             --     description = "Make float bufterm",
            --             --     mode = { "n", "t" },
            --             -- },
            --             -- {
            --             --     "<a-p>",
            --             --     [[<CMD>BufTermPrev<CR>]],
            --             --     description = "Prev terminal",
            --             --     mode = { "n", "t" },
            --             -- },
            --             -- {
            --             --     "<a-n>",
            --             --     [[<CMD>BufTermNext<CR>]],
            --             --     description = "Next terminal",
            --             --     mode = { "n", "t" },
            --             -- },
            --             ----
            --             -- {
            --             --     "<c-v>",
            --             --     function()
            --             --         cmd [[vsplit]]
            --             --     end,
            --             --     description = "Open splits",
            --             --     mode = { "t" },
            --             -- },
            --         },
            --     },
            -- }

            require("legendary").keymaps {
                {
                    itemgroup = "Git",
                    keymaps = {
                        {
                            "<F2>",
                            function()
                                local Terminal =
                                    require("toggleterm.terminal").Terminal
                                local _lazygit = Terminal:new {
                                    cmd = "lazygit",
                                    hidden = true,
                                    direction = "float",
                                    on_open = function(term)
                                        cmd "startinsert!"
                                        vim.api.nvim_buf_set_keymap(
                                            term.bufnr,
                                            "n",
                                            "<c-c>",
                                            "<CMD>close<CR>",
                                            { noremap = true, silent = true }
                                        )
                                    end,
                                    on_close = function(_)
                                        cmd ":exit"
                                    end,
                                }

                                _lazygit:toggle()
                            end,
                            description = "Open lazygit",
                        },
                    },
                },
            }
        end,
        opts = {
            size = 90,
            hide_numbers = true,
            -- open_mapping = "",
            shade_filetypes = {},
            shade_terminals = false,
            shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            persist_size = true,
            direction = "vertical",
            -- on_open = function(_)
            --     require("shade").toggle()
            -- end,
            -- on_close = function(_)
            --     require("shade").toggle()
            -- end,
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)
        end,
    },
}
