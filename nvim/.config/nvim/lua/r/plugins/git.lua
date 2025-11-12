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
  "base46-material-darker",
  "lackluster",
  "neogotham",
  "rose-pine",
  "vscode_modern",
  "y9nika",
  "darcubox",
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
      { "<Leader>Gcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
      { "<Leader>Gce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
      { "<Leader>Gco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
      { "<Leader>Gcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
      { "<Leader>Gcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
      { "<Leader>Gi", "", desc = "+Issues" },
      { "<Leader>Gip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
      { "<Leader>Gio", "<cmd>GHOpenIssue<cr>", desc = "Open" },
      { "<Leader>Gl", "", desc = "+Litee" },
      { "<Leader>Glt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
      { "<Leader>Gp", "", desc = "+Pull Request" },
      { "<Leader>Gpc", "<cmd>GHClosePR<cr>", desc = "Close" },
      { "<Leader>Gpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
      { "<Leader>Gpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
      { "<Leader>Gpo", "<cmd>GHOpenPR<cr>", desc = "Open" },
      { "<Leader>Gpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
      { "<Leader>Gpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
      { "<Leader>Gpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
      { "<Leader>Gpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
      { "<Leader>Gr", "", desc = "+Review" },
      { "<Leader>Grb", "<cmd>GHStartReview<cr>", desc = "Begin" },
      { "<Leader>Grc", "<cmd>GHCloseReview<cr>", desc = "Close" },
      { "<Leader>Grd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
      { "<Leader>Gre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
      { "<Leader>Grs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
      { "<Leader>Grz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
      { "<Leader>Gt", "", desc = "+Threads" },
      { "<Leader>Gtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
      { "<Leader>Gtn", "<cmd>GHNextThread<cr>", desc = "Next" },
      { "<Leader>Gtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
    },
    config = function(_, opts)
      require("litee.lib").setup()
      require("litee.gh").setup(opts)
    end,
  },
  -- GITLINKER
  {
    "ruifm/gitlinker.nvim", -- generate shareable file permalinks
    keys = {
      {
        "<Leader>gob",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        mode = { "n", "x" },
        desc = "Git: open range hash on browser (normal or visual) [gitlinker]",
      },
      {
        "<Leader>goB",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        desc = "Git: open repo on browser [gitlinker]",
      },
      { "<Leader>gY", desc = "Git: copy hash link [gitlinker]" },
    },
    opts = { mappings = "<Leader>gY" },
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
      { "<Leader>gr", "", desc = "reactions", ft = "octo" },
      { "<Leader>gp", "", desc = "check pr", ft = "octo" },
      { "<Leader>gi", "", desc = "issue", ft = "octo" },
      { "<Leader>ga", "", desc = "assignee", ft = "octo" },
      { "<Leader>gc", "", desc = "comments", ft = "octo" },
      { "<Leader>gl", "", desc = "label", ft = "octo" },
      { "<Leader>gf", "", desc = "files", ft = "octo" },
      { "<Leader>gm", "", desc = "merge", ft = "octo" },
      { "<Leader>gR", "", desc = "reviewer", ft = "octo" },
    },
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = {
      -- picker = "snacks",
      picker = "fzf-lua",
      -- picker = "telescope",
      picker_config = {
        use_emojis = true,
        mappings = {
          -- open_in_browser = { lhs = "<Leader>bo", desc = "open issue in browser" },
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
          open_in_browser = { lhs = "<Leader>goo", desc = "open issue in browser [discussion]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [discussion]" },
          add_comment = { lhs = "<Leader>gca", desc = "add comment [discussion]" },
          add_reply = { lhs = "<Leader>gcr", desc = "add reply [discussion]" },
          delete_comment = { lhs = "<Leader>gcd", desc = "delete comment [discussion]" },
          add_label = { lhs = "<Leader>gla", desc = "add label [discussion]" },
          remove_label = { lhs = "<Leader>glc", desc = "remove label [discussion]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [discussion]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [discussion]" },
          react_hooray = { lhs = "<Leader>grp", desc = "add/remove 🎉 reaction [discussion]" },
          react_heart = { lhs = "<Leader>grh", desc = "add/remove ❤️ reaction [discussion]" },
          react_eyes = { lhs = "<Leader>gre", desc = "add/remove 👀 reaction [discussion]" },
          react_thumbs_up = { lhs = "<Leader>gr+", desc = "add/remove 👍 reaction [discussion]" },
          react_thumbs_down = { lhs = "<Leader>gr-", desc = "add/remove 👎 reaction [discussion]" },
          react_rocket = { lhs = "<Leader>grr", desc = "add/remove 🚀 reaction [discussion]" },
          react_laugh = { lhs = "<Leader>grl", desc = "add/remove 😄 reaction [discussion]" },
          react_confused = { lhs = "<Leader>grc", desc = "add/remove 😕 reaction [discussion]" },
        },
        runs = {
          expand_step = { lhs = "o", desc = "expand workflow step [runs]" },
          open_in_browser = { lhs = "<Leader>goo", desc = "open workflow run in browser [runs]" },
          refresh = { lhs = "<C-r>", desc = "refresh workflow [runs]" },
          rerun = { lhs = "<C-o>", desc = "rerun workflow [runs]" },
          rerun_failed = { lhs = "<C-f>", desc = "rerun failed workflow [runs]" },
          cancel = { lhs = "<C-x>", desc = "cancel workflow [runs]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [runs]" },
        },
        issue = {
          close_issue = { lhs = "<Leader>gic", desc = "close issue [issue]" },
          reopen_issue = { lhs = "<Leader>gio", desc = "reopen issue [issue]" },
          list_issues = { lhs = "<Leader>gil", desc = "list open issues on same repo [octo [issue]" },
          reload = { lhs = "<C-r>", desc = "reload issue [issue]" },
          open_in_browser = { lhs = "<Leader>goo", desc = "open issue in browser [issue]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [issue]" },
          add_assignee = { lhs = "<Leader>gaa", desc = "add assignee [issue]" },
          remove_assignee = { lhs = "<Leader>gad", desc = "remove assignee [issue]" },
          create_label = { lhs = "<Leader>glc", desc = "create label [issue]" },
          add_label = { lhs = "<Leader>gla", desc = "add label [issue]" },
          remove_label = { lhs = "<Leader>glc", desc = "remove label [issue]" },
          goto_issue = { lhs = "<Leader>gii", desc = "go to issue/pr/discussion under cursor [issue]" },
          add_comment = { lhs = "<Leader>gca", desc = "add comment [issue]" },
          add_reply = { lhs = "<Leader>gcr", desc = "add reply [issue]" },
          delete_comment = { lhs = "<Leader>gcd", desc = "delete comment [issue]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [issue]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [issue]" },
          react_hooray = { lhs = "<Leader>grp", desc = "add/remove 🎉 reaction [issue]" },
          react_heart = { lhs = "<Leader>grh", desc = "add/remove ❤️ reaction [issue]" },
          react_eyes = { lhs = "<Leader>gre", desc = "add/remove 👀 reaction [issue]" },
          react_thumbs_up = { lhs = "<Leader>gr+", desc = "add/remove 👍 reaction [issue]" },
          react_thumbs_down = { lhs = "<Leader>gr-", desc = "add/remove 👎 reaction [issue]" },
          react_rocket = { lhs = "<Leader>grr", desc = "add/remove 🚀 reaction [issue]" },
          react_laugh = { lhs = "<Leader>grl", desc = "add/remove 😄 reaction [issue]" },
          react_confused = { lhs = "<Leader>grc", desc = "add/remove 😕 reaction [issue]" },
        },
        pull_request = {
          checkout_pr = { lhs = "<Leader>gpo", desc = "checkout PR [pull request]" },
          merge_pr = { lhs = "<Leader>gmm", desc = "merge commit PR [pull request]" },
          squash_and_merge_pr = { lhs = "<Leader>gms", desc = "squash and merge PR [pull request]" },
          rebase_and_merge_pr = { lhs = "<Leader>gmr", desc = "rebase and merge PR [pull request]" },
          merge_pr_queue = {
            lhs = "<Leader>gmP",
            desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          squash_and_merge_queue = {
            lhs = "<Leader>gmS",
            desc = "squash and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          rebase_and_merge_queue = {
            lhs = "<Leader>gmR",
            desc = "rebase and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          },
          list_commits = { lhs = "<Leader>gpc", desc = "list PR commits [pull request]" },
          list_changed_files = { lhs = "<Leader>gff", desc = "list PR changed files [pull request]" },
          show_pr_diff = { lhs = "<Leader>gvd", desc = "show PR diff [pull request]" },
          add_reviewer = { lhs = "<Leader>gRa", desc = "add reviewer [pull request]" },
          remove_reviewer = { lhs = "<Leader>gRd", desc = "remove reviewer request [pull request]" },
          close_issue = { lhs = "<Leader>gic", desc = "close PR [pull request]" },
          reopen_issue = { lhs = "<Leader>gio", desc = "reopen PR [pull request]" },
          list_issues = { lhs = "<Leader>gil", desc = "list open issues on same repo [pull request]" },
          reload = { lhs = "R", desc = "reload PR [pull request]" },
          open_in_browser = { lhs = "<Leader>goo", desc = "open PR in browser [pull request]" },
          copy_url = { lhs = "<Leader>gy", desc = "copy url to system clipboard [pull request]" },
          goto_file = { lhs = "<Leader>be", desc = "go to file [pull request]" },
          add_assignee = { lhs = "<Leader>gaa", desc = "add assignee [pull request]" },
          remove_assignee = { lhs = "<Leader>gad", desc = "remove assignee [pull request]" },
          create_label = { lhs = "<Leader>glc", desc = "create label [pull request]" },
          add_label = { lhs = "<Leader>gla", desc = "add label [pull request]" },
          copy_sha = { lhs = "<Leader>gY", desc = "copy commit SHA to system clipboard [pull request]" },
          remove_label = { lhs = "<Leader>gld", desc = "remove label [pull request]" },
          goto_issue = { lhs = "<Leader>gii", desc = "go to issue/pr/discussion under cursor [pull request]" },
          add_comment = { lhs = "<Leader>gca", desc = "add comment [pull request]" },
          add_reply = { lhs = "<Leader>gcr", desc = "add reply [pull request]" },
          delete_comment = { lhs = "<Leader>gcd", desc = "delete comment [pull request]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [pull request]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [pull request]" },
          react_hooray = { lhs = "<Leader>grp", desc = "add/remove 🎉 reaction [pull request]" },
          react_heart = { lhs = "<Leader>grh", desc = "add/remove ❤️ reaction [pull request]" },
          react_eyes = { lhs = "<Leader>gre", desc = "add/remove 👀 reaction [pull request]" },
          react_thumbs_up = { lhs = "<Leader>gr+", desc = "add/remove 👍 reaction [pull request]" },
          react_thumbs_down = { lhs = "<Leader>gr-", desc = "add/remove 👎 reaction [pull request]" },
          react_rocket = { lhs = "<Leader>grr", desc = "add/remove 🚀 reaction [pull request]" },
          react_laugh = { lhs = "<Leader>grl", desc = "add/remove 😄 reaction [pull request]" },
          react_confused = { lhs = "<Leader>grc", desc = "add/remove 😕 reaction [pull request]" },
          review_start = { lhs = "<Leader>gRs", desc = "start a review for the current PR [pull request]" },
          review_resume = { lhs = "<Leader>gRr", desc = "resume a pending review for the current PR [pull request]" },
          resolve_thread = { lhs = "<Leader>gRt", desc = "resolve PR thread [pull request]" },
          unresolve_thread = { lhs = "<Leader>gRT", desc = "unresolve PR thread [pull request]" },
        },
        review_thread = {
          goto_issue = { lhs = "<Leader>gii", desc = "go to issue/pr/discussion under cursor [review thread]" },
          add_comment = { lhs = "<Leader>gca", desc = "add comment [review thread]" },
          add_reply = { lhs = "<Leader>gcr", desc = "add reply [review thread]" },
          add_suggestion = { lhs = "<Leader>gsa", desc = "add suggestion [review thread]" },
          delete_comment = { lhs = "<Leader>gcd", desc = "delete comment [review thread]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [review thread]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [review thread]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review thread]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review thread]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review thread]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review thread]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review thread]" },
          react_hooray = { lhs = "<Leader>grp", desc = "add/remove 🎉 reaction [review thread]" },
          react_heart = { lhs = "<Leader>grh", desc = "add/remove ❤️ reaction [review thread]" },
          react_eyes = { lhs = "<Leader>gre", desc = "add/remove 👀 reaction [review thread]" },
          react_thumbs_up = { lhs = "<Leader>gr+", desc = "add/remove 👍 reaction [review thread]" },
          react_thumbs_down = { lhs = "<Leader>gr-", desc = "add/remove 👎 reaction [review thread]" },
          react_rocket = { lhs = "<Leader>grr", desc = "add/remove 🚀 reaction [review thread]" },
          react_laugh = { lhs = "<Leader>grl", desc = "add/remove 😄 reaction [review thread]" },
          react_confused = { lhs = "<Leader>grc", desc = "add/remove 😕 reaction [review thread]" },
          resolve_thread = { lhs = "<Leader>grt", desc = "resolve PR thread [review thread]" },
          unresolve_thread = { lhs = "<Leader>grT", desc = "unresolve PR thread [review thread]" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review [submit win]" },
          comment_review = { lhs = "<C-m>", desc = "comment review [submit win]" },
          request_changes = { lhs = "<C-r>", desc = "request changes review [submit win]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [submit win]" },
        },
        review_diff = {
          submit_review = { lhs = "<Leader>gRs", desc = "submit review [review diff]" },
          discard_review = { lhs = "<Leader>gRd", desc = "discard review [review diff]" },
          add_review_comment = { lhs = "<Leader>gRc", desc = "add a new review comment [review diff]" },
          add_review_suggestion = { lhs = "<Leader>Rs", desc = "add a new review suggestion [review diff]" },
          focus_files = { lhs = "<Leader>uE", desc = "move focus to changed file panel [review diff]" },
          toggle_files = { lhs = "<Leader>ue", desc = "hide/show changed files panel [review diff]" },
          next_thread = { lhs = "]t", desc = "move to next thread [review diff]" },
          prev_thread = { lhs = "[t", desc = "move to previous thread [review diff]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review diff]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review diff]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review diff]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review diff]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review diff]" },
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [review diff]" },
          goto_file = { lhs = "<Leader>be", desc = "go to file [review diff]" },
          copy_sha = { lhs = "<Leader>gY", desc = "copy commit SHA to system clipboard [review diff]" },
          review_commits = { lhs = "<space>Rc", desc = "review PR commits [review diff]" },
        },
        file_panel = {
          submit_review = { lhs = "<Leader>gRs", desc = "submit review [file panel]" },
          discard_review = { lhs = "<Leader>gRd", desc = "discard review [file panel]" },
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
          review_commits = { lhs = "<space>Rc", desc = "review PR commits [file panel]" },
        },
        notification = {
          read = { lhs = "<Leader>gnr", desc = "mark notification as read [notification]" },
          done = { lhs = "<Leader>gnd", desc = "mark notification as done [notification]" },
          unsubscribe = { lhs = "<Leader>gnu", desc = "unsubscribe from notifications [notification]" },
        },
        repo = {
          create_issue = { lhs = "<Leader>gcI", desc = "create issue [repo]" },
          create_discussion = { lhs = "<Leader>gcD", desc = "create discussion [repo]" },
          contributing_guidelines = { lhs = "<Leader>gcg", desc = "view contributing guidelines [repo]" },
          open_in_browser = { lhs = "<Leader>goo", desc = "open repo in browser [repo]" },
        },
        release = {
          open_in_browser = { lhs = "<Leader>goo", desc = "open release in browser [release]" },
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
        map("n", "<Leader>ghs", gs.stage_hunk, "Git: stage [gitsigns]")
        map("x", "<Leader>ghs", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.stage_hunk { from, to }
        end, "Git: stage (visual) [gitsigns]")
        map("n", "<Leader>ghr", gs.reset_hunk, "Git: reset [gitsigns]")
        map("x", "<Leader>ghr", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.reset_hunk { from, to }
        end, "Git: reset (visual) [gitsigns]")
        map("n", "<Leader>ghu", gs.undo_stage_hunk, "Git: undo [gitsigns]")
        map("n", "<Leader>ghS", gs.stage_buffer, "Git: stage buffer [gitsigns]")
        map("n", "<Leader>ghR", gs.reset_buffer, "Git: reset buffer [gitsigns]")

        -- Hunk preview
        map("n", "<Leader>gvp", gs.preview_hunk_inline, "Git: preview hunk inline [gitsigns]")
        map("n", "<Leader>gvP", gs.preview_hunk, "Git: preview hunk infloat [gitsigns]")

        -- Toggle
        map("n", "<Leader>gog", function()
          vim.cmd "G blame"
        end, "Git: open blame [gitsigns]")
        map("n", "<Leader>gtd", gs.toggle_deleted, "Git: toggle diff changes [gitsigns]")
        map("n", "<Leader>gtw", gs.toggle_word_diff, "Git: toggle word diff [gitsigns]")
        map("n", "<Leader>gtl", gs.toggle_linehl, "Git: toggle linehl [gitsigns]")

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
      "Gblame",
      "Gedit",
      "Git",
      "GitEditChanged",
      "GitHistory",
      "Gwrite",
    },
    keys = {
      {
        "<Leader>gN",
        "<Cmd>botright Git<CR><Cmd>wincmd K<bar>20 wincmd _<CR>4j",
        desc = "Git: open fugitive [fugitive]",
        mode = { "n", "x" },
      },
      -- {
      --   "<Leader>gvd",
      --   function()
      --     local ok, treesitter_context = pcall(require, "treesitter-context")
      --     if ok then
      --       treesitter_context.disable()
      --     end
      --
      --     -- after 0.5 sec, run this command
      --     vim.defer_fn(function()
      --       vim.cmd "Gdiffsplit!"
      --     end, 500)
      --   end,
      --   desc = "Git: open Gdiffsplit [fugitive]",
      -- },
      {
        "<Leader>gvl",
        function()
          vim.cmd "0,3Git blame"
          vim.cmd "wincmd j"
          vim.cmd "normal! 5j"
          vim.cmd "25 wincmd _"
        end,
        desc = "Buffer: open git blame for curbuf [fugitive]",
      },
    },
    dependencies = { "tpope/vim-rhubarb" },
    config = function()
      vim.cmd "command! GitHistory Git! log -- %"

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
          vim.keymap.set("n", "<a-n>", "]m=zt", { buffer = e.buf, remap = true })
          vim.keymap.set("n", "<a-p>", "[m=zt", { buffer = e.buf, remap = true })
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
            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-view]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview-view]" } },

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
            { "n", "<Leader>gp", actions.prev_conflict, { desc = "Git: prev git conflict [diffview-view]" } },
            { "n", "<Leader>gn", actions.next_conflict, { desc = "Git: next git conflict [diffview-view]" } },

            { "n", "<Leader>gko", actions.conflict_choose "ours", { desc = "Git: choose the OURS version of a conflict [diffview-view]" } },
            { "n", "<Leader>gkt", actions.conflict_choose "theirs", { desc = "Git: choose the THEIRS version of a conflict [diffview-view]" }, },
            { "n", "<Leader>gkb", actions.conflict_choose "base", { desc = "Git: choose the BASE version of a conflict [diffview-view]" } },
            { "n", "<Leader>gka", actions.conflict_choose "all", { desc = "Git: choose all the versions of a conflict [diffview-view]" } },

            { "n", "<Leader>gkn", actions.conflict_choose "none", { desc = "Git: delete the conflict region [diffview-view]" } },
            { "n", "<Leader>gkN", actions.conflict_choose_all "none", { desc = "Git: delete the conflict region for the whole file [diffview-view]" }, },

            { "n", "<Leader>gkO", actions.conflict_choose_all "ours", { desc = "Git: choose the OURS version of a conflict for the whole file [diffview-view]" }, },
            { "n", "<Leader>gkT", actions.conflict_choose_all "theirs", { desc = "Git: choose the THEIRS version of a conflict for the whole file [diffview-view]" }, },
            { "n", "<Leader>gkB", actions.conflict_choose_all "base", { desc = "Git: choose the BASE version of a conflict for the whole file [diffview-view]" }, },
            { "n", "<Leader>gkA", actions.conflict_choose_all "all", { desc = "Git: choose all the versions of a conflict for the whole file [diffview-view]" }, },

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
            { "n", "<cr>", actions.select_entry, { desc = "Git: open entry (alternative) [diffview-panel]" }, },
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

            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: next select entry [diffview-panel]" }, },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-panel]" }, },

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
            { "n", "<Leader>gp", actions.prev_conflict, { desc = "Git: prev git conflict [diffview-panel]" } },
            { "n", "<Leader>gn", actions.next_conflict, { desc = "Git: next git conflict [diffview-panel]" } },

            { "n", "<Leader>gkO", actions.conflict_choose_all "ours", { desc = "Git: choose the OURS version of a conflict for the whole file [diffview-panel]" }, },
            { "n", "<Leader>gkT", actions.conflict_choose_all "theirs", { desc = "Git: choose the THEIRS version of a conflict for the whole file [diffview-panel]" }, },
            { "n", "<Leader>gkB", actions.conflict_choose_all "base", { desc = "Git: choose the BASE version of a conflict for the whole file [diffview-panel]" }, },
            { "n", "<Leader>gkA", actions.conflict_choose_all "all", { desc = "Git: choose all the versions of a conflict for the whole file [diffview-panel]" }, },

            { "n", "<Leader>gkN", actions.conflict_choose_all "none", { desc = "Git: delete the conflict region for the whole file [diffview-panel]" }, },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "g?", actions.help "file_panel", { desc = "Git: open the help panel [diffview-panel]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-panel]" } },
          },
          --stylua: ignore
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },

            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },

            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "<cr>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },

            { "n", "h", false },

            { "n", "<Leader>goo", actions.open_in_diffview, { desc = "Git: open the entry under the cursor in a diffview [diffview-history]" }, },
            { "n", "<Leader>gY", actions.copy_hash, { desc = "Git: copy the commit hash of the entry under the cursor [diffview-history]" }, },
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

            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: next select entry [diffview-history]" } },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-history]" }, },

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

            { "n", "<Leader>ul", actions.listing_style, { desc = "Git: toggle between 'list' and 'tree' views [diffview-panel]" }, },
            { "n", "<Leader>uL", actions.toggle_flatten_dirs, { desc = "Git: flatten empty subdirectories in tree listing style [diffview-panel]" }, },
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
        mode = { "n", "x" },
      },
    },
    opts = function()
      return {
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
          },
          popup = {
            ["t"] = false,
            ["m"] = false,

            ["M"] = "MergePopup",
            ["T"] = "TagPopup",
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
