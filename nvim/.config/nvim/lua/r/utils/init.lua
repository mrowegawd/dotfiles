local api, highlight, fmt, cmd = vim.api, as.highlight, string.format, vim.cmd
local option = api.nvim_buf_get_option
local L = vim.log.levels

local utils = {}

local Job = require "plenary.job"
local scan = require "plenary.scandir"

-------------------------------------------------------------------------------
--- BASE
-------------------------------------------------------------------------------
local vi = false
function utils.toggle_vi()
    if vi then
        vim.o.number = true
        vim.o.relativenumber = true
        vim.o.signcolumn = "yes" -- 'auto'
        vim.o.foldcolumn = "auto:1"
        vim.o.laststatus = 2
        -- if vim.b.hasLsp then
        --     vim.cmd.DefaultDiagnostics()
        -- end
        vim.cmd.IndentBlanklineToggle()

        vi = false
    else
        vim.o.number = false
        vim.o.relativenumber = false
        vim.o.signcolumn = "no"
        vim.o.foldcolumn = "0"
        vim.o.laststatus = 0
        -- if vim.b.hasLsp then
        --     vim.cmd.DisableDiagnostics()
        -- end
        vim.cmd.IndentBlanklineToggle()
        vi = true
    end
end

local function is_vim_list_open()
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        local location_list = vim.fn.getloclist(0, { filewinid = 0 })
        local is_loc_list = location_list.filewinid > 0
        if vim.bo[buf].filetype == "qf" or is_loc_list then
            return true
        end
    end
    return false
end

-- Usage: toggle_list "quickfix" or "location"
local function toggle_list(list_type, kill)
    if kill then
        return cmd [[q]]
    end

    local is_location_target = list_type == "location"
    local cmd_ = is_location_target and { "lclose", "lopen" }
        or { "cclose", "copen" }
    local is_open = is_vim_list_open()
    if is_open then
        return vim.cmd[cmd_[1]]()
    end
    local list = is_location_target and vim.fn.getloclist(0)
        or vim.fn.getqflist()
    if vim.tbl_isempty(list) then
        local msg_prefix = (is_location_target and "Location" or "QuickFix")
        return vim.notify(msg_prefix .. " List is Empty.", vim.log.levels.WARN)
    end

    local winnr = vim.fn.winnr()
    cmd[cmd_[2]]()
    if vim.fn.winnr() ~= winnr then
        cmd.wincmd "p"
    end
end

function utils.toggle_qf()
    toggle_list "quickfix"
end

function utils.toggle_loc()
    toggle_list "location"
end

function utils.toggle_kil_loc_qf()
    toggle_list("none", true)
end

--- Opens the given url in the default browser.
---@param url string: The url to open.
function utils.open_in_browser(url)
    local open_cmd
    if vim.fn.executable "xdg-open" == 1 then
        open_cmd = "xdg-open"
    elseif vim.fn.executable "explorer" == 1 then
        open_cmd = "explorer"
    elseif vim.fn.executable "open" == 1 then
        open_cmd = "open"
    elseif vim.fn.executable "wslview" == 1 then
        open_cmd = "wslview"
    end

    local ret = vim.fn.jobstart({ open_cmd, url }, { detach = true })
    if ret <= 0 then
        vim.notify(
            string.format(
                "[utils]: Failed to open '%s'\nwith command: '%s' (ret: '%d')",
                url,
                open_cmd,
                ret
            ),
            vim.log.levels.ERROR,
            { title = "[tt.utils]" }
        )
    end
end

