local config = {}

local function load_env_file()
    local env_file = os.getenv("HOME") .. "/.env"
    local env_contents = {}
    if vim.fn.filereadable(env_file) ~= 1 then
        print(".env file does not exist")
        return
    end
    local contents = vim.fn.readfile(env_file)
    for _, item in pairs(contents) do
        local line_content = vim.fn.split(item, "=")
        env_contents[line_content[1]] = line_content[2]
    end
    return env_contents
end

local function load_dbs()
    local env_contents = load_env_file()
    local dbs = {}
    for key, value in pairs(env_contents) do
        if vim.fn.stridx(key, "DB_CONNECTION_") >= 0 then
            local db_name = vim.fn.split(key, "_")[3]:lower()
            dbs[db_name] = value
        end
    end
    return dbs
end

function config.vim_dadbod_ui()
    if packer_plugins["vim-dadbod"] and not packer_plugins["vim-dadbod"].loaded then
        vim.cmd([[packadd vim-dadbod]])
    end
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
    vim.g.db_ui_save_location = os.getenv("HOME") .. "/.cache/vim/db_ui_queries"
    vim.g.dbs = load_dbs()
end

function config.nvim_spectre()
    require("spectre").setup(
        {
            find_engine = {
                -- rg is map with finder_cmd
                ["rg"] = {
                    cmd = "rg",
                    -- default args
                    args = {
                        "--hidden",
                        "--follow",
                        "--no-ignore-vcs",
                        "-g",
                        "!{node_modules,.git,__pycache__,.pytest_cache}",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case"
                    }
                }
            }
        }
    )
end

function config.session()
    local opts = {
        log_level = "info",
        auto_session_enable_last_session = false,
        auto_session_root_dir = O.default.cache_dir .. "session/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = nil,
        auto_session_suppress_dirs = nil
    }
    require("auto-session").setup(opts)
end

-- function config.nvim_toggleterm ()
--   local stats = vim.api.nvim_list_uis()[1]
--   local width = stats.width
--   local height = stats.height

--   local win_height = math.ceil(height * 0.7)
--   local win_width = math.ceil(width * 0.7)

--   require("toggleterm").setup{
--     -- size can be a number or function which is passed the current terminal
--     size = function(term)
--       if term.direction == "horizontal" then
--         return 15
--       elseif term.direction == "vertical" then
--         return vim.o.columns * 0.4
--       end
--     end,
--     open_mapping = [[<c-\>]],
--     hide_numbers = true, -- hide the number column in toggleterm buffers
--     shade_filetypes = {},
--     shade_terminals = true,
--     shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
--     start_in_insert = true,
--     insert_mappings = true, -- whether or not the open mapping applies in insert mode
--     persist_size = true,
--     -- direction = 'vertical' or 'horizontal' or 'window' | 'float',
--     direction = 'float',
--     close_on_exit = true, -- close the terminal window when the process exits
--     shell = vim.o.shell, -- change the default shell
--     -- This field is only relevant if direction is set to 'float'
--     float_opts = {
--       -- The border key is *almost* the same as 'nvim_win_open'
--       -- see :h nvim_win_open for details on borders however
--       -- the 'curved' border is a custom border type
--       -- not natively supported but implemented in this plugin.
--       border = "single",
--       width = win_width,
--       height = win_height,
--       winblend = 3,
--       highlights = {
--         border = "Normal",
--         background = "Normal",
--       }
--     }
--   }
-- end

function config.fugitive()
end

function config.vim_floaterm()
    vim.g.floaterm_wintype = "float"
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.9
end

