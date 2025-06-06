-- Since <c-r> is used for blink and <c-r>.. is used for fugitive,
-- to avoid conflicts, it is temporarily disabled.
vim.g.fugitive_no_maps = 1

return {
  -- GH.NVIM
  {
    "ldelossa/gh.nvim",
    cmd = { "GHOpenPR", "GHOpenIssue", "GHSearchIssues" },
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup()
        end,
      },
    },
    config = function()
      require("litee.gh").setup {
        debug_logging = true,
      }
    end,
  },
  -- GIT CONFLICT
  {
    "akinsho/git-conflict.nvim", --- hanya untuk viewer untuk git log, namun bisa di kombinasi dengan fugitive
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictRefresh",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
    keys = {
      {
        "<Leader>gr",
        function()
          vim.cmd [[GitConflictRefresh]]
          RUtils.info("Start or refresh git conflict..", { title = "Git-conflict" })
        end,
        desc = "Git: start/refresh git conflict [gitconflict]",
      },
      {
        "<g-down>",
        "<CMD>GitConflictNextConflict<CR>",
        desc = "Git: next conflict [gitconflict]",
      },
      {
        "<g-up>",
        "<CMD>GitConflictPrevConflict<CR>",
        desc = "Git: prev conflict [gitconflict]",
      },
    },
    opts = {
      default_commands = true, -- disable commands created by this plugin
    },
  },
  -- GITLINKER
  {
    "ruifm/gitlinker.nvim", -- generate shareable file permalinks
    keys = {
      {
        "<Leader>goo",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        mode = { "n", "v" },
        desc = "Open: gitlink on browser (normal or visual) [gitlinker]",
      },
      {
        "<Leader>goO",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        desc = "Open: gitlink on browser [gitlinker]",
      },
      {
        "<Leader>gy",
        desc = "Git: copy hash link [gitlinker]",
      },
    },
    opts = { mappings = "<Leader>gy" },
  },
  -- OCTO
  {
    -- Sebelum menggunakannya: run command ini di cli "gh auth login --scopes read:project"
    "pwntester/octo.nvim",
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = function()
      return {
        picker = "snacks",
        -- picker = "fzf-lua",
        picker_config = {
          mappings = {
            -- open_in_browser = { lhs = "<Leader>bo", desc = "open issue in browser" },
            goto_file = { lhs = "<CR>", desc = "got to file" },
            -- copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            -- checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
            -- merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
          },
        },
        suppress_missing_scope = {
          projects_v2 = true,
        },
        mappings = {
          discussion = {
            copy_url = { lhs = "<space>gy", desc = "copy url to system clipboard" },
            add_comment = { lhs = "<localleader>ca", desc = "add comment" },
            delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
            add_label = { lhs = "<localleader>la", desc = "add label" },
            remove_label = { lhs = "<localleader>ld", desc = "remove label" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
          },
          issue = {
            close_issue = { lhs = "<space>ic", desc = "issue - close issue [octo]" },
            reopen_issue = { lhs = "<space>io", desc = "issue - reopen issue [octo]" },
            list_issues = { lhs = "<space>il", desc = "issue - list open issues on same repo [octo" },
            reload = { lhs = "<C-r>", desc = "issue - reload issue [octo]" },
            open_in_browser = { lhs = "<space>go", desc = "issue - open issue in browser [octo]" },
            copy_url = { lhs = "<space>gy", desc = "issue - copy url to system clipboard [octo]" },
            add_assignee = { lhs = "<space>aa", desc = "issue - add assignee [octo]" },
            remove_assignee = { lhs = "<space>ad", desc = "issue - remove assignee [octo]" },
            create_label = { lhs = "<space>lc", desc = "issue - create label [octo]" },
            add_label = { lhs = "<space>la", desc = "issue - add label [octo]" },
            remove_label = { lhs = "<space>ld", desc = "issue - remove label [octo]" },
            goto_issue = { lhs = "<space>gi", desc = "issue - navigate to a local repo issue [octo]" },
            add_comment = { lhs = "<space>ca", desc = "issue - add comment [octo]" },
            delete_comment = { lhs = "<space>cd", desc = "issue - delete comment [octo]" },
            -- next_comment = { lhs = "", desc = "issue - go to next comment [octo]" },
            -- prev_comment = { lhs = "", desc = "issue - go to previous comment [octo]" },
            react_hooray = { lhs = "<space>rp", desc = "issue - add/remove 🎉 reaction [octo]" },
            react_heart = { lhs = "<space>rh", desc = "issue - add/remove ❤️ reaction [octo]" },
            react_eyes = { lhs = "<space>re", desc = "issue - add/remove 👀 reaction [octo]" },
            react_thumbs_up = { lhs = "<space>r+", desc = "issue - add/remove 👍 reaction [octo]" },
            react_thumbs_down = { lhs = "<space>r-", desc = "issue - add/remove 👎 reaction [octo]" },
            react_rocket = { lhs = "<space>rr", desc = "issue - add/remove 🚀 reaction [octo]" },
            react_laugh = { lhs = "<space>rl", desc = "issue - add/remove 😄 reaction [octo]" },
            react_confused = { lhs = "<space>rc", desc = "issue - add/remove 😕 reaction [octo]" },
          },
          pull_request = {
            checkout_pr = { lhs = "<space>po", desc = "pull request - checkout PR [octo]" },
            merge_pr = { lhs = "<space>pm", desc = "pull request - merge commit PR [octo]" },
            squash_and_merge_pr = { lhs = "<space>psm", desc = "pull request - squash and merge PR [octo]" },
            rebase_and_merge_pr = { lhs = "<space>prm", desc = "pull request - rebase and merge PR [octo]" },
            list_commits = { lhs = "<space>pc", desc = "pull request - list PR commits [octo]" },
            list_changed_files = { lhs = "<space>pf", desc = "pull request - list PR changed files [octo]" },
            show_pr_diff = { lhs = "<space>pd", desc = "pull request - show PR diff [octo]" },
            add_reviewer = { lhs = "<space>va", desc = "pull request - add reviewer [octo]" },
            remove_reviewer = { lhs = "<space>vd", desc = "pull request - remove reviewer request [octo]" },
            close_issue = { lhs = "<space>ic", desc = "pull request - close PR [octo]" },
            reopen_issue = { lhs = "<space>io", desc = "pull request - reopen PR [octo]" },
            list_issues = { lhs = "<space>il", desc = "pull request - list open issues on same repo [octo]" },
            reload = { lhs = "R", desc = "pull request - reload PR [octo]" },
            open_in_browser = { lhs = "<space>go", desc = "pull request - open PR in browser [octo]" },
            copy_url = { lhs = "<space>gy", desc = "pull request - copy url to system clipboard [octo]" },
            goto_file = { lhs = "gf", desc = "pull request - go to file [octo]" },
            add_assignee = { lhs = "<space>aa", desc = "pull request - add assignee [octo]" },
            remove_assignee = { lhs = "<space>ad", desc = "pull request - remove assignee [octo]" },
            create_label = { lhs = "<space>lc", desc = "pull request - create label [octo]" },
            add_label = { lhs = "<space>la", desc = "pull request - add label [octo]" },
            remove_label = { lhs = "<space>ld", desc = "pull request - remove label [octo]" },
            goto_issue = { lhs = "<space>gi", desc = "pull request - navigate to a local repo issue [octo]" },
            add_comment = { lhs = "<space>ca", desc = "pull request - add comment [octo]" },
            delete_comment = { lhs = "<space>cd", desc = "pull request - delete comment [octo]" },
            -- next_comment = { lhs = "<c-n>", desc = "pull request - go to next comment [octo]" },
            -- prev_comment = { lhs = "<c-p>", desc = "pull request - go to previous comment [octo]" },
            react_hooray = { lhs = "<space>rp", desc = "pull request - add/remove 🎉 reaction [octo]" },
            react_heart = { lhs = "<space>rh", desc = "pull request - add/remove ❤️ reaction [octo]" },
            react_eyes = { lhs = "<space>re", desc = "pull request - add/remove 👀 reaction [octo]" },
            react_thumbs_up = { lhs = "<space>r+", desc = "pull request - add/remove 👍 reaction [octo]" },
            react_thumbs_down = { lhs = "<space>r-", desc = "pull request - add/remove 👎 reaction [octo]" },
            react_rocket = { lhs = "<space>rr", desc = "pull request - add/remove 🚀 reaction [octo]" },
            react_laugh = { lhs = "<space>rl", desc = "pull request - add/remove 😄 reaction [octo]" },
            react_confused = { lhs = "<space>rc", desc = "pull request - add/remove 😕 reaction [octo]" },
            review_start = { lhs = "<space>vs", desc = "pull request - start a review for the current PR [octo]" },
            review_resume = {
              lhs = "<space>vr",
              desc = "pull request - resume a pending review for the current PR [octo]",
            },
          },
          review_thread = {
            goto_issue = { lhs = "<space>gi", desc = "review thread - navigate to a local repo issue [octo]" },
            add_comment = { lhs = "<space>ca", desc = "review thread - add comment [octo]" },
            add_suggestion = { lhs = "<space>sa", desc = "review thread - add suggestion [octo]" },
            delete_comment = { lhs = "<space>cd", desc = "review thread - delete comment [octo]" },
            -- next_comment = { lhs = "<c-n>", desc = "review thread - go to next comment [octo]" },
            -- prev_comment = { lhs = "<c-p>", desc = "review thread - go to previous comment [octo]" },
            select_next_entry = { lhs = "]q", desc = "review thread - move to next changed file [octo]" },
            select_prev_entry = { lhs = "[q", desc = "review thread - move to previous changed file [octo]" },
            select_first_entry = { lhs = "[Q", desc = "review thread - move to first changed file [octo]" },
            select_last_entry = { lhs = "]Q", desc = "review thread - move to last changed file [octo]" },
            close_review_tab = { lhs = "<C-c>", desc = "review thread - close review tab [octo]" },
            react_hooray = { lhs = "<space>rp", desc = "review thread - add/remove 🎉 reaction [octo]" },
            react_heart = { lhs = "<space>rh", desc = "review thread - add/remove ❤️ reaction [octo]" },
            react_eyes = { lhs = "<space>re", desc = "review thread - add/remove 👀 reaction [octo]" },
            react_thumbs_up = { lhs = "<space>r+", desc = "review thread - add/remove 👍 reaction [octo]" },
            react_thumbs_down = { lhs = "<space>r-", desc = "review thread - add/remove 👎 reaction [octo]" },
            react_rocket = { lhs = "<space>rr", desc = "review thread - add/remove 🚀 reaction [octo]" },
            react_laugh = { lhs = "<space>rl", desc = "review thread - add/remove 😄 reaction [octo]" },
            react_confused = { lhs = "<space>rc", desc = "review thread - add/remove 😕 reaction [octo]" },
          },
          submit_win = {
            approve_review = { lhs = "<C-a>", desc = "submit win - approve review [octo]" },
            comment_review = { lhs = "<C-m>", desc = "submit win - comment review [octo]" },
            request_changes = { lhs = "<C-r>", desc = "submit win - request changes review [octo]" },
            close_review_tab = { lhs = "<C-c>", desc = "submit win - close review tab [octo]" },
          },
          review_diff = {
            submit_review = { lhs = "<space>vs", desc = "review diff - submit review [octo]" },
            discard_review = { lhs = "<space>vd", desc = "review diff - discard review [octo]" },
            add_review_comment = { lhs = "<space>ca", desc = "review diff - add a new review comment [octo]" },
            add_review_suggestion = { lhs = "<space>sa", desc = "review diff - add a new review suggestion [octo]" },
            focus_files = { lhs = "<space>e", desc = "review diff - move focus to changed file panel [octo]" },
            toggle_files = { lhs = "<space>b", desc = "review diff - hide/show changed files panel [octo]" },
            next_thread = { lhs = "]t", desc = "review diff - move to next thread [octo]" },
            prev_thread = { lhs = "[t", desc = "review diff - move to previous thread [octo]" },
            select_next_entry = { lhs = "]q", desc = "review diff - move to next changed file [octo]" },
            select_prev_entry = { lhs = "[q", desc = "review diff - move to previous changed file [octo]" },
            select_first_entry = { lhs = "[Q", desc = "review diff - move to first changed file [octo]" },
            select_last_entry = { lhs = "]Q", desc = "review diff - move to last changed file [octo]" },
            close_review_tab = { lhs = "<C-c>", desc = "review diff - close review tab [octo]" },
            toggle_viewed = { lhs = "<space><space>", desc = "review diff - toggle viewer viewed state [octo]" },
            goto_file = { lhs = "gf", desc = "review diff - go to file [octo]" },
          },
          file_panel = {
            submit_review = { lhs = "<space>vs", desc = "file panel - submit review [octo]" },
            discard_review = { lhs = "<space>vd", desc = "file panel - discard review [octo]" },
            next_entry = { lhs = "j", desc = "file panel - move to next changed file [octo]" },
            prev_entry = { lhs = "k", desc = "file panel - move to previous changed file [octo]" },
            select_entry = { lhs = "<cr>", desc = "file panel - show selected changed file diffs [octo]" },
            refresh_files = { lhs = "R", desc = "file panel - refresh changed files panel [octo]" },
            focus_files = { lhs = "<space>e", desc = "file panel - move focus to changed file panel [octo]" },
            toggle_files = { lhs = "<space>b", desc = "file panel - hide/show changed files panel [octo]" },
            select_next_entry = { lhs = "]q", desc = "file panel - move to next changed file [octo]" },
            select_prev_entry = { lhs = "[q", desc = "file panel - move to previous changed file [octo]" },
            select_first_entry = { lhs = "[Q", desc = "file panel - move to first changed file [octo]" },
            select_last_entry = { lhs = "]Q", desc = "file panel - move to last changed file [octo]" },
            close_review_tab = { lhs = "<C-c>", desc = "file panel - close review tab [octo]" },
            toggle_viewed = { lhs = "<space><space>", desc = "file panel - toggle viewer viewed state [octo]" },
          },
          repo = {},
        },
      }
    end,
  },
  -- OCTO
  {
    "pwntester/octo.nvim",
    optional = true,
    opts = function(_, opts)
      vim.treesitter.language.register("markdown", "octo")
      if RUtils.has "snacks.nvim" then
        opts.picker = "snacks"
      elseif RUtils.has "telescope.nvim" then
        opts.picker = "telescope"
      elseif RUtils.has "fzf-lua" then
        opts.picker = "fzf-lua"
      else
        ---@diagnostic disable-next-line: undefined-field
        RUtils.error "`octo.nvim` requires `telescope.nvim` or `fzf-lua`"
      end

      -- Keep some empty windows in sessions
      vim.api.nvim_create_autocmd("ExitPre", {
        group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
        ---@diagnostic disable-next-line: unused-local
        callback = function(ev)
          local keep = { "octo" }
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.tbl_contains(keep, vim.bo[buf].filetype) then
              vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
            end
          end
        end,
      })
    end,
  },
  -- GITSIGNS
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs_staged_enable = false,
      -- debug_mode = true,
      attach_to_untracked = true,
      signs_staged = {
        add = { text = "▌" }, --  "▎" "▌" "┆"
        change = { text = "▌" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signs = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function()
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- local function visual_operation(operator)
        --   local visual_range = { start_pos = vim.fn.line "v", end_pos = vim.fn.line "." }
        --   if visual_range.start_pos > visual_range.end_pos then
        --     local tmp = visual_range.start_pos
        --     visual_range.start_pos = visual_range.end_pos
        --     visual_range.end_pos = tmp
        --     gs[operator] { visual_range.start_pos, visual_range.end_pos }
        --   end
        -- end

        -- Hunk
        map("n", "<Leader>ghs", gs.stage_hunk, "Hunk: stage [gitsigns]")
        map("v", "<Leader>ghs", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.stage_hunk { from, to }
        end, "Hunk: stage (visual) [gitsigns]")
        map("n", "<Leader>ghr", gs.reset_hunk, "Hunk: reset [gitsigns]")
        map("v", "<Leader>ghr", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.reset_hunk { from, to }
        end, "Hunk: reset (visual) [gitsigns]")
        map("n", "<Leader>ghu", gs.undo_stage_hunk, "Hunk: undo [gitsigns]")
        map("n", "<Leader>ghS", gs.stage_buffer, "Hunk: stage buffer [gitsigns]")
        map("n", "<Leader>ghR", gs.reset_buffer, "Hunk: reset buffer [gitsigns]")
        map("n", "<Leader>ghi", gs.preview_hunk_inline, "Hunk: preview hunk inline [gitsigns]")

        -- Hunk preview
        map("n", "<Leader>ghp", gs.preview_hunk, "Hunk: preview hunk [gitsigns]")
        map("n", "<Leader>ghP", gs.preview_hunk, "Hunk: preview hunk [gitsigns]")

        -- Toggle
        map("n", "<Leader>gub", function()
          gs.blame()
        end, "Toggle: git blame [gitsigns]")
        map("n", "<Leader>gud", gs.toggle_deleted, "Toggle: git deleted [gitsigns]")
        map("n", "<Leader>guw", gs.toggle_word_diff, "Toggle: word diff [gitsigns]")

        -- Sending to qf
        map("n", "<Leader>xG", function()
          gs.setqflist "all"
          local is_qf_trouble = RUtils.cmd.windows_is_opened { "trouble" }
          vim.schedule(function()
            if is_qf_trouble.found then
              vim.api.nvim_set_current_win(is_qf_trouble.winid)
            end
          end)
        end, "Exec: git hunks all quickfix [gitsigns] [trouble]")
        map("n", "<Leader>xg", function()
          gs.setqflist()
          vim.schedule(function()
            local is_qf_trouble = RUtils.cmd.windows_is_opened { "trouble" }
            if is_qf_trouble.found then
              vim.api.nvim_set_current_win(is_qf_trouble.winid)
            end
          end)
        end, "Exec: git hunks quickfix (qf) [gitsigns] [trouble]")

        -- Jump next/prev between hunks
        map("n", "gn", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            vim.schedule(function()
              gs.nav_hunk(
                "next",
                { navigation_message = false, foldopen = true }
                -- function() vim.fn.feedkeys("zz", "n") end
              )
            end)
          end
        end, "Git: next hunk [gitsigns]")
        map("n", "gp", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            vim.schedule(function()
              gs.nav_hunk(
                "prev",
                { navigation_message = false, foldopen = true }
                -- function() vim.fn.feedkeys("zz", "n") end
              )
            end)
          end
        end, "Git: last hunk [gitsigns]")
      end,
    },
  },
  -- FUGITIVE
  {
    "tpope/vim-fugitive",
    cmd = { "G", "GitHistory", "Git", "Gedit", "GBrowse", "Gwrite", "GitEditDiff", "GitEditChanged", "Gclog", "GcLog" },
    keys = {
      {
        "<Leader>gN",
        "<Cmd>botright Git<CR><Cmd>wincmd J<bar>20 wincmd _<CR>4j",
        desc = "Git: open fugitive [fugitive]",
      },
    },
    dependencies = { "tpope/vim-rhubarb" },
    config = function()
      vim.cmd "command! GitHistory Git! log -- %"

      ---@param callback fun(err?: string, ref?: string)
      local function merge_base(ref1, ref2, callback)
        ref1 = ref1 or "origin/master"
        ref2 = ref2 or "HEAD"
        local stdout = ""
        vim.fn.jobstart({ "git", "merge-base", ref1, ref2 }, {
          stdout_buffered = true,
          on_stdout = function(_, data, _)
            stdout = vim.trim(table.concat(data, "\n"))
          end,
          on_exit = function(_, code)
            if code ~= 0 then
              return callback "Error"
            else
              callback(nil, stdout)
            end
          end,
        })
      end

      ---@param files string[]
      local function open_files(files)
        vim.cmd.tabnew()
        for _, file in ipairs(files) do
          vim.cmd.edit { args = { file } }
        end
      end

      local function get_git_root()
        local root = vim.fs.find(".git", { upward = true })[1]
        if not root then
          return nil
        end
        return vim.fs.dirname(root)
      end

      local function run_files_cmd(cmd, callback)
        local root = get_git_root()
        if not root then
          return callback {}
        end
        local stdout = {}
        vim.fn.jobstart(cmd, {
          stdout_buffered = true,
          on_stdout = function(_, data, _)
            vim.list_extend(stdout, data)
          end,
          on_exit = function(_, code)
            if code ~= 0 then
              return callback {}
            end
            local ret = {}
            for _, name in ipairs(stdout) do
              local fullname = root .. "/" .. name
              if vim.fn.filereadable(fullname) == 1 then
                table.insert(ret, fullname)
              end
            end
            callback(ret)
          end,
        })
      end

      vim.api.nvim_create_user_command("GitEditChanged", function()
        run_files_cmd({ "git", "diff", "--name-only" }, function(files)
          if vim.tbl_isempty(files) then
            vim.notify("No uncommitted changes", vim.log.levels.INFO)
            return
          end
          open_files(files)
        end)
      end, {
        desc = "Edit files with uncommitted changes",
      })

      -- vim.api.nvim_create_autocmd("FileType", {
      --   group = vim.api.nvim_create_augroup("ps_fugitive", { clear = true }),

      RUtils.cmd.augroup("ps_fugitive", {
        event = "FileType",
        pattern = { "fugitive" }, -- gstatus
        command = function(e)
          -- Options
          vim.opt_local.winfixheight = true
          vim.opt_local.winfixbuf = true
          -- Mappings
          vim.keymap.set("n", "<c-n>", "]m", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<c-p>", "[m", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<a-n>", "]m=zt", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<a-p>", "[m=zt", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<tab>", "=zt", { buffer = e.buf, remap = true })

          -- vim.keymap.set("n", "ci", "<Cmd>Git commit -n<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gp", "<Cmd>Git push<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gF", "<Cmd>Git push --force-with-lease<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gP", "<Cmd>Git pull<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gl", function()
            vim.cmd "Git log --oneline"
          end, { buffer = e.buf })
        end,
      }, {
        event = "BufWinEnter",
        pattern = "*.git/COMMIT_EDITMSG",
        command = function()
          -- If it's a new commit, start in insert mode, otherwise start in normal mode
          if vim.fn.getline(1) == "" then
            vim.cmd "15 wincmd _"
            vim.cmd "normal! gg0"
            if vim.fn.getline "." == "" then
              vim.cmd "startinsert"
            end
          end
        end,
      })

      vim.api.nvim_create_user_command("GitEditDiff", function()
        merge_base(nil, nil, function(err, ref)
          if err or not ref then
            vim.notify("Error calculating merge base", vim.log.levels.ERROR)
            return
          end
          run_files_cmd({ "git", "diff", "--name-only", ref }, function(files)
            if vim.tbl_isempty(files) then
              vim.notify("No diff from master", vim.log.levels.INFO)
              return
            end
            open_files(files)
          end)
        end)
      end, {
        desc = "Edit files that differ from master",
      })
    end,
  },
  -- DIFFVIEW
  {
    "sindrets/diffview.nvim",
    event = "LazyFile",
    keys = {
      {
        "<Leader>god",
        "<CMD>DiffviewOpen<CR>",
        desc = "Open: diff view git [diffview]",
      },
      {
        "<Leader>goD",
        "<CMD>DiffviewFileHistory<CR>",
        desc = "Open: diff view file history git [diffview]",
      },
      {
        "<Leader>gv",
        function()
          local current_line = vim.fn.line "."
          local file = vim.fn.expand "%"
          -- DiffviewFileHistory --follow -L{current_line},{current_line}:{file}
          local str_cmds = string.format("DiffviewFileHistory --follow -L%s,%s:%s", current_line, current_line, file)
          vim.cmd(str_cmds)
        end,
        desc = "Git: line hash history [diffview]",
      },
      {
        "<Leader>gv",
        function()
          local function exit_visual_mode()
            -- Exit visual mode, otherwise `getpos` will return postion of the last visual selection
            local ESC_FEEDKEY = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
            vim.api.nvim_feedkeys("gv", "x", false)
            vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
          end

          local function get_visual_selection_info()
            exit_visual_mode()

            local _, start_row, start_col, _ = unpack(vim.fn.getpos "'<")
            local _, end_row, end_col, _ = unpack(vim.fn.getpos "'>")
            start_row = start_row - 1
            end_row = end_row - 1

            return {
              start_row = start_row,
              start_col = start_col,
              end_row = end_row,
              end_col = end_col,
            }
          end

          local v = get_visual_selection_info()
          local file = vim.fn.expand "%"
          -- DiffviewFileHistory --follow -L{range_start},{range_end}:{file}
          local str_cmds =
            string.format("DiffviewFileHistory --follow -L%s,%s:%s", v.start_row + 1, v.end_row + 1, file)
          vim.cmd(str_cmds)
        end,
        mode = "v",
        desc = "Git: line hash history [diffview]",
      },
    },
    opts = function()
      local actions = require "diffview.actions"
      RUtils.disable_ctrl_i_and_o("NoDiffview", { "DiffviewFiles", "DiffviewFileHistory" })

      return {
        enhanced_diff_hl = true,
        diff_binaries = false, -- Show diffs for binaries
        hooks = {
          ---@diagnostic disable-next-line: unused-local
          diff_buf_win_enter = function(bufnr, winid, ctx)
            -- Turn off cursor line for diffview windows because of bg conflict
            -- https://github.com/neovim/neovim/issues/9800
            vim.wo[winid].culopt = "number"
          end,
        },
        key_bindings = {
          disable_defaults = true, -- Disable the default key bindings
          --stylua: ignore
          view = {
            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview]" } },

            { "n", "[F", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview]" } },
            { "n", "]F", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview]" } },

            { "n", "h", false },

            { "n", "gf", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview]" } },
            { "n", "ss", actions.goto_file_split, { desc = "Git: open the file in a new split [diffview]" } },
            { "n", "st", actions.goto_file_tab, { desc = "Git: open the file in a new tabpage [diffview]" } },
            { "n", "tn", actions.goto_file_tab, { desc = "Git: open the file in a new tabpage [diffview]" } },

            { "n", "<Leader>E", actions.focus_files, { desc = "Git: bring focus to the file panel [diffivew]" } },
            { "n", "<Leader>e", actions.toggle_files, { desc = "Git: toggle the file panel [diffivew]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle through available layouts [diffview]" } },

            { "n", "<Leader>gp", actions.prev_conflict, { desc = "Git: in the merge-tool: jump to the previous conflict [diffview]" } },
            { "n", "<Leader>gn", actions.next_conflict, { desc = "Git: in the merge-tool: jump to the next conflict [diffview]" } },

            { "n", "<Leader>co", actions.conflict_choose "ours", { desc = "Git: choose the OURS version of a conflict [diffview]" } },
            { "n", "<Leader>ct", actions.conflict_choose "theirs", { desc = "Git: choose the THEIRS version of a conflict [diffview]" }, },
            { "n", "<Leader>cb", actions.conflict_choose "base", { desc = "Git: choose the BASE version of a conflict [diffview]" } },
            { "n", "<Leader>ca", actions.conflict_choose "all", { desc = "Git: choose all the versions of a conflict [diffview]" } },

            { "n", "dx", actions.conflict_choose "none", { desc = "Git: delete the conflict region [diffview]" } },
            { "n", "dX", actions.conflict_choose_all "none", { desc = "Git: delete the conflict region for the whole file [diffview]" }, },

            { "n", "<Leader>cO", actions.conflict_choose_all "ours", { desc = "Git: choose the OURS version of a conflict for the whole file [diffview]" }, },
            { "n", "<Leader>cT", actions.conflict_choose_all "theirs", { desc = "Git: choose the THEIRS version of a conflict for the whole file [diffview]" }, },
            { "n", "<Leader>cB", actions.conflict_choose_all "base", { desc = "Git: choose the BASE version of a conflict for the whole file [diffview]" }, },
            { "n", "<Leader>cA", actions.conflict_choose_all "all", { desc = "Git: choose all the versions of a conflict for the whole file [diffview]" }, },
          },
          --stylua: ignore
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: cursor down [diffview]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: cursor down [diffview]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: cursor up [diffview]" }, },
            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview]" }, },
            { "n", "<cr>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },
            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },
            -- { "n", "l", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },
            { "n", "h", false },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },

            { "n", "-", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview]" }, },
            { "n", "s", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview]" }, },
            { "n", "u", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview]" }, },

            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview]" } },

            -- Git: stage, unstage, restore, commit
            -- { "n", "<Leader>ghs", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview]" }, },
            -- { "n", "<Leader>ghS", actions.stage_all, { desc = "Git: stage all entries [diffview]" } },
            -- { "n", "<Leader>ghR", actions.unstage_all, { desc = "Git: unstage all entries [diffview]" } },
            -- { "n", "<Leader>ghr", actions.restore_entry, { desc = "Git: restore entry to the state on the left side [diffview]" }, },
            { "n", "cc", "<Cmd>Git commit <bar> wincmd J<CR>", { desc = "Git: commit staged changes with fugitive [diffview]" }, },
            { "n", "ca", "<Cmd>Git commit --amend <bar> wincmd J<CR>", { desc = "Git: amend the last commit with fugitive [diffview]" }, },

            { "n", "L", actions.open_commit_log, { desc = "Git: open the commit log panel [diffivew]" } },

            { "n", "zo", actions.open_fold, { desc = "Git: expand fold [diffview]" } },
            { "n", "zO", actions.open_all_folds, { desc = "Git: expand all folds [diffview]" } },
            { "n", "zc", actions.close_fold, { desc = "Git: collapse fold [diffview]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold [diffview]" } },
            { "n", "zm", actions.close_all_folds, { desc = "Git: collapse all folds [diffview]" } },
            { "n", "zM", actions.close_all_folds, { desc = "Git: collapse all folds [diffview]" } },

            { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview]" } },
            { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview]" } },
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview]" } },
            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview]" }, },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous file [diffview]" }, },

            { "n", "gg", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview]" }, },
            { "n", "G", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview]" }, },

            { "n", "gf", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview]" }, },
            { "n", "ss", actions.goto_file_split, { desc = "Git: open the file in a new split [diffview]" }, },
            { "n", "st", actions.goto_file_tab, { desc = "Git: open the file in a new tabpag [diffview]" }, },
            { "n", "tn", actions.goto_file_tab, { desc = "Git: open the file in a new tabpag [diffview]" }, },

            { "n", "i", actions.listing_style, { desc = "Git: toggle between 'list' and 'tree' views [diffview]" }, },
            { "n", "f", actions.toggle_flatten_dirs, { desc = "Git: flatten empty subdirectories in tree listing style [diffview]" }, },

            { "n", "R", actions.refresh_files, { desc = "Git: update stats and entries in the file list [diffview]" }, },

            { "n", "<Leader>E", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview]" }, },
            { "n", "<Leader>e", actions.toggle_files, { desc = "Git: toggle the file panel [diffview]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview]" } },

            { "n", "<Leader>gp", actions.prev_conflict, { desc = "Git: go to the previous conflict [diffview]" } },
            { "n", "<Leader>gn", actions.next_conflict, { desc = "Git: go to the next conflict [diffview]" } },

            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold [diffview]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: collapse all folds [diffview]" }, },

            { "n", "<Leader>cO", actions.conflict_choose_all "ours", { desc = "Git: choose the OURS version of a conflict for the whole file [diffview]" }, },
            { "n", "<Leader>cT", actions.conflict_choose_all "theirs", { desc = "Git: choose the THEIRS version of a conflict for the whole file [diffview]" }, },
            { "n", "<Leader>cB", actions.conflict_choose_all "base", { desc = "Git: choose the BASE version of a conflict for the whole file [diffview]" }, },
            { "n", "<Leader>cA", actions.conflict_choose_all "all", { desc = "Git: choose all the versions of a conflict for the whole file [diffview]" }, },

            { "n", "dX", actions.conflict_choose_all "none", { desc = "Git: delete the conflict region for the whole file [diffview]" }, },

            { "n", "g?", actions.help "file_panel", { desc = "Git: open the help panel [diffview]" } },
          },
          --stylua: ignore
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview]" }, },
            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview]" }, },
            { "n", "<cr>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },
            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },
            { "n", "h", false },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview]" }, },

            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview]" } },

            { "n", "g!", actions.options, { desc = "Git: open the option panel [diffview]" } },
            { "n", "<C-A-d>", actions.open_in_diffview, { desc = "Git: open the entry under the cursor in a diffview [diffview]" }, },
            { "n", "y", actions.copy_hash, { desc = "Git: copy the commit hash of the entry under the cursor [diffview]" }, },
            { "n", "L", actions.open_commit_log, { desc = "Git: show commit details [diffview]" } },
            { "n", "X", actions.restore_entry, { desc = "Git: restore file to the state from the selected entry [diffview]" }, },

            { "n", "zo", actions.open_fold, { desc = "Git: expand fold [diffview]" } },
            { "n", "zR", actions.open_all_folds, { desc = "Git: expand all folds [diffview]" } },
            { "n", "zc", actions.close_fold, { desc = "Git: collapse fold [diffview]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold [diffview]" } },
            { "n", "zm", actions.close_all_folds, { desc = "Git: collapse all folds [diffview]" } },
            { "n", "zM", actions.close_all_folds, { desc = "Git: collapse all folds [diffview]" } },


            { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview]" } },
            { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview]" } },
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview]" } },

            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold [diffview]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: collapse all folds [diffview]" }, },

            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview]" } },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous file [diffview]" }, },

            { "n", "gg", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview]" }, },
            { "n", "G", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview]" } },

            { "n", "gf", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview]" }, },
            { "n", "ss", actions.goto_file_split, { desc = "Git: open the file in a new split [diffview]" } },
            { "n", "st", actions.goto_file_tab, { desc = "Git: open the file in a new tabpage [diffview]" } },
            { "n", "tn", actions.goto_file_tab, { desc = "Git: open the file in a new tabpage [diffview]" } },

            { "n", "<Leader>E", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview]" } },
            { "n", "<Leader>e", actions.toggle_files, { desc = "Git: toggle the file panel [diffview]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview]" } },

            { "n", "g?", actions.help "file_history_panel", { desc = "Git: open the help panel [diffview]" } },
          },
        },
      }
    end,
  },
  -- NEOGIT (disabled)
  {
    "NeogitOrg/neogit",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
    cmd = { "Neogit", "NeogitCommit" },
    keys = {
      {
        "<Leader>gN",
        function()
          vim.cmd "Neogit"
        end,
        desc = "Git: open neogit [neogit]",
      },
    },
    opts = function()
      -- Highlight.plugin("neogit_hi", {
      --   { NeogitDiffDeleteCursor = { bg = "NONE" } },
      --   { NeogitDiffAddCursor = { bg = "NONE" } },
      --   { NeogitDiffContextCursor { bg = "NONE" } },
      -- })
      return {
        -- disable_signs = false,
        -- disable_hint = true,
        -- disable_commit_confirmation = true,
        -- disable_builtin_notifications = true,
        -- disable_insert_on_commit = false,
        signs = {
          section = { "", "" }, -- "󰁙", "󰁊"
          item = { "▸", "▾" },
          hunk = { "󰐕", "󰍴" },
        },
        mappings = {
          rebase_editor = {
            ["q"] = false,
          },
          status = {
            ["q"] = false,
          },
          finder = {
            ["<c-c>"] = false,
            ["<esc>"] = false,
            h,
          },
          popup = {
            --   -- mapping nya ini
            ["t"] = false,
            ["m"] = false,

            ["M"] = "MergePopup",
            --   ["v"] = false,
            --
            --   -- ["gO"] = "DiffPopup",
            --
            ["T"] = "TagPopup",
            --   -- ["V"] = "RevertPopup",
          },
        },
        integrations = {
          -- diffview = true,
          telescope = true,
        },
      }
    end,
  },
  -- MINI.DIFF (disabled)
  {
    "echasnovski/mini.diff", -- Inline and better diff over the default
    enabled = false,
    event = "VeryLazy",
    config = function()
      local diff = require "mini.diff"
      diff.setup {
        -- Disabled by default
        -- source = diff.gen_source.none(),

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Apply hunks inside a visual/operator region
          apply = "gL",

          -- Reset hunks inside a visual/operator region
          reset = "gH",

          -- Hunk range textobject to be used inside operator
          -- Works also in Visual mode if mapping differs from apply and reset
          textobject = "gh",

          -- Go to hunk range in corresponding direction
          goto_first = "[H",
          goto_prev = "[h",
          goto_next = "]h",
          goto_last = "]H",
        },
      }
    end,
  },
}