function utils.Buf_only()
    local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

    local cur = api.nvim_get_current_buf()

    local deleted, modified = 0, 0

    for _, n in ipairs(api.nvim_list_bufs()) do
        -- If the iter buffer is modified one, then don't do anything
        ---@diagnostic disable-next-line: redundant-parameter
        if option(n, "modified") then
            modified = modified + 1

        -- iter is not equal to current buffer
        -- iter is modifiable or del_non_modifiable == true
        -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
        ---@diagnostic disable-next-line: redundant-parameter
        elseif n ~= cur and (option(n, "modifiable") or del_non_modifiable) then
            api.nvim_buf_delete(n, {})
            deleted = deleted + 1
        end
    end

    print(
        "BufOnly: "
            .. deleted
            .. " deleted buffer(s), "
            .. modified
            .. " modified buffer(s)"
    )
end

function utils.EditSnippet()
    local base_snippets = { "package", "global" }

    local ft, _ = as.get_bo_buft()

    if ft == "" then
        return vim.notify("Belum dibuat??", L.WARN, { title = "No snippets" })
    elseif ft == "typescript" then
        ft = "javascript"
    elseif ft == "sh" then
        ft = "shell"
    end

    local ft_snippet_path = as.snippet_path .. "/snippets/"

    local snippets = {}
    local is_file = true

    if as.is_dir(ft_snippet_path .. ft) then
        if not as.exists(ft_snippet_path .. ft) then
            return vim.notify(
                ft_snippet_path .. ft .. ".json",
                L.WARN,
                { title = "Snippet file not exists" }
            )
        end
        -- Untuk akses ke snippet khusus dir harus di tambahkan ext sama `ft` nya
        -- e.g path/ft-nya/<snippet.json>
        ft_snippet_path = ft_snippet_path .. ft .. "/"

        local dirs = scan.scan_dir(
            ft_snippet_path,
            { depth = 1, search_pattern = "json" }
        )
        for _, sp in pairs(dirs) do
            local nm = sp:match "[^/]*.json$"
            local sp_e = nm:gsub(".json", "")
            table.insert(snippets, sp_e)
        end

        for _, sp in pairs(base_snippets) do
            table.insert(snippets, sp)
        end
    else
        snippets = { ft }

        if not as.exists(ft_snippet_path .. ft .. ".json") then
            return vim.notify(
                ft_snippet_path .. ft .. ".json",
                L.WARN,
                { title = "Snippet file not exists" }
            )
        end
        if not as.exists(ft_snippet_path .. ft .. ".json") then
            return vim.notify(
                ft_snippet_path .. ft .. ".json",
                L.WARN,
                { title = "Snippet file not exists" }
            )
        end

        for _, sp in pairs(base_snippets) do
            table.insert(snippets, sp)
        end
    end

    vim.ui.select(snippets, { prompt = "Edit snippet> " }, function(choice)
        if choice == nil then
            return
        end
        if is_file then
            if not as.exists(ft_snippet_path .. choice .. ".json") then
                return vim.notify(
                    ft_snippet_path .. choice .. ".json",
                    L.WARN,
                    { title = "Snippet file not exists" }
                )
            end
            cmd(":edit " .. ft_snippet_path .. choice .. ".json")
        end
    end)
end

function utils.EditOrgTodo()
    local org_todos = { "inbox", "refile" }
    local org_todo_path = as.wiki_path .. "/orgmode/gtd/"

    vim.ui.select(org_todos, { prompt = "Edit OrgTODO's> " }, function(choice)
        if choice == nil then
            return
        end

        if not as.exists(org_todo_path .. choice .. ".org") then
            return vim.notify(
                "Cant find todo path: " .. org_todo_path .. choice .. ".org",
                L.WARN,
                { title = "Todo info" }
            )
        end
        cmd(":edit " .. org_todo_path .. choice .. ".org")
    end)
end

