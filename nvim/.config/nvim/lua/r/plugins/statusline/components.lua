local M = {}

local fn, fmt, icons = vim.fn, string.format, as.ui.icons

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 120
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand "%:p:h"
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local color = vim.api.nvim_get_hl(0, { name = "Normal" })
local bg_filename = string.format("#%06x", color.fg)

local function env_cleanup(venv)
    if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch "([^/]+)" do
            final_venv = w
        end
        venv = final_venv
    end
    return venv
end

local gstatus = { ahead = 0, behind = 0 }
local exclude = {
    ["NvimTree"] = true,
    ["capture"] = true,
    ["dap-repl"] = true,
    ["dap-terminal"] = true,
    ["dapui_breakpoints"] = true,
    ["dapui_console"] = true,
    ["dapui_scopes"] = true,
    ["dapui_stacks"] = true,
    ["dapui_watches"] = true,
    ["help"] = true,
    ["mind"] = true,
    ["neo-tree"] = true,
    ["noice"] = true,
    ["prompt"] = true,
    ["scratch"] = true,
    ["terminal"] = true,
    ["toggleterm"] = true,
    ["TelescopePrompt"] = true,
} -- Ignore float windows and exclude filetype

local function update_gstatus()
    local Job = require "plenary.job"
    Job:new({
        command = "git",
        args = { "rev-parse", "--abbrev-ref", "HEAD" },
        on_exit = function(job, _)
            local head = job:result()[1]
            if not head then
                return
            end
            Job:new({
                command = "git",
                args = {
                    "rev-list",
                    "--left-right",
                    "--count",
                    head .. "...origin/" .. head,
                },
                on_exit = function(_job, _)
                    local res = _job:result()[1]
                    if type(res) ~= "string" then
                        return
                    end
                    local ok, ahead, behind =
                        pcall(string.match, res, "(%d+)%s*(%d+)")
                    if ok then
                        gstatus = { ahead = ahead, behind = behind }
                    end
                end,
            }):start()
        end,
    }):start()
end

if _G.Gstatus_timer == nil then
    _G.Gstatus_timer = vim.loop.new_timer()
else
    _G.Gstatus_timer:stop()
end

_G.Gstatus_timer:start(0, 2000, vim.schedule_wrap(update_gstatus))

-- local function diff_source()
--     ---@diagnostic disable-next-line: undefined-field
--     local gitsigns = vim.b.gitsigns_status_dict
--     if gitsigns then
--         return {
--             added = gitsigns.added,
--             modified = gitsigns.changed,
--             removed = gitsigns.removed,
--         }
--     end
-- end

M.mode = function()
    return {
        function()
            -- local mode_color = {
            --     n = colors.dark_green,
            --     i = colors.blue,
            --     v = colors.dark_green,
            --     [""] = colors.pale_pink,
            --     V = colors.bright_yellow,
            --     -- c = colors.white,
            --     -- no = colors.red,
            --     -- s = colors.orange,
            --     -- S = colors.orange,
            --     -- [""] = colors.orange,
            --     -- ic = colors.yellow,
            --     -- R = colors.violet,
            --     -- Rv = colors.violet,
            --     -- cv = colors.red,
            --     -- ce = colors.red,
            --     -- r = colors.cyan,
            --     -- rm = colors.cyan,
            --     -- ["r?"] = colors.cyan,
            --     -- ["!"] = colors.red,
            --     -- t = colors.red,
            -- }

            local alias =
                { n = "N", i = "I", c = "C", V = "V", [""] = "V", t = "T" }
            return fmt("   %s", alias[vim.fn.mode()])
        end,
        color = { gui = "bold" },
    }
end
M.branch = function()
    return {
        "branch",
        icon = "",
        color = { gui = "bold" },
        cond = conditions.hide_in_width,
    }
end
M.diff = function()
    return {
        "diff",

        symbols = {
            added = icons.git.add,
            modified = icons.git.mod,
            removed = icons.git.remove,
        },

        source = function()
            ---@diagnostic disable-next-line: undefined-field
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                }
            end
        end,
        cond = conditions.hide_in_width,
    }
end
M.diffbranch = function()
    return {
        function()
            return gstatus.ahead .. " " .. gstatus.behind .. ""
        end,
        color = {},
    }
end
M.filetype = function()
    return {
        "filetype",
    }
end
M.filename = function()
    return {
        -- "filename",
        -- symbols = {
        --     modified = "",
        --     readonly = "",
        -- },
        function()
            local filepath =
                vim.api.nvim_exec2("echo expand('%:p')", { output = true })

            local prefix = ""

            if filepath.output:find("fugitive", 1, true) == 1 then
                prefix = "[fugitive]:"
            elseif filepath.output:find("diffview", 1, true) then
                prefix = "[diffview]:"
            end

            return fmt("%s%s/%s", prefix, fn.expand "%:p:h:t", fn.expand "%:t")
        end,
        color = { gui = "italic,bold", bg = bg_filename, fg = "black" },
    }
