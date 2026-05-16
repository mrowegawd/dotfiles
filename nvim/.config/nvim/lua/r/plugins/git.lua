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
    topdelete = { text = "" }, -- '‾'
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
        "<Leader>gy",
        function()
          require("git-link.main").copy_line_url()
        end,
        desc = "Git: yank/copy line [git-link.nvim]",
        mode = { "n", "x" },
      },
      {
        "<Leader>gob",
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
    --"MadKuntilanak/octo.nvim",
    dir = "~/.local/src/nvim_plugins/octo.nvim",
    branch = "feat/next-updates",
    cmd = "Octo",
    keys = {
      { "<LocalLeader>qa", "", desc = "add", ft = "octo" },
      { "<LocalLeader>qar", "", desc = "reactions", ft = "octo" },
      { "<LocalLeader>qr", "", desc = "delete/remove", ft = "octo" },
      { "<LocalLeader>qc", "", desc = "create/checkout/merge", ft = "octo" },
      { "<LocalLeader>qv", "", desc = "view/diff", ft = "octo" },

      { "<LocalLeader>qR", "", desc = "reviewer", ft = "octo" },
      { "<LocalLeader>qt", "", desc = "thread", ft = "octo" },
      { "<LocalLeader>qn", "", desc = "notifications", ft = "octo" },
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
          open_in_browser = { lhs = "<Leader>gob", desc = "open issue in browser [discussion]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [discussion]" },
          add_comment = { lhs = "<LocalLeader>qac", desc = "add comment [discussion]" },
          add_reply = { lhs = "<LocalLeader>qay", desc = "add reply [discussion]" },
          add_label = { lhs = "<LocalLeader>qal", desc = "add label [discussion]" },

          delete_comment = { lhs = "<LocalLeader>qrc", desc = "delete comment [discussion]" },
          remove_label = { lhs = "<LocalLeader>qrl", desc = "remove label [discussion]" },

          next_comment = { lhs = "<c-n>", desc = "go to next comment [discussion]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [discussion]" },

          react_hooray = { lhs = "<LocalLeader>qarp", desc = "add/remove 🎉 reaction [discussion]" },
          react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [discussion]" },
          react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [discussion]" },
          react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [discussion]" },
          react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [discussion]" },
          react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [discussion]" },
          react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [discussion]" },
          react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [discussion]" },
        },
        runs = {
          expand_step = { lhs = "o", desc = "expand workflow step [runs]" },
          open_in_browser = { lhs = "<Leader>gob", desc = "open workflow run in browser [runs]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [runs]" },
          refresh = { lhs = "<C-r>", desc = "refresh workflow [runs]" },
          rerun = { lhs = "<C-o>", desc = "rerun workflow [runs]" },
          rerun_failed = { lhs = "<C-f>", desc = "rerun failed workflow [runs]" },
          cancel = { lhs = "<C-x>", desc = "cancel workflow [runs]" },
        },
        issue = {
          close_issue = { lhs = "<LocalLeader>qC", desc = "close issue [issue]" },
          reopen_issue = { lhs = "<LocalLeader>qaI", desc = "reopen issue [issue]" },
          list_issues = { lhs = "<LocalLeader>qf", desc = "list open issues on same repo [octo [issue]" },
          reload = { lhs = "R", desc = "reload issue [issue]" },

          open_in_browser = { lhs = "<Leader>gob", desc = "open issue in browser [issue]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [issue]" },

          add_assignee = { lhs = "<LocalLeader>qA", desc = "add assignee [issue]" },

          create_label = { lhs = "<LocalLeader>qcl", desc = "create label [issue]" },
          add_label = { lhs = "<LocalLeader>qal", desc = "add label [issue]" },

          remove_label = { lhs = "<LocalLeader>qrl", desc = "remove label [issue]" },
          remove_assignee = { lhs = "<LocalLeader>qrA", desc = "remove assignee [issue]" },

          goto_issue = { lhs = "<LocalLeader>qo", desc = "go to issue/pr/discussion under cursor [issue]" },

          add_comment = { lhs = "<LocalLeader>qac", desc = "add comment [issue]" },
          add_reply = { lhs = "<LocalLeader>qay", desc = "add reply [issue]" },
          delete_comment = { lhs = "<LocalLeader>qrc", desc = "delete comment [issue]" },

          next_comment = { lhs = "<c-n>", desc = "go to next comment [issue]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [issue]" },

          react_hooray = { lhs = "<LocalLeader>qaro", desc = "add/remove 🎉 reaction [issue]" },
          react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [issue]" },
          react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [issue]" },
          react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [issue]" },
          react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [issue]" },
          react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [issue]" },
          react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [issue]" },
          react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [issue]" },
        },
        pull_request = {
          checkout_pr = { lhs = "<LocalLeader>qco", desc = "checkout PR [pull request]" },
          merge_pr = { lhs = "<LocalLeader>qcm", desc = "merge commit PR [pull request]" },

          squash_and_merge_pr = { lhs = "<LocalLeader>qcs", desc = "squash and merge PR [pull request]" },
          rebase_and_merge_pr = { lhs = "<LocalLeader>qcr", desc = "rebase and merge PR [pull request]" },

          merge_pr_queue = {
            lhs = "<LocalLeader>qcP",
            desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          squash_and_merge_queue = {
            lhs = "<LocalLeader>qcS",
            desc = "squash and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          rebase_and_merge_queue = {
            lhs = "<LocalLeader>qcR",
            desc = "rebase and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          list_commits = { lhs = "<LocalLeader>qvf", desc = "list PR commits [pull request]" },
          list_changed_files = { lhs = "<LocalLeader>qvF", desc = "list PR changed files [pull request]" },
          show_pr_diff = { lhs = "<LocalLeader>qvd", desc = "show PR diff [pull request]" },

          close_issue = { lhs = "<LocalLeader>qC", desc = "close PR [pull request]" },
          reopen_issue = { lhs = "<LocalLeader>qaI", desc = "reopen PR [pull request]" },
          list_issues = { lhs = "<LocalLeader>qf", desc = "list open issues on same repo [pull request]" },
          reload = { lhs = "R", desc = "reload PR [pull request]" },
          open_in_browser = { lhs = "<Leader>gob", desc = "open PR in browser [pull request]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [pull request]" },
          goto_file = { lhs = "gf", desc = "go to file [pull request]" },

          add_assignee = { lhs = "<LocalLeader>qA", desc = "add assignee [pull request]" },
          remove_assignee = { lhs = "<LocalLeader>qrA", desc = "remove assignee [pull request]" },

          create_label = { lhs = "<LocalLeader>qcl", desc = "create label [pull request]" },
          add_label = { lhs = "<LocalLeader>qal", desc = "add label [pull request]" },

          copy_sha = { lhs = "<Leader>gY", desc = "copy commit SHA to system clipboard [pull request]" },
          remove_label = { lhs = "<LocalLeader>qrl", desc = "remove label [pull request]" },
          goto_issue = { lhs = "<LocalLeader>qo", desc = "go to issue/pr/discussion under cursor [pull request]" },

          add_comment = { lhs = "<LocalLeader>qac", desc = "add comment [pull request]" },
          add_reply = { lhs = "<LocalLeader>qay", desc = "add reply [pull request]" },
          delete_comment = { lhs = "<LocalLeader>qrc", desc = "delete comment [pull request]" },

          next_comment = { lhs = "<c-n>", desc = "go to next comment [pull request]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [pull request]" },

          add_reviewer = { lhs = "<LocalLeader>qRa", desc = "add reviewer [pull request]" },
          remove_reviewer = { lhs = "<LocalLeader>qRd", desc = "remove reviewer request [pull request]" },
          review_start = { lhs = "<LocalLeader>qRs", desc = "start a review for the current PR [pull request]" },
          review_resume = {
            lhs = "<LocalLeader>qRr",
            desc = "resume a pending review for the current PR [pull request]",
          },

          react_hooray = { lhs = "<LocalLeader>qaro", desc = "add/remove 🎉 reaction [pull request]" },
          react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [pull request]" },
          react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [pull request]" },
          react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [pull request]" },
          react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [pull request]" },
          react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [pull request]" },
          react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [pull request]" },
          react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [pull request]" },

          resolve_thread = { lhs = "<LocalLeader>qtt", desc = "resolve PR thread [pull request]" },
          unresolve_thread = { lhs = "<LocalLeader>qtU", desc = "unresolve PR thread [pull request]" },
        },
        review_thread = {
          goto_issue = { lhs = "<LocalLeader>qo", desc = "go to issue/pr/discussion under cursor [review thread]" },
          add_comment = { lhs = "<LocalLeader>qac", desc = "add comment [review thread]" },
          add_reply = { lhs = "<LocalLeader>qay", desc = "add reply [review thread]" },
          add_suggestion = { lhs = "<LocalLeader>qas", desc = "add suggestion [review thread]" },
          delete_comment = { lhs = "<LocalLeader>qrc", desc = "delete comment [review thread]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [review thread]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [review thread]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review thread]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review thread]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review thread]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review thread]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review thread]" },

          react_hooray = { lhs = "<LocalLeader>qaro", desc = "add/remove 🎉 reaction [review thread]" },
          react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [review thread]" },
          react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [review thread]" },
          react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [review thread]" },
          react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [review thread]" },
          react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [review thread]" },
          react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [review thread]" },
          react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [review thread]" },

          resolve_thread = { lhs = "<LocalLeader>qtt", desc = "resolve PR thread [review thread]" },
          unresolve_thread = { lhs = "<LocalLeader>qtU", desc = "unresolve PR thread [review thread]" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review [submit win]" },
          comment_review = { lhs = "<C-m>", desc = "comment review [submit win]" },
          request_changes = { lhs = "<C-r>", desc = "request changes review [submit win]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [submit win]" },
        },
        review_diff = {
          submit_review = { lhs = "<LocalLeader>qRS", desc = "submit review [review diff]" },
          discard_review = { lhs = "<LocalLeader>qRd", desc = "discard review [review diff]" },
          add_review_comment = { lhs = "<LocalLeader>qac", desc = "add a new review comment [review diff]" },
          add_review_suggestion = { lhs = "<LocalLeader>qaS", desc = "add a new review suggestion [review diff]" },
          focus_files = { lhs = "<Leader>oe", desc = "move focus to changed file panel [review diff]" },
          toggle_files = { lhs = "<Leader>oE", desc = "hide/show changed files panel [review diff]" },
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

          goto_file = { lhs = "<Leader>oe", desc = "go to file [review diff]" },
          copy_sha = { lhs = "<Leader>gY", desc = "copy commit SHA to system clipboard [review diff]" },
          review_commits = { lhs = "<space>mC", desc = "review PR commits [review diff]" },
        },
        file_panel = {
          submit_review = { lhs = "<LocalLeader>qRS", desc = "submit review [file panel]" },
          discard_review = { lhs = "<LocalLeader>qRd", desc = "discard review [file panel]" },
          next_entry = { lhs = "j", desc = "move to next changed file [file panel]" },
          prev_entry = { lhs = "k", desc = "move to previous changed file [file panel]" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs [file panel]" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel [file panel]" },
          focus_files = { lhs = "<Leader>oe", desc = "move focus to changed file panel [file panel]" },
          toggle_files = { lhs = "<Leader>oE", desc = "hide/show changed files panel [file panel]" },
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
          read = { lhs = "<LocalLeader>qnr", desc = "mark notification as read [notification]" },
          done = { lhs = "<LocalLeader>qnd", desc = "mark notification as done [notification]" },
          unsubscribe = { lhs = "<LocalLeader>qnu", desc = "unsubscribe from notifications [notification]" },
        },
        repo = {
          create_issue = { lhs = "<LocalLeader>qci", desc = "create issue [repo]" },
          create_discussion = { lhs = "<LocalLeader>qcd", desc = "create discussion [repo]" },
          contributing_guidelines = { lhs = "<LocalLeader>qcG", desc = "view contributing guidelines [repo]" },
          open_in_browser = { lhs = "<Leader>gob", desc = "open repo in browser [repo]" },
        },
        release = {
          open_in_browser = { lhs = "<Leader>gob", desc = "open release in browser [release]" },
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
    cmd = { "GitToggleDelete", "GitToggleWordDiff", "GitToggleLineHl", "GitBlame", "GitBlameLine" },
    opts = {
      -- debug_mode = true,
      signs_staged_enable = false,
      attach_to_untracked = true,
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
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

        map("n", "<Leader>gb", gs.blame_line, "Git: blame line [gitsigns]")
        map("n", "<Leader>gB", gs.blame, "Git: blame [gitsigns]")

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
        -- map("n", "gn", function()
        --   if vim.wo.diff then
        --     vim.cmd.normal { "]c", bang = true }
        --   else
        --     vim.schedule(function()
        --       gs.nav_hunk("next", { navigation_message = false, foldopen = true })
        --     end)
        --   end
        -- end, "Git: next hunk [gitsigns]")
        -- map("n", "gp", function()
        --   if vim.wo.diff then
        --     vim.cmd.normal { "[c", bang = true }
        --   else
        --     vim.schedule(function()
        --       gs.nav_hunk("prev", { navigation_message = false, foldopen = true })
        --     end)
        --   end
        -- end, "Git: prev hunk [gitsigns]")
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
    },
    dependencies = { "tpope/vim-rhubarb" },
    config = function()
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
          vim.keymap.set("n", "<tab>", "=zt", { buffer = e.buf, remap = true })

          vim.keymap.set("n", "<Leader>os", "o", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<Leader>oe", "o", { buffer = e.buf, remap = true })

          vim.keymap.set("n", "<Leader>ot", "O", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<Leader>ov", "gO", { buffer = e.buf, remap = true })
        end,
      }, {
        event = "BufWinEnter",
        pattern = "*.git/COMMIT_EDITMSG",
        command = function()
          -- If it's a new commit, start in insert mode, otherwise start in normal mode
          if vim.fn.getline(1) == "" then
            vim.cmd "15 wincmd K"
            vim.cmd "normal! gg0"
            if vim.api.nvim_get_current_line() == "" then
              vim.cmd "startinsert"
            end
          end
        end,
      })
    end,
  },
  -- DIFFVIEW
  {
    "dlyongemallo/diffview.nvim",
    event = "LazyFile",
    keys = {
      { "<LocalLeader>qc", "", desc = "conflict", ft = { "DiffviewFiles", "DiffviewFileHistory" } },
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
            { "n", "gn", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-view]" }, },
            { "n", "gp", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview-view]" } },

            { "n", "[F", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview-view]" } },
            { "n", "]F", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview-view]" } },

            { "n", "h", false },

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>oe", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-view]" } },
            { "n", "<Leader>os", actions.goto_file_split, { desc = "Git: open in split [diffview-view]" } },
            { "n", "<Leader>ot", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-view]" } },

            { "n", "<Leader>oe", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-view]" } },
            { "n", "<Leader>oE", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-view]" } },

            --  ───────────────────────────[ GIT CONFLICT ]────────────────────────
            { "n", "<S-Down>", actions.next_conflict, { desc = "Git: next conflict [diffview-view]" } },
            { "n", "<S-Up>", actions.prev_conflict, { desc = "Git: prev conflict [diffview-view]" } },

            { "n", "<a-1>", actions.conflict_choose "ours", { desc = "Git: choose OURS conflict [diffview-view]" } },
            { "n", "<a-3>", actions.conflict_choose "theirs", { desc = "Git: choose THEIRS conflict [diffview-view]" }, },
            { "n", "<a-0>", actions.conflict_choose "base", { desc = "Git: choose BASE (kosong) conflict [diffview-view]" } },
            { "n", "<a-2>", actions.conflict_choose "all", { desc = "Git: choose BOTH conflict [diffview-view]" } },

            { "n", "<LocalLeader>qcN", actions.conflict_choose "none", { desc = "Git: delete region conflict [diffview-view]" } },
            { "n", "<LocalLeader>qcA", actions.conflict_choose_all "none", { desc = "Git: delete all region conflict [diffview-view]" }, },

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

            { "n", "gn", actions.select_next_entry, { desc = "Git: next select entry [diffview-panel]" }, },
            { "n", "gp", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-panel]" }, },

            { "n", "gg", false },
            { "n", "G", false},

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>oe", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-panel]" }, },
            { "n", "<Leader>os", actions.goto_file_split, { desc = "Git: open in split [diffview-panel]" }, },
            { "n", "<Leader>ot", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-panel]" }, },

            { "n", "R", actions.refresh_files, { desc = "Git: update stats and entries in the file list [diffview-panel]" }, },

            --  ──────────────────[ OPEN FILE MANAGER FOR DIFFVIEW ]───────────────
            { "n", "<Leader>oe", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-panel]" }, },
            { "n", "<Leader>oE", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-panel]" } },

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
            { "n", "<S-Down>", actions.next_conflict, { desc = "Git: next git conflict [diffview-panel]" } },
            { "n", "<S-Up>", actions.prev_conflict, { desc = "Git: prev git conflict [diffview-panel]" } },

            { "n", "<a-1>", actions.conflict_choose_all "ours", { desc = "Git: choose ALL OURS conflict [diffview-panel]" }, },
            { "n", "<a-3>", actions.conflict_choose_all "theirs", { desc = "Git: choose ALL THEIRS conflict [diffview-panel]" }, },
            { "n", "<a-0>", actions.conflict_choose_all "base", { desc = "Git: choose ALL BASE conflict [diffview-panel]" }, },
            { "n", "<a-2>", actions.conflict_choose_all "all", { desc = "Git: choose ALL BOTH conflict [diffview-panel]" }, },

            { "n", "<LocalLeader>qcD", actions.conflict_choose_all "none", { desc = "Git: delete all region conflict [diffview-panel]" }, },

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
            { "n", "<Leader>gy", actions.copy_hash, { desc = "Git: copy the commit hash of the entry under the cursor [diffview-history]" }, },
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

            { "n", "gn", actions.select_next_entry, { desc = "Git: next select entry [diffview-history]" } },
            { "n", "gp", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-history]" }, },

            { "n", "gg", false },
            { "n", "G", false},

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>oe", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-history]" }, },
            { "n", "<Leader>os", actions.goto_file_split, { desc = "Git: open in split [diffview-view]" } },
            { "n", "<Leader>ot", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-history]" } },

            --  ──────────────────[ OPEN FILE MANAGER FOR DIFFVIEW ]───────────────
            { "n", "<Leader>oe", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-history]" } },
            { "n", "<Leader>oE", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-history]" } },

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
          quit = "<Leader>bk",
          toggle_explorer = "<Leader>oo",
          next_hunk = "<c-n>",
          prev_hunk = "<c-p>",
          next_file = "gn",
          prev_file = "gp",
          diff_get = "do", -- Get change from other buffer (like vimdiff)
          diff_put = "dp", -- Put change to other buffer (like vimdiff)
          stage_hunk = "<Leader>gs",
          unstage_hunk = "<Leader>gu",
          discard_hunk = "<Leader>hr",
          toggle_layout = "<F4>", -- Toggle diff layout for the current codediff session
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
          accept_current = "<a-0>", -- Accept current (ours/right) change
          accept_both = "<a-2>", -- Accept both changes (incoming first)
          discard = "<LocalLeader>qD", -- Discard both, keep base
          next_conflict = "<LocalLeader>qcn", -- Jump to next conflict
          prev_conflict = "<LocalLeader>qcp", -- Jump to previous conflict
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
    cmd = { "Neogit", "NeogitCommit" },
    keys = {
      {
        "<LocalLeader>qo",
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

          ["<Leader>qY"] = "OpenTree",

          ["<Leader>oe"] = "GoToFile",
          ["<Leader>ov"] = "VSplitOpen",
          ["<Leader>os"] = "SplitOpen",
          ["<Leader>ot"] = "TabOpen",

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

          ["<Leader>oe"] = "GoToFile",
          ["<Leader>ov"] = "VSplitOpen",
          ["<Leader>os"] = "SplitOpen",
          ["<Leader>ot"] = "TabOpen",

          ["<LocalLeader>qP"] = "PeekFile",
          ["<LocalLeader>qy"] = "YankSelected",
          ["<LocalLeader>qO"] = "OpenTree",

          ["<LocalLeader>qY"] = "OpenTree",
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

          ["<LocalLeader>qot"] = "TagPopup",
          ["<LocalLeader>qom"] = "MergePopup",
          ["<LocalLeader>qoM"] = "MarginPopup",
          ["<LocalLeader>qor"] = "RemotePopup",
          ["<LocalLeader>qow"] = "WorktreePopup",
          ["<LocalLeader>qoR"] = "RevertPopup",
          ["<LocalLeader>qod"] = "DiffPopup",
          ["<LocalLeader>qob"] = "BranchPopup",
          ["<LocalLeader>qoB"] = "BisectPopup",
          ["<LocalLeader>qos"] = "StashPopup",

          ["<LocalLeader>ql"] = "LogPopup",

          ["g?"] = "HelpPopup",
        },
      },
      integrations = {
        diffview = true,
        telescope = false,
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