function config.todo_comments()
    local opt = {
        signs = true, -- show icons in the signs column
        -- keywords recognized as todo comments
        keywords = {
            FIX = {
                icon = " ", -- icon used for the sign, and in search results
                color = "error", -- can be a hex color, or a named color (see below)
                alt = {"FIXME", "BUG", "FIXIT", "FIX", "ISSUE"} -- a set of other keywords that all map to this FIX keywords
                -- signs = false, -- configure signs for some keywords individually
            },
            TODO = {icon = " ", color = "info"},
            HACK = {icon = " ", color = "warning"},
            WARN = {icon = " ", color = "warning", alt = {"WARNING", "XXX"}},
            PERF = {icon = " ", alt = {"OPTIM", "PERFORMANCE", "OPTIMIZE"}},
            NOTE = {icon = " ", color = "hint", alt = {"INFO"}}
        },
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
            before = "", -- "fg" or "bg" or empty
            keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
            comments_only = true -- uses treesitter to match keywords in comments only
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of hilight groups or use the hex color if hl not found as a fallback
        colors = {
            error = {"LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626"},
            warning = {"LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24"},
            info = {"LspDiagnosticsDefaultInformation", "#2563EB"},
            hint = {"LspDiagnosticsDefaultHint", "#10B981"},
            default = {"Identifier", "#7C3AED"}
        },
        search = {
            command = "rg",
            args = {
                "--color=never",
                "--no-heading",
                "--follow",
                "--hidden",
                "--with-filename",
                "--line-number",
                "--column"
            },
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS):]] -- ripgrep regex
            -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        }
    }

    local status_ok, todo_comments = pcall(require, "todo-comments")
    if not status_ok then
        print("+ todo_comments not active")
        return
    end
    todo_comments.setup(opt)
end

function config.orgmode_nvim()
    require("orgmode").setup(
        {
            org_agenda_files = {"~/Dropbox/org/*", "~/Dropbox/org/org/*"},
            org_default_notes_file = "~/Dropbox/org/org/refile.org",
            org_todo_keywords = {"TODO", "CANCELED", "DELEGATED", "NEXT", "|", "DONE"},
            org_hide_emphasis_markers = true,
            org_log_done = nil,
            org_todo_keyword_faces = {
                NEXT = ":background #0000ff :weight bold",
                DELEGATED = ":background #FFFFFF :slant italic :underline on",
                CANCELED = ":foreground yellow :underline on"
            },
            mappings = {
                disable_all = false,
                global = {
                    org_agenda = ",ww",
                    org_capture = ",wc"
                },
                agenda = {
                    org_agenda_later = "f",
                    org_agenda_earlier = "b",
                    org_agenda_goto_today = "~",
                    org_agenda_day_view = "vd",
                    org_agenda_week_view = "vw",
                    org_agenda_month_view = "vm",
                    org_agenda_year_view = "vy",
                    org_agenda_quit = "q",
                    org_agenda_switch_to = "<CR>",
                    org_agenda_goto = {"<TAB>"},
                    org_agenda_goto_date = "J",
                    org_agenda_redo = "r",
                    org_agenda_show_help = "?"
                },
                capture = {
                    org_capture_finalize = "<C-c>",
                    org_capture_refile = "<Leader>or",
                    org_capture_kill = "q",
                    org_capture_show_help = "?"
                },
                org = {
                    org_refile = "<Leader>or",
                    org_increase_date = "<C-a>",
                    org_decrease_date = "<C-x>",
                    org_change_date = "cid",
                    org_todo = "cit",
                    org_todo_prev = "ciT",
                    org_toggle_checkbox = "<C-c>",
                    org_open_at_point = "<Leader>oo",
                    org_cycle = "<TAB>",
                    org_global_cycle = "<S-TAB>",
                    org_archive_subtree = "<Leader>o$",
                    org_set_tags_command = "<Leader>ot",
                    org_toggle_archive_tag = "<Leader>oA",
                    org_do_promote = "<<",
                    org_do_demote = ">>",
                    org_promote_subtree = "<s",
                    org_demote_subtree = ">s",
                    org_meta_return = "<Leader><CR>", -- Add headling, item or row
                    org_insert_heading_respect_content = "<Leader>oih", -- Add new headling after current heading block with same level
                    org_insert_todo_heading = "<Leader>oiT", -- Add new todo headling right after current heading with same level
                    org_insert_todo_heading_respect_content = "<Leader>oit", -- Add new todo headling after current heading block on same level
                    org_move_subtree_up = "<Leader>oK",
                    org_move_subtree_down = "<Leader>oJ",
                    org_show_help = "?"
                }
            }
        }
    )

    -- map <silent>gO :e ~/Dropbox/vimwiki/org/todo.org<CR>
    vim.cmd([[command! -nargs=0 NGrep grep! ".*" ~/MrKampang/vimwiki/org/*]])
end

return config