end
M.file_modified = function()
    return {
        function()
            local modified = vim.bo[0].modified
            local nomodified = vim.bo[0].readonly

            local ft_modified = ""

            if modified then
                ft_modified = " ✘ "
            elseif nomodified then
                ft_modified = "  "
            else
                ft_modified = " "
            end
            return ft_modified
        end,
        padding = { left = 0 },
        color = { fg = "red" },
    }
end
M.location = function()
    return {
        "location",
    }
end
M.location_mod = function()
    return {
        function()
            local rhs = ""

            if vim.fn.winwidth(0) > 80 then
                local column = vim.fn.virtcol "."
                local width = vim.fn.virtcol "$"
                local line = vim.api.nvim_win_get_cursor(0)[1]
                local height = vim.api.nvim_buf_line_count(0)

                -- Add padding to stop RHS from changing too much as we move the cursor.
                local padding = #tostring(height) - #tostring(line)
                if padding > 0 then
                    rhs = rhs .. (" "):rep(padding)
                end

                rhs = rhs .. "ℓ " -- (Literal, \u2113 "SCRIPT SMALL L").
                rhs = rhs .. line
                rhs = rhs .. "/"
                rhs = rhs .. height
                rhs = rhs .. " 𝚌 " -- (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
                rhs = rhs .. column
                rhs = rhs .. "/"
                rhs = rhs .. width
                rhs = rhs .. " "

                -- Add padding to stop rhs from changing too much as we move the cursor.
                if #tostring(column) < 2 then
                    rhs = rhs .. " "
                end
                if #tostring(width) < 2 then
                    rhs = rhs .. " "
                end
            end

            return rhs
        end,
    }
end
M.progress = function()
    return {
        "progress",
        -- color = { fg = col_fg, gui = "bold" }
    }
end
M.diagnostics = function()
    return {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
            error = icons.diagnostics.error,
            warn = icons.diagnostics.warn,
            info = icons.diagnostics.info,
            hint = icons.diagnostics.hint,
        },
    }
end
M.mid_sec = function()
    return {
        function()
            -- make center statusline
            return "%="
        end,
    }
end
M.treesitter = function()
    return {
        function()
            local b = vim.api.nvim_get_current_buf()
            if next(vim.treesitter.highlighter.active[b]) then
                return ""
            end
            return ""
        end,
        color = { fg = "green" },
        cond = conditions.hide_in_width,
    }
end
M.python_env = function()
    return {
        function()
            if vim.bo.filetype == "python" then
                local venv = os.getenv "CONDA_DEFAULT_ENV"
                if venv then
                    return fmt("  (%s)", env_cleanup(venv))
                end
                venv = os.getenv "VIRTUAL_ENV"
                if venv then
                    return fmt("  (%s)", env_cleanup(venv))
                end
                return ""
            end
            return ""
        end,
        -- cond = conditions.hide_in_width,
    }
end
M.clock = function()
    return {
        function()
            return " " .. os.date "%H:%M"
        end,
        color = { fg = "white", gui = "bold" },
    }
end
M.sessions = function()
    return {
        function()
            local sess = require("nvim-possession").status()
            if sess ~= nil then
                return "%#Mymisc_fg#"
            else
                return ""
            end
        end,
        -- cond = conditions.hide_in_width,
    }
end
M.root_dir = function()
    return {
        function()
            local HAVE_GITSIGNS = pcall(require, "gitsigns")

            ---@diagnostic disable-next-line: undefined-field
            local status = vim.b.gitsigns_status_dict or nil

            local root_path = ""
            if not HAVE_GITSIGNS or status == nil or status["root"] == nil then
                root_path = ""
            else
                root_path = status["root"]
            end

            if #root_path > 0 then
                root_path = "[" .. vim.fs.basename(root_path) .. "]"
            end

            return root_path
        end,
        cond = conditions.hide_in_width,
    }
end
M.get_lsp_client_notify = function()
    return {
        function(msg)
            msg = msg or ""
            local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }

            if next(buf_clients) == nil then
                if type(msg) == "boolean" or #msg == 0 then
                    return ""
                end
                return msg
            end

            local buf_ft = vim.bo.filetype
            local buf_client_names = {}

            -- add client
            for _, client in pairs(buf_clients) do
                if client.name ~= "null-ls" then
                    table.insert(buf_client_names, client.name)
                end
            end

            -- add formatter
            local lsp_utils = require "r.plugins.lsp.utils"
            local formatters = lsp_utils.list_formatters(buf_ft)
            vim.list_extend(buf_client_names, formatters)

            -- add linter
            local linters = lsp_utils.list_linters(buf_ft)
            vim.list_extend(buf_client_names, linters)

            -- add hover
            local hovers = lsp_utils.list_hovers(buf_ft)
            vim.list_extend(buf_client_names, hovers)

            -- add code action
            local code_actions = lsp_utils.list_code_actions(buf_ft)
            vim.list_extend(buf_client_names, code_actions)

            local hash = {}
            local client_names = {}
            for _, v in ipairs(buf_client_names) do
                if not hash[v] then
                    client_names[#client_names + 1] = v
                    hash[v] = true
                end
            end
            table.sort(client_names)
            return " LSP: " .. table.concat(client_names, ", ") .. " "
        end,
        cond = conditions.hide_in_width,
    }
