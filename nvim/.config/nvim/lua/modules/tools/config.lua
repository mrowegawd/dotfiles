local config = {}
-- local global = require('core.global')
-- print(global.home)

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
        vim.cmd [[packadd vim-dadbod]]
    end
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
    vim.g.db_ui_save_location = os.getenv("HOME") .. "/.cache/vim/db_ui_queries"
    vim.g.dbs = load_dbs()
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

function config.vim_floaterm()
    vim.g.floaterm_wintype = "float"
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.9
end

function config.vim_dotoo()
    -- vim.g['dotoo#agenda#files']    = {'~/Dropbox/vimwiki/org/*.org'}
    -- vim.g.org_refile                = '~/Dropbox/vimwiki/org/refile.org'

    vim.g["dotoo#agenda#files"] = {"~/MrKampang/vimwiki/org/*.org"}
    vim.g.org_refile = "~/MrKampang/vimwiki/org/refile.org"
    vim.g["dotoo#parser#todo_keywords"] = {
        "TODO",
        "NEXT",
        "SOMEDAY",
        "FIX",
        "WAITING",
        "HOLD",
        "|",
        "CANCELLED",
        "DONE"
    }

    vim.g.org_state_keywords = {"TODO", "NEXT", "SOMEDAY", "DONE", "CANCELLED", "FIX"}
    vim.g.dotoo_headline_highlight_colors = {
        "Title",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Special",
        "Constant"
    }
    vim.g["dotoo#agenda#warning_days"] = "30d"
    -- hi dotoo_shade_stars ctermfg=NONE guifg='#000000'
    -- hi link orgHeading2 Normal
    vim.g.org_time = "%H:%M"
    vim.g.org_date = "%Y-%m-%d %a"
    vim.g.org_date_format = vim.g.org_date .. vim.g.org_time
end

function config.todo_comments()
    require("todo-comments").setup {
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
end

function config.diffview()
    -- body
end

return config