-------------------------------------------------------------------------------
--- GIT
-------------------------------------------------------------------------------
function utils.ListBranches()
    local branches = vim.fn.systemlist [[git branch 2>/dev/null]]
    local new_branch_prompt = "Create new branch"
    table.insert(branches, 1, new_branch_prompt)

    vim.ui.select(branches, {
        prompt = "Git branches",
    }, function(choice)
        if choice == nil then
            return
        end

        if choice == new_branch_prompt then
            -- local new_branch = ""
            vim.ui.input({ prompt = "New branch name:" }, function(branch)
                if branch ~= nil then
                    vim.fn.systemlist("git checkout -b " .. branch)
                end
            end)
        else
            vim.fn.systemlist("git checkout " .. choice)
        end
    end)
end

function utils.GitRemoteSync()
    if not _G.GitStatus then
        _G.GitStatus = { ahead = 0, behind = 0, status = nil }
    end

    -- Fetch the remote repository
    local git_fetch = Job:new {
        command = "git",
        args = { "fetch" },
        on_start = function()
            _G.GitStatus.status = "pending"
        end,
        on_exit = function()
            _G.GitStatus.status = "done"
        end,
    }

    -- Compare local repository to upstream
    local git_upstream = Job:new {
        command = "git",
        args = { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
        on_start = function()
            _G.GitStatus.status = "pending"
            vim.schedule(function()
                vim.api.nvim_exec_autocmds(
                    "User",
                    { pattern = "GitStatusChanged" }
                )
            end)
        end,
        on_exit = function(job, _)
            local res = job:result()[1]
            if type(res) ~= "string" then
                _G.GitStatus = { ahead = 0, behind = 0, status = "error" }
                return
            end
            local _, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")

            _G.GitStatus = {
                ahead = tonumber(ahead),
                behind = tonumber(behind),
                status = "done",
            }
            vim.schedule(function()
                vim.api.nvim_exec_autocmds(
                    "User",
                    { pattern = "GitStatusChanged" }
                )
            end)
        end,
    }

    git_fetch:start()
    git_upstream:start()
end

------------------------------------------------------------------------
--                          Word Processor                            --
------------------------------------------------------------------------
function utils.WordProcessor()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.bo.expandtab = true
    vim.opt_local.spell = true
    vim.opt_local.complete:append "k"
    vim.opt_local.spelllang = { "en_us", "en_gb" }
    -- vim.o.thesaurus = vim.env.XDG_CONFIG_HOME .. "/nvim/thesaurus/mthesaur.txt"
    require("r.mappings.util").wordProcessor()
end

-------------------------------------------------------------------------------
--- LSP Stuff
-------------------------------------------------------------------------------
---Get a table with names of currnetly active language server names
---@return table Active clients
function utils.get_client_names()
    local buf_clients = vim.lsp.get_active_clients()

    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
    end
    return buf_client_names
end

---Get servers from table.
---The variable `dvim.lsp.language_servers` holds all the information needed.
---This function parses that table, and returns the active servers.
function utils.get_servers()
    local servers = {}

    for _, server_object in ipairs(as.lspfiles) do
        print(server_object)
        -- if
        --     pcall(function()
        --         return dvim.builtin.filetypes[server_object.filetype].active
        --             ~= nil
        --     end)
        -- then
        --     Log.trace(
        --         "[LSP] Toggling server for filetype: "
        --             .. server_object.filetype
        --             .. " Server is: ["
        --             .. server_object.server
        --             .. "]"
        --     )
        --     table.insert(servers, server_object.server)
        -- else
        --     Log.error(
        --         "[LSP] Filetype: ["
        --             .. server_object.filetype
        --             .. "] not found in dvim.builtin.filetypes. Please look at the config.lua file."
        --     )
        -- end
    end

    return servers
end
-------------------------------------------------------------------------------
-- Plugin functions
-------------------------------------------------------------------------------

---Write current file and source it within current nvim instance
---@param buf number Bufner to attach mapping to
function utils.write_and_source(buf)
    vim.keymap.set("n", "<F6>", function()
        vim.cmd.write()
        vim.cmd.source "%"
        vim.notify "Sourcing..."
    end, { buffer = buf, desc = "Evaluate current file" })
end

---Get keys with replaced termcodes
---@param key string key sequence
---@param mode string vim-mode for the keymap
function utils.feedkey(key, mode)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(key, true, false, true),
        mode,
        false
    )