end
M.term_akinsho = function()
    return {
        function()
            local terms = require "toggleterm.terminal"
            local count_term = terms.get_all()
            if #count_term == 0 then
                return ""
            else
                return fmt("No.%s of ﬑ %s ", as.term_count, #count_term)
            end
        end,
        -- color = { bg = col_bg, fg = col_fg, gui = "bold" },
        -- padding = { right = 0 },
        -- cond = conditions.hide_in_width,
    }
end
M.navic = function()
    return {
        require("nvim-navic").get_location,
        cond = require("nvim-navic").is_available,
        color = { fg = "red" },
        -- colored = true,
    }
end
M.overseer = function()
    return {
        function()
            local ok, overseer = pcall(require, "overseer")
            if not ok then
                return ""
            end

            local tasks = overseer.task_list
            local STATUS = overseer.constants.STATUS
            local symbols = {
                ["FAILURE"] = " ",
                ["CANCELED"] = " ",
                ["SUCCESS"] = " ",
                ["RUNNING"] = "省",
            }

            -- local colors = {
            --     ["FAILURE"] = "red",
            --     ["CANCELED"] = "gray",
            --     ["SUCCESS"] = "green",
            --     ["RUNNING"] = "yellow",
            --     j
            -- }

            local colors = {
                ["FAILURE"] = "GitSignsDelete",
                ["CANCELED"] = "Boolean",
                ["SUCCESS"] = "GitSignsAdd",
                ["RUNNING"] = "GitSignsChange",
            }
            local tasks_by_status = overseer.util.tbl_group_by(
                tasks.list_tasks { unique = true },
                "status"
            )

            for _, status in ipairs(STATUS.values) do
                local status_tasks = tasks_by_status[status]
                if symbols[status] and status_tasks then
                    return "%#" .. colors[status] .. "# " .. symbols[status]
                    -- .. "%##"
                end
            end
            return ""
        end,
        color = { fg = "red" },
    }
end
M.debugger = function()
    return {
        function()
            local ok, dap = pcall(require, "dap")
            if not ok then
                return ""
            end

            local session = dap.session()
            if session == nil then
                return ""
            else
                return ""
            end
        end,
        color = { fg = "red" },
    }
end
M.noice_status = function()
    return {
        require("noice").api.status.search.get,
        cond = require("noice").api.status.search.has,
        color = { fg = "#ff9e64" },
    }
end
M.lazy_updates = function()
    return {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = { fg = "#ff9e64" },
    }
end
M.trailing = function()
    return {

        function()
            if not vim.o.modifiable or exclude[vim.bo.filetype] then
                return ""
            end

            local line_num = nil

            for i = 1, fn.line "$" do
                local linetext = vim.fn.getline(i)
                -- To prevent invalid escape error, we wrap the regex string with `[[]]`.
                local idx = fn.match(linetext, [[\v\s+$]])

                if idx ~= -1 then
                    line_num = i
                    break
                end
            end

            local msg = ""
            if line_num ~= nil then
                msg = fmt("[%d]trailing", line_num)
            end

            return msg
        end,
        color = { fg = "red", gui = "bold" },
    }
end
M.mixindent = function()
    return {

        function()
            if not vim.o.modifiable or exclude[vim.bo.filetype] then
                return ""
            end

            local space_pat = [[\v^ +]]
            local tab_pat = [[\v^\t+]]
            local space_indent = fn.search(space_pat, "nwc")
            local tab_indent = fn.search(tab_pat, "nwc")
            local mixed = (space_indent > 0 and tab_indent > 0)
            local mixed_same_line
            if not mixed then
                mixed_same_line = fn.search([[\v^(\t+ | +\t)]], "nwc")
                mixed = mixed_same_line > 0
            end
            if not mixed then
                return ""
            end
            if mixed_same_line ~= nil and mixed_same_line > 0 then
                return "MI:" .. mixed_same_line
            end
            local space_indent_cnt = fn.searchcount({
                pattern = space_pat,
                max_count = 1e3,
            }).total
            local tab_indent_cnt =
                fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
            if space_indent_cnt > tab_indent_cnt then
                return "MI:" .. tab_indent
            else
                return "MI:" .. space_indent
            end
        end,
        color = { gui = "bold" },
    }
end

return M
