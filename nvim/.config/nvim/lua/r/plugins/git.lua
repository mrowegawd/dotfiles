vim.g.fugitive_no_maps = 1

local git_sign = {
  add = "+", --  "▎" "▌" "┆"
  change = "m",
  delete = "_",
  topdelete = "‾",
  changedelete = "~",
}

local normal_themes = {
  "base46-kanagawa",
  "base46-everforest",
  "base46-material-darker",
  "darcubox",
  "tokyonight",
  "jellybeans",
  "kanagawa",
  "lackluster",
  "neogotham",
  "nordfox",
  "rose-pine",
  "rose-pine-moon",
  "tokyonight-storm",
  "y9nika",
  "vscode",
}

if vim.tbl_contains(normal_themes, vim.g.colorscheme) then
  git_sign = {
    add = "▌",
    change = "▌",
    delete = "_",
    topdelete = "‾",
    changedelete = "~",
  }
end

return {
  { "ldelossa/litee.nvim", lazy = true },
  -- GH.NVIM
  {
    "ldelossa/gh.nvim",
    cmd = { "GHOpenPR", "GHOpenIssue", "GHSearchIssues" },
    keys = {
      { "<Leader>G", "", desc = "+Github" },
      { "<Leader>Gc", "", desc = "+Commits" },
      { "<Leader>Gcc", "<CMD>GHCloseCommit<CR>", desc = "Close" },
      { "<Leader>Gce", "<CMD>GHExpandCommit<CR>", desc = "Expand" },
      { "<Leader>Gco", "<CMD>GHOpenToCommit<CR>", desc = "Open To" },
      { "<Leader>Gcp", "<CMD>GHPopOutCommit<CR>", desc = "Pop Out" },
      { "<Leader>Gcz", "<CMD>GHCollapseCommit<CR>", desc = "Collapse" },

      { "<Leader>Gi", "", desc = "+Issues" },
      { "<Leader>Gip", "<CMD>GHPreviewIssue<CR>", desc = "Preview" },
      { "<Leader>Gio", "<CMD>GHOpenIssue<CR>", desc = "Open" },

      { "<Leader>Gl", "", desc = "+Litee" },
      { "<Leader>Glt", "<CMD>LTPanel<CR>", desc = "Toggle Panel" },

      { "<Leader>Gp", "", desc = "+Pull Request" },
      { "<Leader>Gpc", "<CMD>GHClosePR<CR>", desc = "Close" },
      { "<Leader>Gpd", "<CMD>GHPRDetails<CR>", desc = "Details" },
      { "<Leader>Gpe", "<CMD>GHExpandPR<CR>", desc = "Expand" },
      { "<Leader>Gpo", "<CMD>GHOpenPR<CR>", desc = "Open" },
      { "<Leader>Gpp", "<CMD>GHPopOutPR<CR>", desc = "PopOut" },
      { "<Leader>Gpr", "<CMD>GHRefreshPR<CR>", desc = "Refresh" },
      { "<Leader>Gpt", "<CMD>GHOpenToPR<CR>", desc = "Open To" },
      { "<Leader>Gpz", "<CMD>GHCollapsePR<CR>", desc = "Collapse" },

      { "<Leader>Gr", "", desc = "+Review" },
      { "<Leader>Grb", "<CMD>GHStartReview<CR>", desc = "Begin" },
      { "<Leader>Grc", "<CMD>GHCloseReview<CR>", desc = "Close" },
      { "<Leader>Grd", "<CMD>GHDeleteReview<CR>", desc = "Delete" },
      { "<Leader>Gre", "<CMD>GHExpandReview<CR>", desc = "Expand" },
      { "<Leader>Grs", "<CMD>GHSubmitReview<CR>", desc = "Submit" },
      { "<Leader>Grz", "<CMD>GHCollapseReview<CR>", desc = "Collapse" },

      { "<Leader>Gt", "", desc = "+Threads" },
      { "<Leader>Gtc", "<CMD>GHCreateThread<CR>", desc = "Create" },
      { "<Leader>Gtn", "<CMD>GHNextThread<CR>", desc = "Next" },
      { "<Leader>Gtt", "<CMD>GHToggleThread<CR>", desc = "Toggle" },
    },
    config = function(_, opts)
      require("litee.lib").setup()
      require("litee.gh").setup(opts)
    end,
  },
  -- GIT-LINK.NVIM
  {
    "juacker/git-link.nvim",
    keys = {
      {
        "<leader>gy",
        function()
          require("git-link.main").copy_line_url()
        end,
        desc = "Git: yank/copy line [git-link.nvim]",
        mode = { "n", "x" },
      },
      {
        "<leader>gY",
        function()
          require("git-link.main").open_line_url()
        end,
        desc = "Git: open in browser [git-link.nvim]",
        mode = { "n", "x" },
      },
    },
  },
  -- OCTO
  {
    -- Sebelum menggunakannya: run command ini di cli "gh auth login --scopes read:project"
    -- "pwntester/octo.nvim",
    -- "MadKuntilanak/octo.nvim",
    dir = "~/.local/src/nvim_plugins/octo.nvim",
    branch = "feat/big-updates",
    cmd = "Octo",
    keys = {
      { "<Leader>ma", "", desc = "add", ft = "octo" },
      { "<Leader>mar", "", desc = "reactions", ft = "octo" },
      { "<Leader>mr", "", desc = "delete/remove", ft = "octo" },
      { "<Leader>mc", "", desc = "create/checkout/merge", ft = "octo" },
      { "<Leader>mv", "", desc = "view/diff", ft = "octo" },

      { "<Leader>mR", "", desc = "reviewer", ft = "octo" },
      { "<Leader>mt", "", desc = "thread", ft = "octo" },
      { "<Leader>mn", "", desc = "notifications", ft = "octo" },
    },
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = {
      -- picker = "snacks",
      picker = "fzf-lua",
      -- picker = "telescope",
      picker_config = {
        use_emojis = true,
        mappings = {
          goto_file = { lhs = "<CR>", desc = "got to file" },
          -- copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          -- checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
          -- merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
        },
        fzflua = {
          winopts = {
            fullscreen = false,
            width = 1,
            height = 0.55,
            row = 1,
            col = 0.20,
            preview = {
              hidden = false,
              layout = "vertical",
              vertical = "right:50%",
            },
          },
        },
      },
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        discussion = {
          open_in_browser = { lhs = "<Leader>mY", desc = "open issue in browser [discussion]" },
          copy_url = { lhs = "<Leader>my", desc = "copy url to system clipboard [discussion]" },
          add_comment = { lhs = "<Leader>mac", desc = "add comment [discussion]" },
          add_reply = { lhs = "<Leader>may", desc = "add reply [discussion]" },
          add_label = { lhs = "<Leader>mal", desc = "add label [discussion]" },

          delete_comment = { lhs = "<Leader>mrc", desc = "delete comment [discussion]" },
          remove_label = { lhs = "<Leader>mrl", desc = "remove label [discussion]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [discussion]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [discussion]" },

          react_hooray = { lhs = "<Leader>marp", desc = "add/remove 🎉 reaction [discussion]" },
          react_heart = { lhs = "<Leader>marh", desc = "add/remove ❤️ reaction [discussion]" },
          react_eyes = { lhs = "<Leader>mare", desc = "add/remove 👀 reaction [discussion]" },
          react_thumbs_up = { lhs = "<Leader>marn", desc = "add/remove 👍 reaction [discussion]" },
          react_thumbs_down = { lhs = "<Leader>marp", desc = "add/remove 👎 reaction [discussion]" },
          react_rocket = { lhs = "<Leader>marr", desc = "add/remove 🚀 reaction [discussion]" },
          react_laugh = { lhs = "<Leader>marl", desc = "add/remove 😄 reaction [discussion]" },
          react_confused = { lhs = "<Leader>marc", desc = "add/remove 😕 reaction [discussion]" },
        },
        runs = {
          expand_step = { lhs = "o", desc = "expand workflow step [runs]" },
          open_in_browser = { lhs = "<Leader>mY", desc = "open workflow run in browser [runs]" },
          refresh = { lhs = "<C-r>", desc = "refresh workflow [runs]" },
          rerun = { lhs = "<C-o>", desc = "rerun workflow [runs]" },
          rerun_failed = { lhs = "<C-f>", desc = "rerun failed workflow [runs]" },
          cancel = { lhs = "<C-x>", desc = "cancel workflow [runs]" },
          copy_url = { lhs = "<Leader>my", desc = "copy url to system clipboard [runs]" },
        },
        issue = {
          close_issue = { lhs = "<Leader>mC", desc = "close issue [issue]" },
          reopen_issue = { lhs = "<Leader>maI", desc = "reopen issue [issue]" },
          list_issues = { lhs = "<Leader>mf", desc = "list open issues on same repo [octo [issue]" },
          reload = { lhs = "R", desc = "reload issue [issue]" },

          open_in_browser = { lhs = "<Leader>mY", desc = "open issue in browser [issue]" },
          copy_url = { lhs = "<Leader>my", desc = "copy url to system clipboard [issue]" },

          add_assignee = { lhs = "<Leader>mA", desc = "add assignee [issue]" },

          create_label = { lhs = "<Leader>mcl", desc = "create label [issue]" },
          add_label = { lhs = "<Leader>mal", desc = "add label [issue]" },

          remove_label = { lhs = "<Leader>mrl", desc = "remove label [issue]" },
          remove_assignee = { lhs = "<Leader>mrA", desc = "remove assignee [issue]" },

          goto_issue = { lhs = "<Leader>mo", desc = "go to issue/pr/discussion under cursor [issue]" },

          add_comment = { lhs = "<Leader>mac", desc = "add comment [issue]" },
          add_reply = { lhs = "<Leader>may", desc = "add reply [issue]" },
          delete_comment = { lhs = "<Leader>mrc", desc = "delete comment [issue]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [issue]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [issue]" },

          react_hooray = { lhs = "<Leader>maro", desc = "add/remove 🎉 reaction [issue]" },
          react_heart = { lhs = "<Leader>marh", desc = "add/remove ❤️ reaction [issue]" },
          react_eyes = { lhs = "<Leader>mare", desc = "add/remove 👀 reaction [issue]" },
          react_thumbs_up = { lhs = "<Leader>marn", desc = "add/remove 👍 reaction [issue]" },
          react_thumbs_down = { lhs = "<Leader>marp", desc = "add/remove 👎 reaction [issue]" },
          react_rocket = { lhs = "<Leader>marr", desc = "add/remove 🚀 reaction [issue]" },
          react_laugh = { lhs = "<Leader>marl", desc = "add/remove 😄 reaction [issue]" },
          react_confused = { lhs = "<Leader>marc", desc = "add/remove 😕 reaction [issue]" },
        },
        pull_request = {
          checkout_pr = { lhs = "<Leader>mco", desc = "checkout PR [pull request]" },
          merge_pr = { lhs = "<Leader>mcm", desc = "merge commit PR [pull request]" },

          squash_and_merge_pr = { lhs = "<Leader>mcs", desc = "squash and merge PR [pull request]" },
          rebase_and_merge_pr = { lhs = "<Leader>mcr", desc = "rebase and merge PR [pull request]" },

          merge_pr_queue = {
            lhs = "<Leader>mcP",
            desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          squash_and_merge_queue = {
            lhs = "<Leader>mcS",
            desc = "squash and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          rebase_and_merge_queue = {
            lhs = "<Leader>mcR",
            desc = "rebase and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          list_commits = { lhs = "<Leader>mvf", desc = "list PR commits [pull request]" },
          list_changed_files = { lhs = "<Leader>mvF", desc = "list PR changed files [pull request]" },
          show_pr_diff = { lhs = "<Leader>mvd", desc = "show PR diff [pull request]" },

          close_issue = { lhs = "<Leader>mC", desc = "close PR [pull request]" },
          reopen_issue = { lhs = "<Leader>maI", desc = "reopen PR [pull request]" },
          list_issues = { lhs = "<Leader>mf", desc = "list open issues on same repo [pull request]" },
          reload = { lhs = "R", desc = "reload PR [pull request]" },
          open_in_browser = { lhs = "<Leader>mY", desc = "open PR in browser [pull request]" },
          copy_url = { lhs = "<Leader>my", desc = "copy url to system clipboard [pull request]" },
          goto_file = { lhs = "gf", desc = "go to file [pull request]" },

          add_assignee = { lhs = "<Leader>mA", desc = "add assignee [pull request]" },
          remove_assignee = { lhs = "<Leader>mrA", desc = "remove assignee [pull request]" },

          create_label = { lhs = "<Leader>mcl", desc = "create label [pull request]" },
          add_label = { lhs = "<Leader>mal", desc = "add label [pull request]" },

          copy_sha = { lhs = "<Leader>gY", desc = "copy commit SHA to system clipboard [pull request]" },
          remove_label = { lhs = "<Leader>mrl", desc = "remove label [pull request]" },
          goto_issue = { lhs = "<Leader>mo", desc = "go to issue/pr/discussion under cursor [pull request]" },

          add_comment = { lhs = "<Leader>mac", desc = "add comment [pull request]" },
          add_reply = { lhs = "<Leader>may", desc = "add reply [pull request]" },
          delete_comment = { lhs = "<Leader>mrc", desc = "delete comment [pull request]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [pull request]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [pull request]" },

          add_reviewer = { lhs = "<Leader>mRa", desc = "add reviewer [pull request]" },
          remove_reviewer = { lhs = "<Leader>mRd", desc = "remove reviewer request [pull request]" },
          review_start = { lhs = "<Leader>mRs", desc = "start a review for the current PR [pull request]" },
          review_resume = { lhs = "<Leader>mRr", desc = "resume a pending review for the current PR [pull request]" },

          react_hooray = { lhs = "<Leader>maro", desc = "add/remove 🎉 reaction [pull request]" },
          react_heart = { lhs = "<Leader>marh", desc = "add/remove ❤️ reaction [pull request]" },
          react_eyes = { lhs = "<Leader>mare", desc = "add/remove 👀 reaction [pull request]" },
          react_thumbs_up = { lhs = "<Leader>marn", desc = "add/remove 👍 reaction [pull request]" },
          react_thumbs_down = { lhs = "<Leader>marp", desc = "add/remove 👎 reaction [pull request]" },
          react_rocket = { lhs = "<Leader>marr", desc = "add/remove 🚀 reaction [pull request]" },
          react_laugh = { lhs = "<Leader>marl", desc = "add/remove 😄 reaction [pull request]" },
          react_confused = { lhs = "<Leader>marc", desc = "add/remove 😕 reaction [pull request]" },

          resolve_thread = { lhs = "<Leader>mtt", desc = "resolve PR thread [pull request]" },
          unresolve_thread = { lhs = "<Leader>mtU", desc = "unresolve PR thread [pull request]" },
        },
        review_thread = {
          goto_issue = { lhs = "<Leader>mo", desc = "go to issue/pr/discussion under cursor [review thread]" },
          add_comment = { lhs = "<Leader>mac", desc = "add comment [review thread]" },
          add_reply = { lhs = "<Leader>may", desc = "add reply [review thread]" },
          add_suggestion = { lhs = "<Leader>mas", desc = "add suggestion [review thread]" },
          delete_comment = { lhs = "<Leader>mrc", desc = "delete comment [review thread]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [review thread]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [review thread]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review thread]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review thread]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review thread]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review thread]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review thread]" },

          react_hooray = { lhs = "<Leader>maro", desc = "add/remove 🎉 reaction [review thread]" },
          react_heart = { lhs = "<Leader>marh", desc = "add/remove ❤️ reaction [review thread]" },
          react_eyes = { lhs = "<Leader>mare", desc = "add/remove 👀 reaction [review thread]" },
          react_thumbs_up = { lhs = "<Leader>marn", desc = "add/remove 👍 reaction [review thread]" },
          react_thumbs_down = { lhs = "<Leader>marp", desc = "add/remove 👎 reaction [review thread]" },
          react_rocket = { lhs = "<Leader>marr", desc = "add/remove 🚀 reaction [review thread]" },
          react_laugh = { lhs = "<Leader>marl", desc = "add/remove 😄 reaction [review thread]" },
          react_confused = { lhs = "<Leader>marc", desc = "add/remove 😕 reaction [review thread]" },

          resolve_thread = { lhs = "<Leader>mtt", desc = "resolve PR thread [review thread]" },
          unresolve_thread = { lhs = "<Leader>mtU", desc = "unresolve PR thread [review thread]" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review [submit win]" },
          comment_review = { lhs = "<C-m>", desc = "comment review [submit win]" },
          request_changes = { lhs = "<C-r>", desc = "request changes review [submit win]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [submit win]" },
        },
        review_diff = {
          submit_review = { lhs = "<Leader>mRS", desc = "submit review [review diff]" },
          discard_review = { lhs = "<Leader>mRd", desc = "discard review [review diff]" },
          add_review_comment = { lhs = "<Leader>mac", desc = "add a new review comment [review diff]" },
          add_review_suggestion = { lhs = "<Leader>maS", desc = "add a new review suggestion [review diff]" },
          focus_files = { lhs = "<Leader>uE", desc = "move focus to changed file panel [review diff]" },
          toggle_files = { lhs = "<Leader>ue", desc = "hide/show changed files panel [review diff]" },
          next_thread = { lhs = "<C-n>", desc = "move to next thread [review diff]" },
          prev_thread = { lhs = "<C-p>", desc = "move to previous thread [review diff]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review diff]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review diff]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review diff]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review diff]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },

          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review diff]" },
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [review diff]" },

          goto_file = { lhs = "<Leader>bv", desc = "go to file [review diff]" },
          copy_sha = { lhs = "<Leader>gY", desc = "copy commit SHA to system clipboard [review diff]" },
          review_commits = { lhs = "<space>mC", desc = "review PR commits [review diff]" },
        },
        file_panel = {
          submit_review = { lhs = "<Leader>mRS", desc = "submit review [file panel]" },
          discard_review = { lhs = "<Leader>mRd", desc = "discard review [file panel]" },
          next_entry = { lhs = "j", desc = "move to next changed file [file panel]" },
          prev_entry = { lhs = "k", desc = "move to previous changed file [file panel]" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs [file panel]" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel [file panel]" },
          focus_files = { lhs = "<Leader>uE", desc = "move focus to changed file panel [file panel]" },
          toggle_files = { lhs = "<Leader>ue", desc = "hide/show changed files panel [file panel]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [file panel]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [file panel]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [file panel]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [file panel]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [file panel]" },
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [file panel]" },
          review_commits = { lhs = "<space>mC", desc = "review PR commits [file panel]" },
        },
        notification = {
          read = { lhs = "<Leader>mnr", desc = "mark notification as read [notification]" },
          done = { lhs = "<Leader>mnd", desc = "mark notification as done [notification]" },
          unsubscribe = { lhs = "<Leader>mnu", desc = "unsubscribe from notifications [notification]" },
        },
        repo = {
          create_issue = { lhs = "<Leader>mci", desc = "create issue [repo]" },
          create_discussion = { lhs = "<Leader>mcd", desc = "create discussion [repo]" },
          contributing_guidelines = { lhs = "<Leader>mcG", desc = "view contributing guidelines [repo]" },
          open_in_browser = { lhs = "<Leader>mY", desc = "open repo in browser [repo]" },
        },
        release = {
          open_in_browser = { lhs = "<Leader>mY", desc = "open release in browser [release]" },
        },
      },
    },
  },
  -- OCTO
  {
    -- "pwntester/octo.nvim",
    -- "MadKuntilanak/octo.nvim",
    dir = "~/.local/src/nvim_plugins/octo.nvim",
    optional = true,
    opts = function()
      vim.treesitter.language.register("markdown", "octo")
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
    cmd = { "GitToggleDelete", "GitToggleWordDiff", "GitToggleLineHl" },
    opts = {
      signs_staged_enable = false,
      -- debug_mode = true,
      attach_to_untracked = true,
      signs_staged = {
        add = { text = git_sign.add }, --  "▎" "▌" "┆"
        change = { text = git_sign.change },
        delete = { text = git_sign.delete },
        topdelete = { text = git_sign.topdelete },
        changedelete = { text = git_sign.changedelete },
      },
      signs = {
        add = { text = git_sign.add },
        change = { text = git_sign.change },
        delete = { text = git_sign.delete },
        topdelete = { text = git_sign.topdelete },
        changedelete = { text = git_sign.changedelete },
        untracked = { text = "┆" },
      },
      -- numhl = true,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
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
        map("n", "<Leader>gs", gs.stage_hunk, "Git: stage [gitsigns]")
        map("x", "<Leader>gs", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.stage_hunk { from, to }
        end, "Git: stage (visual) [gitsigns]")
        map("n", "<Leader>gr", gs.reset_hunk, "Git: reset [gitsigns]")
        map("x", "<Leader>gr", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.reset_hunk { from, to }
        end, "Git: reset (visual) [gitsigns]")
        map("n", "<Leader>gu", gs.undo_stage_hunk, "Git: undo [gitsigns]")
        map("n", "<Leader>gS", gs.stage_buffer, "Git: stage buffer [gitsigns]")
        map("n", "<Leader>gR", gs.reset_buffer, "Git: reset buffer [gitsigns]")

        -- Hunk preview
        map("n", "<Leader>gp", gs.preview_hunk_inline, "Git: preview hunk inline [gitsigns]")
        map("n", "<Leader>gP", gs.preview_hunk, "Git: preview hunk infloat [gitsigns]")

        vim.api.nvim_create_user_command("GitToggleDelete", function()
          gs.toggle_deleted()
        end, { desc = "Git: toggle diff changes [gitsigns]" })
        vim.api.nvim_create_user_command("GitToggleWordDiff", function()
          gs.toggle_word_diff()
        end, { desc = "Git: toggle word diff [gitsigns]" })
        vim.api.nvim_create_user_command("GitToggleLineHl", function()
          gs.toggle_linehl()
        end, { desc = "Git: toggle linehl [gitsigns]" })

        -- Sending to qf
        map("n", "<Leader>xG", function()
          gs.setqflist "all"
          local is_qf_trouble = RUtils.cmd.windows_is_opened { "trouble" }
          vim.schedule(function()
            if is_qf_trouble.found then
              vim.api.nvim_set_current_win(is_qf_trouble.winid)
            end
          end)
        end, "Exec: git hunks all quickfix (qf) [gitsigns] [trouble]")
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
        end, "Git: prev hunk [gitsigns]")
      end,
    },
  },
  -- FUGITIVE
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "GBrowse",
      "GcLog",
      "Gllog",
      "GlLog",
      "Gclog",
      "Gdiffsplit",
      "Gedit",
      "Git",
      "Gwrite",
      "GitBlame",
    },
    dependencies = { "tpope/vim-rhubarb" },
    config = function()
      vim.api.nvim_create_user_command("GitBlame", function()
        vim.cmd "G blame"
      end, { desc = "Git: open git blame [fugitive]" })

      RUtils.map.augroup("ps_fugitive", {
        event = "FileType",
        pattern = { "fugitive" }, -- gstatus
        command = function(e)
          -- Options
          vim.opt_local.winfixheight = true
          vim.opt_local.winfixbuf = true
          -- Mappings
          vim.keymap.set("n", "<c-n>", "]m", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<c-p>", "[m", { buffer = e.buf, remap = true })
          -- vim.keymap.set("n", "<a-n>", "]m=zt", { buffer = e.buf, remap = true })
          -- vim.keymap.set("n", "<a-p>", "[m=zt", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<tab>", "=zt", { buffer = e.buf, remap = true })

          vim.keymap.set("n", "<Leader>bs", "o", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<Leader>be", "o", { buffer = e.buf, remap = true })

          vim.keymap.set("n", "<Leader>bt", "O", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<Leader>bv", "gO", { buffer = e.buf, remap = true })

          -- vim.keymap.set("n", "ci", "<Cmd>Git commit -n<CR>", { buffer = true })
          -- vim.keymap.set("n", "<Leader>gp", "<Cmd>Git push<CR>", { buffer = true })
          -- vim.keymap.set("n", "<Leader>gP", "<Cmd>Git pull<CR>", { buffer = true })
          -- vim.keymap.set("n", "<Leader>gl", function()
          --   vim.cmd "Git log --oneline"
          -- end, { buffer = e.buf })
        end,
      }, {
        event = "BufWinEnter",
        pattern = "*.git/COMMIT_EDITMSG",
        command = function()
          -- If it's a new commit, start in insert mode, otherwise start in normal mode
          if vim.fn.getline(1) == "" then
            -- vim.cmd "15 wincmd _"
            vim.cmd "15 wincmd K"
            vim.cmd "normal! gg0"
            if vim.api.nvim_get_current_line() == "" then
              vim.cmd "startinsert"
            end
          end
        end,
      })

      -- local function merge_base(ref1, ref2, callback)
      --   ref1 = ref1 or "origin/master"
      --   ref2 = ref2 or "HEAD"
      --   local stdout = ""
      --   vim.fn.jobstart({ "git", "merge-base", ref1, ref2 }, {
      --     stdout_buffered = true,
      --     on_stdout = function(_, data, _)
      --       stdout = vim.trim(table.concat(data, "\n"))
      --     end,
      --     on_exit = function(_, code)
      --       if code ~= 0 then
      --         return callback "Error"
      --       else
      --         callback(nil, stdout)
      --       end
      --     end,
      --   })
      -- end

      -- vim.api.nvim_create_user_command("GitEditDiff", function()
      --   merge_base(nil, nil, function(err, ref)
      --     if err or not ref then
      --       vim.notify("Error calculating merge base", vim.log.levels.ERROR)
      --       return
      --     end
      --     run_files_cmd({ "git", "diff", "--name-only", ref }, function(files)
      --       if vim.tbl_isempty(files) then
      --         vim.notify("No diff from master", vim.log.levels.INFO)
      --         return
      --       end
      --       open_files(files)
      --     end)
      --   end)
      -- end, {
      --   desc = "Edit files that differ from master",
      -- })
    end,
  },
  -- DIFFVIEW
  {
    "sindrets/diffview.nvim",
    event = "LazyFile",
    keys = {
      { "<Leader>mc", "", desc = "conflict", ft = { "DiffviewFiles", "DiffviewFileHistory" } },
      {
        "<Leader>goo",
        "<CMD>DiffviewOpen<CR>",
        desc = "Git: DiffviewOpen [diffview]",
      },
      {
        "<Leader>goh",
        "<CMD>DiffviewFileHistory<CR>",
        desc = "Git: DiffviewFileHistory repo [diffview]",
      },
      {
        "<Leader>gl",
        function()
          local current_line = vim.fn.line "."
          local file = vim.fn.expand "%"
          -- DiffviewFileHistory --follow -L{current_line},{current_line}:{file}
          local str_cmds = string.format("DiffviewFileHistory --follow -L%s,%s:%s", current_line, current_line, file)
          vim.cmd(str_cmds)
        end,
        desc = "Git: DiffviewFileHistory line [diffview]",
      },
      {
        "<Leader>gl",
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
        mode = "x",
        desc = "Git: DiffviewFileHistory line (visual) [diffview]",
      },
    },
    opts = function()
      local actions = require "diffview.actions"
      RUtils.map.disable_ctrl_i_and_o("NoDiffview", { "DiffviewFiles", "DiffviewFileHistory" })

      return {
        enhanced_diff_hl = true,
        diff_binaries = false, -- Show diffs for binaries
        hooks = {
          ---@diagnostic disable-next-line: unused-local
          diff_buf_win_enter = function(bufnr, winid, ctx)
            -- Turn off cursor line for diffview windows because of bg conflict
            -- https://github.com/neovim/neovim/issues/9800
            vim.wo[winid].culopt = "number"

            -- clear the lsp autocmd that highlights the word under the cursor
            pcall(vim.api.nvim_clear_autocmds, {
              group = "kickstart-lsp-highlight",
              buffer = bufnr,
            })

            -- turn off gitsigns inline diff
            ---@diagnostic disable-next-line: param-type-mismatch
            pcall(vim.cmd, "Gitsigns toggle_linehl false")
            ---@diagnostic disable-next-line: param-type-mismatch
            pcall(vim.cmd, "Gitsigns toggle_word_diff false")

            -- clear highlights
            vim.cmd "nohl"

            -- HACK: turn off inlay hints, but diffview is triggering the lsp
            -- to renable them even if they were off (re-editing the buffer?)
            -- add a 100ms delay to make sure they're off. gross.
            vim.defer_fn(function()
              local wins = vim.api.nvim_tabpage_list_wins(0)
              for _, win in ipairs(wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                vim.lsp.inlay_hint.enable(false, { bufnr = buf })
              end
            end, 500)
          end,
        },
        view = {
          default = { disable_diagnostics = true },
          file_history = { disable_diagnostics = true },
        },
        key_bindings = {
          disable_defaults = true, -- Disable the default key bindings
          --stylua: ignore
          view = {
            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-view]" }, },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview-view]" } },

            { "n", "[F", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview-view]" } },
            { "n", "]F", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview-view]" } },

            { "n", "h", false },

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>be", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-view]" } },
            { "n", "<Leader>bs", actions.goto_file_split, { desc = "Git: open in split [diffview-view]" } },
            { "n", "<Leader>bt", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-view]" } },

            { "n", "<Leader>uE", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-view]" } },
            { "n", "<Leader>ue", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-view]" } },

            --  ───────────────────────────[ GIT CONFLICT ]────────────────────────
            { "n", "<Leader>mcn", actions.next_conflict, { desc = "Git: next conflict [diffview-view]" } },
            { "n", "<Leader>mcp", actions.prev_conflict, { desc = "Git: prev conflict [diffview-view]" } },

            { "n", "<a-1>", actions.conflict_choose "ours", { desc = "Git: choose OURS conflict [diffview-view]" } },
            { "n", "<a-3>", actions.conflict_choose "theirs", { desc = "Git: choose THEIRS conflict [diffview-view]" }, },
            { "n", "<a-0>", actions.conflict_choose "base", { desc = "Git: choose BASE (kosong) conflict [diffview-view]" } },
            { "n", "<a-2>", actions.conflict_choose "all", { desc = "Git: choose BOTH conflict [diffview-view]" } },

            { "n", "<Leader>mcd", actions.conflict_choose "none", { desc = "Git: delete region conflict [diffview-view]" } },
            { "n", "<Leader>mcD", actions.conflict_choose_all "none", { desc = "Git: delete all region conflict [diffview-view]" }, },

            { "n", "<Leader>mcH", actions.conflict_choose_all "ours", { desc = "Git: choose ALL OURS conflict [diffview-view]" }, },
            { "n", "<Leader>mcL", actions.conflict_choose_all "theirs", { desc = "Git: choose ALL THEIRS conflict [diffview-view]" }, },
            { "n", "<Leader>mcb", actions.conflict_choose_all "base", { desc = "Git: choose ALL BASE conflict [diffview-view]" }, },
            { "n", "<Leader>mcB", actions.conflict_choose_all "all", { desc = "Git: choose ALL BOTH conflict [diffview-view]" }, },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle through available layouts [diffview-view]" } },
          },
          --stylua: ignore
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: cursor down [diffview-panel]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: cursor up [diffview-panel]" }, },

            { "n", "<down>", actions.next_entry, { desc = "Git: cursor down (alternative) [diffview-panel]" }, },
            { "n", "<up>", actions.prev_entry, { desc = "Git: cursor up (alternative) [diffview-panel]" }, },

            { "n", "o", actions.select_entry, { desc = "Git: open entry [diffview-panel]" }, },
            { "n", "<CR>", actions.select_entry, { desc = "Git: open entry (alternative) [diffview-panel]" }, },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open entry (alternative-back) [diffview-panel]" }, },

            { "n", "h", false },

            --  ──────────────────[ STAGE, UNSTAGE, COMMIT MESSAGE ]───────────────
            { "n", "s", actions.toggle_stage_entry, { desc = "Git: stage / unstage [diffview-panel]" }, },
            { "n", "u", actions.toggle_stage_entry, { desc = "Git: stage / unstage [diffview-panel]" }, },
            { "n", "cc", "<Cmd>Git commit <bar> wincmd J<CR>", { desc = "Git: commit message [diffview-panel]" }, },
            { "n", "ca", "<Cmd>Git commit --amend <bar> wincmd J<CR>", { desc = "Git: amend the last commit with fugitive [diffview-panel]" }, },

            { "n", "P", actions.open_commit_log, { desc = "Git: preview commit detail [diffview-panel]" } },

            --  ──────────────────────────────[ SCROLL ]───────────────────────────
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll view up [diffview-panel]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll view down [diffview-panel]" } },

            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: next select entry [diffview-panel]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-panel]" }, },

            { "n", "gg", false },
            { "n", "G", false},

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>be", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-panel]" }, },
            { "n", "<Leader>bs", actions.goto_file_split, { desc = "Git: open in split [diffview-panel]" }, },
            { "n", "<Leader>bt", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-panel]" }, },

            { "n", "R", actions.refresh_files, { desc = "Git: update stats and entries in the file list [diffview-panel]" }, },

            --  ──────────────────[ OPEN FILE MANAGER FOR DIFFVIEW ]───────────────
            { "n", "<Leader>uE", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-panel]" }, },
            { "n", "<Leader>ue", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-panel]" } },

            --  ───────────────────────────────[ FOLD ]────────────────────────────
            { "n", "<C-a>", actions.toggle_fold, { desc = "Git: toggle fold [diffview-panel]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold (alternative) [diffview-panel]" } },
            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold (alternative-back) [diffview-panel]" } },

            { "n", "zo", actions.open_fold, { desc = "Git: expand fold [diffview-panel]" } },

            { "n", "zR", actions.open_all_folds, { desc = "Git: open all folds [diffview-panel]" } },
            { "n", "zO", actions.open_all_folds, { desc = "Git: open all folds (alternative) [diffview-panel]" } },

            { "n", "zm", actions.close_all_folds, { desc = "Git: close all folds [diffview-panel]" } },
            { "n", "zc", actions.close_all_folds, { desc = "Git: close all folds (alternative) [diffview-panel]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: close all folds (alternative-back) [diffview-panel]" }, },

            --  ───────────────────────────[ GIT CONFLICT ]────────────────────────
            { "n", "<Leader>mcn", actions.next_conflict, { desc = "Git: next git conflict [diffview-panel]" } },
            { "n", "<Leader>mcp", actions.prev_conflict, { desc = "Git: prev git conflict [diffview-panel]" } },

            { "n", "<a-1>", actions.conflict_choose_all "ours", { desc = "Git: choose ALL OURS conflict [diffview-panel]" }, },
            { "n", "<a-3>", actions.conflict_choose_all "theirs", { desc = "Git: choose ALL THEIRS conflict [diffview-panel]" }, },
            { "n", "<a-0>", actions.conflict_choose_all "base", { desc = "Git: choose ALL BASE conflict [diffview-panel]" }, },
            { "n", "<a-2>", actions.conflict_choose_all "all", { desc = "Git: choose ALL BOTH conflict [diffview-panel]" }, },

            { "n", "<Leader>mcD", actions.conflict_choose_all "none", { desc = "Git: delete all region conflict [diffview-panel]" }, },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "g?", actions.help "file_panel", { desc = "Git: open the help panel [diffview-panel]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-panel]" } },
            { "n", "i", actions.listing_style, { desc = "Git: toggle between 'list' and 'tree' views [diffview-panel]" }, },
          },
          --stylua: ignore
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },

            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },

            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "<CR>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },

            { "n", "h", false },

            { "n", "<Leader>goo", actions.open_in_diffview, { desc = "Git: open the entry under the cursor in a diffview [diffview-history]" }, },
            { "n", "<Leader>my", actions.copy_hash, { desc = "Git: copy the commit hash of the entry under the cursor [diffview-history]" }, },
            { "n", "P", actions.open_commit_log, { desc = "Git: show or preview commit details [diffview-history]" } },

            { "n", "X", actions.restore_entry, { desc = "Git: restore file to the state from the selected entry [diffview-history]" }, },

            --  ───────────────────────────────[ FOLD ]────────────────────────────
            { "n", "<C-a>", actions.toggle_fold, { desc = "Git: toggle fold [diffview-history]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold (alternative) [diffview-history]" } },
            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold (alternative-back) [diffview-history]" } },

            { "n", "zc", actions.close_all_folds, { desc = "Git: close all folds [diffview-history]" } },
            { "n", "zm", actions.close_all_folds, { desc = "Git: close all folds (alternative) [diffview-history]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: close all folds (alternative-back) [diffview-history]" }, },

            { "n", "zR", actions.open_all_folds, { desc = "Git: open all folds [diffview-history]" } },
            { "n", "zO", actions.open_all_folds, { desc = "Git: open all folds (alternative) [diffview-history]" } },

            --  ──────────────────────────────[ SCROLL ]───────────────────────────
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll view up [diffview-history]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll view down [diffview-history]" } },

            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: next select entry [diffview-history]" } },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-history]" }, },

            { "n", "gg", false },
            { "n", "G", false},

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>be", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-history]" }, },
            { "n", "<Leader>bs", actions.goto_file_split, { desc = "Git: open in split [diffview-view]" } },
            { "n", "<Leader>bt", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-history]" } },

            --  ──────────────────[ OPEN FILE MANAGER FOR DIFFVIEW ]───────────────
            { "n", "<Leader>uE", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-history]" } },
            { "n", "<Leader>ue", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-history]" } },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "g?", actions.help "file_history_panel", { desc = "Git: open the help panel [diffview-history]" } },
            { "n", "g!", actions.options, { desc = "Git: open the option panel [diffview-history]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-history]" } },
          },
        },
      }
    end,
  },
  -- CODEDIFF
  {
    "esmuellert/codediff.nvim",
    cmd = "VscodeDiff",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<Leader>goc",
        function()
          vim.cmd "VscodeDiff"
        end,
        desc = "Git: CodeDiff [vscode-diff]",
        mode = { "n", "x" },
      },
    },
    opts = {
      keymaps = {
        view = {
          quit = "q", -- Close diff tab
          toggle_explorer = "<Leader>ue", -- Toggle explorer
          next_hunk = "<C-n>",
          prev_hunk = "<C-p>",
          next_file = "<A-n>",
          prev_file = "<A-p>",
          diff_get = "do", -- Get change from other buffer (like vimdiff)
          diff_put = "dp", -- Put change to other buffer (like vimdiff)
        },
        explorer = {
          select = "<CR>",
          hover = "K",
          refresh = "R",
          toggle_view_mode = "i",

          toggle_stage = "s",
          stage_all = "S",
          unstage_all = "U",
          restore = "X",
        },
        conflict = {
          accept_incoming = "<a-3>", -- Accept incoming (theirs/left) change
          accept_current = "<a-1>", -- Accept current (ours/right) change
          accept_both = "<a-2>", -- Accept both changes (incoming first)
          discard = "<Leader>mcD", -- Discard both, keep base
          next_conflict = "<Leader>mcn", -- Jump to next conflict
          prev_conflict = "<Leader>mcp", -- Jump to previous conflict
          -- Vimdiff-style numbered diffget (from result buffer)
          diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
          diffget_current = "3do", -- Get hunk from current (right/ours) buffer
        },
      },
    },
  },
  -- NEOGIT
  {
    "NeogitOrg/neogit",
    -- dependencies = {
    --   "nvim-lua/plenary.nvim",
    --   "sindrets/diffview.nvim", -- optional - Diff integration
    -- },
    cmd = { "Neogit", "NeogitCommit" },
    keys = {
      {
        "<Leader>mo",
        "",
        desc = "Popup (No desc, check g? help)",
        ft = { "NeogitStatus", "NeogitLogView", "NeogitCommitView" },
      },

      {
        "<Leader>gg",
        function()
          vim.cmd "Neogit"
          vim.cmd "wincmd ="
        end,
        desc = "Git: open neogit [neogit]",
        mode = { "n", "x" },
      },
    },
    opts = {
      kind = "vsplit",
      signs = {
        section = { "", "" }, -- "󰁙", "󰁊"
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
      mappings = {
        commit_view = {
          ["o"] = false,

          ["a"] = "OpenFileInWorktree",

          ["<Leader>mY"] = "OpenTree",

          ["<Leader>be"] = "GoToFile",
          ["<Leader>bv"] = "VSplitOpen",
          ["<Leader>bs"] = "SplitOpen",
          ["<Leader>bt"] = "TabOpen",

          ["g?"] = "HelpPopup",
        },

        rebase_editor = {
          ["q"] = false,
        },
        status = {
          ["q"] = false,
          ["<c-v>"] = false,
          ["<c-x>"] = false,
          ["<c-t>"] = false,
          ["Y"] = false,
          ["o"] = false,

          ["<Leader>be"] = "GoToFile",
          ["<Leader>bv"] = "VSplitOpen",
          ["<Leader>bs"] = "SplitOpen",
          ["<Leader>bt"] = "TabOpen",

          ["<Leader>mP"] = "PeekFile",
          ["<Leader>my"] = "YankSelected",
          ["<Leader>mO"] = "OpenTree",

          ["<Leader>mY"] = "OpenTree",
        },
        finder = {
          ["<c-c>"] = false,
          ["<esc>"] = false,
        },
        popup = {
          ["t"] = false,
          ["m"] = false,
          ["w"] = false,
          ["l"] = false,
          ["L"] = false,
          ["v"] = false,
          ["d"] = false,
          ["<esc>"] = false,
          ["?"] = false,
          ["b"] = false,
          ["B"] = false,
          ["M"] = false,
          ["Z"] = false,
          ["o"] = false,
          -- ["i"] = false,

          -- ["<Leader>mm"] = "IgnorePopup",
          ["<Leader>mot"] = "TagPopup",
          ["<Leader>mom"] = "MergePopup",
          ["<Leader>moM"] = "MarginPopup",
          ["<Leader>mor"] = "RemotePopup",
          ["<Leader>mow"] = "WorktreePopup",
          ["<Leader>moR"] = "RevertPopup",
          ["<Leader>mod"] = "DiffPopup",
          ["<Leader>mob"] = "BranchPopup",
          ["<Leader>moB"] = "BisectPopup",
          ["<Leader>mos"] = "StashPopup",

          ["<Leader>ml"] = "LogPopup",

          ["g?"] = "HelpPopup",
        },
      },
      integrations = {
        diffview = true,
        -- telescope = true,
        fzf_lua = true,
      },
    },
  },
  -- MINI.DIFF (disabled)
  {
    "nvim-mini/mini.diff", -- Inline and better diff over the default
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
