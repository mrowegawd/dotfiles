local Highlight = require "r.settings.highlights"

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
      Highlight.plugin("gh_hijackcol", {
        {
          GHThreadSep = {
            fg = { from = "Normal", attr = "bg", alter = 9 },
            bg = { from = "Normal", attr = "bg", alter = 1.5 },
          },
        },
        {
          GHThreadSepAlt = {
            fg = { from = "Normal", attr = "bg", alter = 9 },
            bg = { from = "Normal", attr = "bg", alter = 1 },
          },
        },
      })
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
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
    keys = {
      {
        "<Leader>gn",
        "<CMD>GitConflictNextConflict<CR>",
        desc = "Git: next conflict [gitconflict]",
      },
      {
        "<Leader>gp",
        "<CMD>GitConflictPrevConflict<CR>",
        desc = "Git: prev conflict [gitconflict]",
      },
    },
    opts = {
      default_commands = true, -- disable commands created by this plugin
    },
  },
  -- BLAME.NVIM
  {
    "FabijanZulj/blame.nvim",
    cmd = { "BlameToggle" },
    config = true,
  },
  -- GITLINKER
  {
    "ruifm/gitlinker.nvim", -- generate shareable file permalinks
    keys = {
      {
        "<Leader>go",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        mode = { "n", "v" },
        desc = "Git: open git link on browser [gitlinker]",
      },
      {
        "<Leader>gO",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        desc = "Git: open git link on browser [gitlinker]",
      },
      {
        "<leader>gy",
        desc = "Git: copy git link [gitlinker]",
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
      Highlight.plugin("octo_hijackcol", {
        {
          OctoNormal = {
            -- fg = { from = "Normal", attr = "bg", alter = 9 },
            bg = { from = "Normal", attr = "bg", alter = 1.5 },
          },
        },
      })
      return {
        -- picker = "telescope",
        picker = "fzf-lua",
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
            next_comment = { lhs = "<a-n>", desc = "issue - go to next comment [octo]" },
            prev_comment = { lhs = "<a-p>", desc = "issue - go to previous comment [octo]" },
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
            next_comment = { lhs = "<a-n>", desc = "pull request - go to next comment [octo]" },
            prev_comment = { lhs = "<a-p>", desc = "pull request - go to previous comment [octo]" },
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
            next_comment = { lhs = "<a-n>", desc = "review thread - go to next comment [octo]" },
            prev_comment = { lhs = "<a-p>", desc = "review thread - go to previous comment [octo]" },
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
            submit_review = { lhs = "<leader>vs", desc = "review diff - submit review [octo]" },
            discard_review = { lhs = "<leader>vd", desc = "review diff - discard review [octo]" },
            add_review_comment = { lhs = "<space>ca", desc = "review diff - add a new review comment [octo]" },
            add_review_suggestion = { lhs = "<space>sa", desc = "review diff - add a new review suggestion [octo]" },
            focus_files = { lhs = "<leader>e", desc = "review diff - move focus to changed file panel [octo]" },
            toggle_files = { lhs = "<leader>b", desc = "review diff - hide/show changed files panel [octo]" },
            next_thread = { lhs = "]t", desc = "review diff - move to next thread [octo]" },
            prev_thread = { lhs = "[t", desc = "review diff - move to previous thread [octo]" },
            select_next_entry = { lhs = "]q", desc = "review diff - move to next changed file [octo]" },
            select_prev_entry = { lhs = "[q", desc = "review diff - move to previous changed file [octo]" },
            select_first_entry = { lhs = "[Q", desc = "review diff - move to first changed file [octo]" },
            select_last_entry = { lhs = "]Q", desc = "review diff - move to last changed file [octo]" },
            close_review_tab = { lhs = "<C-c>", desc = "review diff - close review tab [octo]" },
            toggle_viewed = { lhs = "<leader><space>", desc = "review diff - toggle viewer viewed state [octo]" },
            goto_file = { lhs = "gf", desc = "review diff - go to file [octo]" },
          },
          file_panel = {
            submit_review = { lhs = "<leader>vs", desc = "file panel - submit review [octo]" },
            discard_review = { lhs = "<leader>vd", desc = "file panel - discard review [octo]" },
            next_entry = { lhs = "j", desc = "file panel - move to next changed file [octo]" },
            prev_entry = { lhs = "k", desc = "file panel - move to previous changed file [octo]" },
            select_entry = { lhs = "<cr>", desc = "file panel - show selected changed file diffs [octo]" },
            refresh_files = { lhs = "R", desc = "file panel - refresh changed files panel [octo]" },
            focus_files = { lhs = "<leader>e", desc = "file panel - move focus to changed file panel [octo]" },
            toggle_files = { lhs = "<leader>b", desc = "file panel - hide/show changed files panel [octo]" },
            select_next_entry = { lhs = "]q", desc = "file panel - move to next changed file [octo]" },
            select_prev_entry = { lhs = "[q", desc = "file panel - move to previous changed file [octo]" },
            select_first_entry = { lhs = "[Q", desc = "file panel - move to first changed file [octo]" },
            select_last_entry = { lhs = "]Q", desc = "file panel - move to last changed file [octo]" },
            close_review_tab = { lhs = "<C-c>", desc = "file panel - close review tab [octo]" },
            toggle_viewed = { lhs = "<leader><space>", desc = "file panel - toggle viewer viewed state [octo]" },
          },
          repo = {},
        },
      }
    end,
  },
  -- OCTO
  {
    "pwntester/octo.nvim",
    opts = function(_, opts)
      -- if RUtils.has "telescope.nvim" then
      --   opts.picker = "telescope"
      if RUtils.has "fzf-lua" then
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = function()
      return {
        signs_staged_enable = false,
        attach_to_untracked = true,
        signs_staged = {
          add = { text = "▎" },
          change = { text = "▎" },
          -- delete = { text = "" },
          -- topdelete = { text = "" },
          delete = { text = "▎" },
          topdelete = { text = "▎" },
          changedelete = { text = "▎" },
        },
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          -- delete = { text = "" },
          -- topdelete = { text = "" },
          delete = { text = "▎" },
          topdelete = { text = "▎" },
          changedelete = { text = "▎" },
          -- untracked = { text = "▎" },
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
          require("r.keymaps.git").gitsigns()
        end,
      }
    end,
  },
  -- FUGITIVE
  {
    "tpope/vim-fugitive",
    cmd = { "GitHistory", "Git", "Gedit", "GBrowse", "Gwrite", "GitEditDiff", "GitEditChanged" },
    dependencies = {
      "tpope/vim-rhubarb",
    },
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
          vim.keymap.set("n", "q", RUtils.cmd.quit_return, { buffer = e.buf })
          vim.keymap.set("n", "<a-n>", "]c", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<a-p>", "[c", { buffer = e.buf, remap = true })
          -- vim.keymap.set("n", "ci", "<Cmd>Git commit -n<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gp", "<Cmd>Git push<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gF", "<Cmd>Git push --force-with-lease<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gP", "<Cmd>Git pull<CR>", { buffer = true })
          vim.keymap.set("n", "<Leader>gl", function()
            vim.cmd "Git log --oneline"
          end, { buffer = e.buf })
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
    keys = {
      {
        "<Leader>gN",
        "<Cmd>botright Git<CR><Cmd>wincmd J<bar>20 wincmd _<CR>4j",
        desc = "Git: open fugitive [fugitive]",
      },
      { "<Leader>gc", "<CMD> Git commit <CR>", desc = "Git: commit [fugitive]" },
    },
  },
  -- VGIT
  {
    "tanvirtin/vgit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- keys = {
    --   {
    --     "<Leader>hb",
    --     function()
    --       return require("vgit").buffer_blame_preview()
    --     end,
    --     desc = "Git: next conflict [gitconflict]",
    --   },
    -- },
    opts = {
      settings = {
        live_blame = {
          enabled = false,
        },
        live_gutter = {
          enabled = false,
        },
        authorship_code_lens = {
          enabled = false,
        },
        scene = {
          diff_preference = "split",
        },
      },
    },
  },
  -- DIFFVIEW
  {
    "sindrets/diffview.nvim",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoDiffview", { "DiffviewFiles", "DiffviewFileHistory" })

      Highlight.plugin("diffview", {
        { DiffAddedChar = { bg = "NONE", fg = { from = "GitSignsAdd", attr = "fg", alter = 0.3 } } },
        { DiffChangedChar = { bg = "NONE", fg = { from = "GitSignsChange", attr = "fg", alter = 0.3 } } },
        { DiffDeletedChar = { bg = "NONE", fg = { from = "GitSignsDelete", attr = "fg", alter = 0.3 } } },
        { DiffviewStatusAdded = { link = "DiffAddedChar" } },
        { DiffviewStatusModified = { link = "DiffChangedChar" } },
        { DiffviewStatusRenamed = { link = "DiffChangedChar" } },
        { DiffviewStatusUnmerged = { link = "DiffChangedChar" } },
        { DiffviewStatusUntracked = { link = "DiffAddedChar" } },
        { DiffviewStatusDeleted = { link = "DiffDeletedChar" } },

        { DiffviewFilePanelInsertions = { link = "DiffAddedChar" } },
        { DiffviewFilePanelDeletions = { link = "DiffDeletedChar" } },
      })
      local actions = require "diffview.actions"

      return {
        enhanced_diff_hl = true,
        diff_binaries = false, -- Show diffs for binaries
        git_cmd = { "git" },
        -- hooks = {
        --   diff_buf_read = function()
        --     local opt = vim.opt_local
        --     opt.wrap, opt.list, opt.relativenumber = false, false, false
        --     opt.colorcolumn = ""
        --   end,
        --   ---@diagnostic disable-next-line: unused-local
        --   diff_buf_win_enter = function(bufnr, winid, ctx)
        --     if ctx.layout_name:match "^diff2" then
        --       if ctx.symbol == "a" then
        --         vim.opt_local.winhl = table.concat({
        --           "DiffAdd:DiffviewDiffAddAsDelete",
        --           "DiffDelete:DiffviewDiffDelete",
        --         }, ",")
        --       elseif ctx.symbol == "b" then
        --         vim.opt_local.winhl = table.concat({
        --           "DiffDelete:DiffviewDiffDelete",
        --         }, ",")
        --       end
        --     end
        --   end,
        -- },
        view = {
          -- Configure the layout and behavior of different types of views.
          -- Available layouts:
          --   |'diff1_plain'
          --   |'diff2_horizontal'
          --   |'diff2_vertical'
          --   |'diff3_horizontal'
          --   |'diff3_vertical'
          --   |'diff3_mixed'
          --   |'diff4_mixed'
          -- For more info, see ':h diffview-config-view.x.layout'.
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_horizontal",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
          },
        },
        key_bindings = {

          disable_defaults = true, -- Disable the default key bindings
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          view = {
            ["<tab>"] = actions.select_next_entry, -- Open the diff for the next file
            ["<s-tab>"] = actions.select_prev_entry, -- Open the diff for the previous file

            ["gf"] = actions.goto_file, -- Open the file in a new split in previous tabpage
            ["<C-s>"] = actions.goto_file_split, -- Open the file in a new split
            ["<C-t>"] = actions.goto_file_tab, -- Open the file in a new tabpage

            ["<space>E"] = actions.focus_files, -- Bring focus to the files panel
            ["<space>e"] = actions.toggle_files, -- Toggle the files panel.

            ["<F4>"] = actions.cycle_layout,
            ["<space><tab>"] = "<Cmd>DiffviewClose<CR>",
          },
          file_panel = {

            ["<a-d>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<a-u>"] = actions.scroll_view(-0.25), -- Scroll the view up

            ["j"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            ["<a-n>"] = actions.select_next_entry,
            ["<a-p>"] = actions.select_prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,

            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,

            ["<Leader>gha"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ["<Leader>ghA"] = actions.stage_all, -- Stage all entries.
            ["<Leader>ghR"] = actions.unstage_all, -- Unstage all entries.
            ["<Leader>ghu"] = actions.restore_entry, -- Restore entry to the state on the left side.
            ["R"] = actions.refresh_files, -- Update stats and entries in the file list.

            ["H"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
            ["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.

            ["o"] = actions.goto_file_edit,
            ["<c-t>"] = actions.goto_file_tab,
            ["<c-s>"] = actions.goto_file_split,

            ["<F4>"] = actions.cycle_layout,
            ["L"] = actions.open_commit_log,

            ["<a-E>"] = actions.focus_files,
            ["<a-e>"] = actions.toggle_files,

            ["gf"] = "",
            ["<space><tab>"] = "<Cmd>DiffviewClose<CR>",
          },
          file_history_panel = {
            ["?"] = actions.options, -- Open the option panel

            ["<a-d>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<a-u>"] = actions.scroll_view(-0.25), -- Scroll the view up

            ["zR"] = actions.open_all_folds,
            ["zM"] = actions.close_all_folds,
            ["zo"] = actions.open_fold,
            ["zc"] = actions.close_fold,
            ["za"] = actions.toggle_fold,
            ["<BS>"] = actions.toggle_fold,
            ["<tab>"] = actions.toggle_fold,
            ["<s-tab>"] = actions.toggle_fold,

            ["j"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            -- ["<down>"] = actions.next_entry,
            -- ["<up>"] = actions.prev_entry,
            ["<a-n>"] = actions.select_next_entry,
            ["<a-p>"] = actions.select_prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,

            ["R"] = actions.refresh_files, -- Update stats and entries in the file list.

            ["o"] = actions.goto_file_edit,
            ["<c-t>"] = actions.goto_file_tab,
            ["<c-s>"] = actions.goto_file_split,

            ["<F4>"] = actions.cycle_layout,
            ["L"] = actions.open_commit_log,
            ["D"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
            ["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor

            ["<space>E"] = actions.focus_files,
            ["<space>e"] = actions.toggle_files,
          },
          option_panel = {
            ["<tab>"] = actions.select_entry,
            ["q"] = actions.close,
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

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    cmd = "Neogit",
    -- keys = {
    --   {
    --     "<Leader>gc",
    --     function()
    --       require("neogit").open { "commit" }
    --     end,
    --     desc = "Git(neogit): create commit",
    --   },
    --   {
    --     "<Leader>gN",
    --     function()
    --       vim.cmd "Neogit"
    --     end,
    --     desc = "Git(neogit): open split",
    --   },
    -- },
    opts = {
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
      integrations = {
        diffview = true,
      },
    },
  },
}