end

function utils.disable_ctrl_i_and_o(au_name, tbl_ft)
    local augroup = vim.api.nvim_create_augroup(au_name, { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = tbl_ft,
        group = augroup,
        callback = function()
            vim.keymap.set("n", "<c-i>", "<Nop>", {
                buffer = vim.api.nvim_get_current_buf(),
            })
            vim.keymap.set("n", "<c-o>", "<Nop>", {
                buffer = vim.api.nvim_get_current_buf(),
            })
        end,
    })
end

function utils.YoungTest()
    for i = 1, vim.api.nvim_buf_line_count(0) do
        local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
        print(line)
    end
end

function utils.infoBaseColorsTheme()
    local normal = "Normal"
    local colorcolumn = "ColorColumn"

    local pmenu = "Pmenu"
    local pmenusel = "PmenuSel"

    local winseparator = "WinSeparator"

    local cmpmatchabbr = "CmpItemAbbrMatch"
    local cmpitemabbr = "CmpItemAbbr"
    local cmpitemabbrmatchfuzzy = "CmpItemAbbrMatchFuzzy"

    local normal_bg = highlight.get(normal, "bg")
    local normal_fg = highlight.get(normal, "fg")

    local colorcolumn_bg = highlight.get(colorcolumn, "bg")

    local pmenu_bg = highlight.get(pmenu, "bg")
    local pmenu_fg = highlight.get(pmenu, "fg")

    local pmenusel_bg = highlight.get(pmenusel, "bg")

    local winseparator_bg = highlight.get(winseparator, "bg")
    local winseparator_fg = highlight.get(winseparator, "fg")

    local cmpmatchabbr_fg = highlight.get(cmpmatchabbr, "fg")
    local cmpitemabbr_fg = highlight.get(cmpitemabbr, "fg")

    local cmpmatchabbrfuzzy_fg = highlight.get(cmpitemabbrmatchfuzzy, "fg")

    vim.notify(
        fmt(
            [[
        BG_ACTIVE_WINDOW (Normal) bg: %s
        BG_ACTIVE_WINDOW (Normal) fg: %s

        BACKGROUND_ACTIVE_STATUSLINE (ColorColumn) bg: %s

        FZF_BG (Pmenu) bg: %s
        FZF_FG (Pmenu) fg: %s

        FZF_BG_SELECTION (PmenuSel) bg: %s

        FOREGROUND_WINSEPARATOR (WinSeparator) bg: %s
        FOREGROUND_WINSEPARATOR (WinSeparator) fg: %s


        FZF_BG_MATCH (CmpItemAbbrMatch) fg: %s
        FZF_FG_ITEM (CmpItemAbbr) fg: %s
        FZF_FG_ITEM_FUZZY (CmpItemAbbrMatchFuzzy) fg: %s
            ]],
            normal_bg,
            normal_fg,
            colorcolumn_bg,
            pmenu_bg,
            pmenu_fg,
            pmenusel_bg,
            winseparator_bg,
            winseparator_fg,
            cmpmatchabbr_fg,
            cmpitemabbr_fg,
            cmpmatchabbrfuzzy_fg
        )
    )
end

function utils.infoFoldPreview()
    vim.cmd "options"
end

local function bool2str(bool)
    return bool and "on" or "off"
end

--- Toggle buffer semantic token highlighting for all language servers that support it
---@param bufnr? number the buffer to toggle the clients on
function utils.toggle_buffer_semantic_tokens(bufnr)
    vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false

    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](
                bufnr or 0,
                client.id
            )
            as.info(
                string.format(
                    "Buffer lsp semantic highlighting %s",
                    bool2str(vim.b.semantic_tokens_enabled)
                )
            )
        end
    end
end

return utils
