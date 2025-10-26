-- Since <c-r> is used for blink and <c-r>.. is used for fugitive,
-- to avoid conflicts, it is temporarily disabled.
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
        "<Leader>gor",
        function()
          vim.cmd [[GitConflictRefresh]]
          ---@diagnostic disable-next-line: undefined-field
          RUtils.info("Start or refresh git conflict..", { title = "Git-conflict" })
        end,
        desc = "Gitopen: start/refresh git conflict [gitconflict]",
      },
      {
        "<Leader>g<down>",
        "<CMD>GitConflictNextConflict<CR>",
        desc = "Git: next conflict [gitconflict]",
      },
      {
        "<Leader>g<up>",
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
        "<Leader>gob",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        mode = { "n", "x" },
        desc = "Gitopen: gitlink on browser (normal or visual) [gitlinker]",
      },
      {
        "<Leader>goB",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        desc = "Gitopen: gitlink on browser [gitlinker]",
      },
      {
        "<Leader>gy",
        desc = "Gitopen: copy hash link [gitlinker]",
      },
    },
    opts = { mappings = "<Leader>gy" },
  },
  -- OCTO
  {
    -- Sebelum menggunakannya: run command ini di cli "gh auth login --scopes read:project"
    -- "pwntester/octo.nvim",
    "MadKuntilanak/octo.nvim",
    -- dir = "~/.local/src/nvim_plugins/octo.nvim",
    branch = "feat/big-updates",
    cmd = "Octo",
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
          copy_url = { lhs = "<space>gy", desc = "copy url to system clipboard [discussion]" },
          add_comment = { lhs = "<localleader>ca", desc = "add comment [discussion]" },
          delete_comment = { lhs = "<localleader>cd", desc = "delete comment [discussion]" },
          open_in_browser = { lhs = "<space>goo", desc = "open issue in browser [discussion]" },
          add_label = { lhs = "<localleader>la", desc = "add label [discussion]" },
          remove_label = { lhs = "<localleader>ld", desc = "remove label [discussion]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [discussion]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [discussion]" },
          react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction [discussion]" },
          react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction [discussion]" },
          react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction [discussion]" },
          react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction [discussion]" },
          react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction [discussion]" },
          react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction [discussion]" },
          react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction [discussion]" },
          react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction [discussion]" },
        },
        runs = {
          expand_step = { lhs = "o", desc = "expand workflow step" },
          open_in_browser = { lhs = "<space>goo", desc = "open workflow run in browser" },
          refresh = { lhs = "<C-r>", desc = "refresh workflow" },
          rerun = { lhs = "<C-o>", desc = "rerun workflow" },
          rerun_failed = { lhs = "<C-f>", desc = "rerun failed workflow" },
          cancel = { lhs = "<C-x>", desc = "cancel workflow" },
          copy_url = { lhs = "<space>gy", desc = "copy url to system clipboard" },
        },
        issue = {
          close_issue = { lhs = "<space>ic", desc = "close issue [issue]" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue [issue]" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo [octo [issue]" },
          reload = { lhs = "<C-r>", desc = "reload issue [issue]" },
          open_in_browser = { lhs = "<space>goo", desc = "open issue in browser [issue]" },
          copy_url = { lhs = "<space>gy", desc = "copy url to system clipboard [issue]" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee [issue]" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee [issue]" },
          create_label = { lhs = "<space>lc", desc = "create label [issue]" },
          add_label = { lhs = "<space>la", desc = "add label [issue]" },
          remove_label = { lhs = "<space>ld", desc = "remove label [issue]" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue [issue]" },
          add_comment = { lhs = "<space>ca", desc = "add comment [issue]" },
          add_reply = { lhs = "<space>cr", desc = "add reply" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment [issue]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [issue]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [issue]" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction [issue]" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction [issue]" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction [issue]" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction [issue]" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction [issue]" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction [issue]" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction [issue]" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction [issue]" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR [pull request]" },
          merge_pr = { lhs = "<space>pm", desc = "merge commit PR [pull request]" },
          squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR [pull request]" },
          rebase_and_merge_pr = { lhs = "<space>prm", desc = "rebase and merge PR [pull request]" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits [pull request]" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files [pull request]" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff [pull request]" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer [pull request]" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request [pull request]" },
          close_issue = { lhs = "<space>ic", desc = "close PR [pull request]" },
          reopen_issue = { lhs = "<space>io", desc = "reopen PR [pull request]" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo [pull request]" },
          reload = { lhs = "R", desc = "reload PR [pull request]" },
          open_in_browser = { lhs = "<space>goo", desc = "open PR in browser [pull request]" },
          copy_url = { lhs = "<space>gy", desc = "copy url to system clipboard [pull request]" },
          goto_file = { lhs = "gf", desc = "go to file [pull request]" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee [pull request]" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee [pull request]" },
          create_label = { lhs = "<space>lc", desc = "create label [pull request]" },
          add_label = { lhs = "<space>la", desc = "add label [pull request]" },
          copy_sha = { lhs = "<space>gY", desc = "copy commit SHA to system clipboard [pull request]" },
          remove_label = { lhs = "<space>ld", desc = "remove label [pull request]" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue [pull request]" },
          add_comment = { lhs = "<space>ca", desc = "add comment [pull request]" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment [pull request]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [pull request]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [pull request]" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction [pull request]" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction [pull request]" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction [pull request]" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction [pull request]" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction [pull request]" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction [pull request]" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction [pull request]" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction [pull request]" },
          review_start = { lhs = "<space>vs", desc = "start a review for the current PR [pull request]" },
          review_resume = { lhs = "<space>vr", desc = "resume a pending review for the current PR" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue [review thread]" },
          add_comment = { lhs = "<space>ca", desc = "add comment [review thread]" },
          add_reply = { lhs = "<space>cr", desc = "add reply" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion [review thread]" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment [review thread]" },
          next_comment = { lhs = "<c-n>", desc = "go to next comment [review thread]" },
          prev_comment = { lhs = "<c-p>", desc = "go to previous comment [review thread]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review thread]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review thread]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review thread]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review thread]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review thread]" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction [review thread]" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction [review thread]" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction [review thread]" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction [review thread]" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction [review thread]" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction [review thread]" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction [review thread]" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction [review thread]" },
          resolve_thread = { lhs = "<space>rt", desc = "resolve PR thread" },
          unresolve_thread = { lhs = "<space>rT", desc = "unresolve PR thread" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review [submit win]" },
          comment_review = { lhs = "<C-m>", desc = "comment review [submit win]" },
          request_changes = { lhs = "<C-r>", desc = "request changes review [submit win]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [submit win]" },
        },
        review_diff = {
          submit_review = { lhs = "<space>vs", desc = "submit review [review diff]" },
          discard_review = { lhs = "<space>vd", desc = "discard review [review diff]" },
          add_review_comment = { lhs = "<space>ca", desc = "add a new review comment [review diff]" },
          add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion [review diff]" },
          focus_files = { lhs = "<space>e", desc = "move focus to changed file panel [review diff]" },
          toggle_files = { lhs = "<space>b", desc = "hide/show changed files panel [review diff]" },
          next_thread = { lhs = "]t", desc = "move to next thread [review diff]" },
          prev_thread = { lhs = "[t", desc = "move to previous thread [review diff]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [review diff]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [review diff]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review diff]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review diff]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review diff]" },
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [review diff]" },
          goto_file = { lhs = "gf", desc = "go to file [review diff]" },
          copy_sha = { lhs = "<space>gY", desc = "copy commit SHA to system clipboard [review diff" },
          review_commits = { lhs = "<space>C", desc = "review PR commits [review diff]" },
        },
        file_panel = {
          submit_review = { lhs = "<space>vs", desc = "submit review [file panel]" },
          discard_review = { lhs = "<space>vd", desc = "discard review [file panel]" },
          next_entry = { lhs = "j", desc = "move to next changed file [file panel]" },
          prev_entry = { lhs = "k", desc = "move to previous changed file [file panel]" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs [file panel]" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel [file panel]" },
          focus_files = { lhs = "<space>e", desc = "move focus to changed file panel [file panel]" },
          toggle_files = { lhs = "<space>b", desc = "hide/show changed files panel [file panel]" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file [file panel]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [file panel]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [file panel]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [file panel]" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab [file panel]" },
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [file panel]" },
          review_commits = { lhs = "<space>C", desc = "review PR commits [file panel]" },
        },
        notification = {
          read = { lhs = "<space>nr", desc = "mark notification as read" },
          done = { lhs = "<space>nd", desc = "mark notification as done" },
          unsubscribe = { lhs = "<space>nu", desc = "unsubscribe from notifications" },
        },
        repo = {},
      },
    },
  },
  -- OCTO
  {
    -- "pwntester/octo.nvim",
    "MadKuntilanak/octo.nvim",
    -- dir = "~/.local/src/nvim_plugins/octo.nvim",
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
      on_attach = function()
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
        map("n", "<Leader>ghs", gs.stage_hunk, "Hunk: stage [gitsigns]")
        map("x", "<Leader>ghs", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.stage_hunk { from, to }
        end, "Hunk: stage (visual) [gitsigns]")
        map("n", "<Leader>ghr", gs.reset_hunk, "Hunk: reset [gitsigns]")
        map("x", "<Leader>ghr", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          gs.reset_hunk { from, to }
        end, "Hunk: reset (visual) [gitsigns]")
        map("n", "<Leader>ghu", gs.undo_stage_hunk, "Hunk: undo [gitsigns]")
        map("n", "<Leader>ghS", gs.stage_buffer, "Hunk: stage buffer [gitsigns]")
        map("n", "<Leader>ghR", gs.reset_buffer, "Hunk: reset buffer [gitsigns]")

        -- Hunk preview
        map("n", "<Leader>ghp", gs.preview_hunk_inline, "Hunk: preview hunk [gitsigns]")
        map("n", "<Leader>ghP", gs.preview_hunk, "Hunk: preview hunk [gitsigns]")
        map("x", "<Leader>ghP", function()
          local from, to = vim.fn.line ".", vim.fn.line "v"
          if from > to then
            from, to = to, from
          end
          print(from, to)
          gs.preview_hunk()
        end, "Hunk: preview (visual) [gitsigns]")

        -- Toggle
        map("n", "<Leader>gub", function()
          gs.blame()
        end, "Gittoggle: git blame [gitsigns]")
        map("n", "<Leader>gud", gs.toggle_deleted, "Gittoggle: to check diff changes [gitsigns]")
        map("n", "<Leader>guw", gs.toggle_word_diff, "Gittoggle: word diff [gitsigns]")
        map("n", "<Leader>gul", gs.toggle_linehl, "Gittoggle: linehl [gitsigns]")

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
        end, "Git: last hunk [gitsigns]")
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
      "GitEditChanged",
      "GitHistory",
      "Gwrite",
      -- "GitEditDiff",
    },
    keys = {
      {
        "<Leader>gN",
        "<Cmd>botright Git<CR><Cmd>wincmd K<bar>20 wincmd _<CR>4j",
        desc = "Git: open fugitive [fugitive]",
        mode = { "n", "x" },
      },
      {
        "<Leader>gd",
        function()
          local ok, treesitter_context = pcall(require, "treesitter-context")
          if ok then
            treesitter_context.disable()
          end

          -- after 0.5 sec, run this command
          vim.defer_fn(function()
            vim.cmd "Gdiffsplit!"
          end, 500)
        end,
        desc = "Git: open Gdiffsplit [fugitive]",
      },
      {
        "<Leader>bl",
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
        desc = "Gitopen: DiffviewOpen [diffview]",
      },
      {
        "<Leader>goh",
        "<CMD>DiffviewFileHistory<CR>",
        desc = "Gitopen: DiffviewFileHistory repo [diffview]",
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
            -- { "n", "<c-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-view]" }, },
            -- { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview-view]" } },
            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-view]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview-view]" } },

            { "n", "[F", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview-view]" } },
            { "n", "]F", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview-view]" } },

            { "n", "h", false },

            { "n", "go", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview-view]" } },
            { "n", "gO", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview-view]" } },
            { "n", "<Leader>ws", actions.goto_file_split, { desc = "Git: open the file in a new split [diffview-view]" } },
            { "n", "tn", actions.goto_file_tab, { desc = "Git: open the file in a new tabpage [diffview-view]" } },

            { "n", "<Leader>uE", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-view]" } },
            { "n", "<Leader>ue", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-view]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle through available layouts [diffview-view]" } },

            { "n", "<Leader>gp", actions.prev_conflict, { desc = "Git: in the merge-tool: jump to the previous conflict [diffview-view]" } },
            { "n", "<Leader>gn", actions.next_conflict, { desc = "Git: in the merge-tool: jump to the next conflict [diffview-view]" } },

            { "n", "<Leader>co", actions.conflict_choose "ours", { desc = "Git: choose the OURS version of a conflict [diffview-view]" } },
            { "n", "<Leader>ct", actions.conflict_choose "theirs", { desc = "Git: choose the THEIRS version of a conflict [diffview-view]" }, },
            { "n", "<Leader>cb", actions.conflict_choose "base", { desc = "Git: choose the BASE version of a conflict [diffview-view]" } },
            { "n", "<Leader>ca", actions.conflict_choose "all", { desc = "Git: choose all the versions of a conflict [diffview-view]" } },

            { "n", "dx", actions.conflict_choose "none", { desc = "Git: delete the conflict region [diffview-view]" } },
            { "n", "dX", actions.conflict_choose_all "none", { desc = "Git: delete the conflict region for the whole file [diffview-view]" }, },

            { "n", "<Leader>cO", actions.conflict_choose_all "ours", { desc = "Git: choose the OURS version of a conflict for the whole file [diffview-view]" }, },
            { "n", "<Leader>cT", actions.conflict_choose_all "theirs", { desc = "Git: choose the THEIRS version of a conflict for the whole file [diffview-view]" }, },
            { "n", "<Leader>cB", actions.conflict_choose_all "base", { desc = "Git: choose the BASE version of a conflict for the whole file [diffview-view]" }, },
            { "n", "<Leader>cA", actions.conflict_choose_all "all", { desc = "Git: choose all the versions of a conflict for the whole file [diffview-view]" }, },
          },
          --stylua: ignore
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: cursor down [diffview-panel]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: cursor down [diffview-panel]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: cursor up [diffview-panel]" }, },
            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-panel]" }, },
            { "n", "<cr>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-panel]" }, },
            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-panel]" }, },
            -- { "n", "l", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-panel]" }, },
            { "n", "h", false },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-panel]" }, },

            { "n", "-", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview-panel]" }, },
            { "n", "s", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview-panel]" }, },
            { "n", "u", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview-panel]" }, },


            -- Git: stage, unstage, restore, commit
            -- { "n", "<Leader>ghs", actions.toggle_stage_entry, { desc = "Git: stage / unstage the selected entry [diffview-panel]" }, },
            -- { "n", "<Leader>ghS", actions.stage_all, { desc = "Git: stage all entries [diffview-panel]" } },
            -- { "n", "<Leader>ghR", actions.unstage_all, { desc = "Git: unstage all entries [diffview-panel]" } },
            -- { "n", "<Leader>ghr", actions.restore_entry, { desc = "Git: restore entry to the state on the left side [diffview-panel]" }, },
            { "n", "cc", "<Cmd>Git commit <bar> wincmd J<CR>", { desc = "Git: commit staged changes with fugitive [diffview-panel]" }, },
            { "n", "ca", "<Cmd>Git commit --amend <bar> wincmd J<CR>", { desc = "Git: amend the last commit with fugitive [diffview-panel]" }, },

            { "n", "L", actions.open_commit_log, { desc = "Git: open the commit log panel [diffview-panel]" } },

            { "n", "zo", actions.open_fold, { desc = "Git: expand fold [diffview-panel]" } },
            { "n", "zO", actions.open_all_folds, { desc = "Git: expand all folds [diffview-panel]" } },
            { "n", "zc", actions.close_fold, { desc = "Git: collapse fold [diffview-panel]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold [diffview-panel]" } },
            { "n", "zm", actions.close_all_folds, { desc = "Git: collapse all folds [diffview-panel]" } },
            { "n", "zM", actions.close_all_folds, { desc = "Git: collapse all folds [diffview-panel]" } },

            -- { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview-panel]" } },
            -- { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview-panel]" } },
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview-panel]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview-panel]" } },
            -- { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-panel]" }, },
            -- { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous file [diffview-panel]" }, },
            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-panel]" }, },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous file [diffview-panel]" }, },

            { "n", "gg", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview-panel]" }, },
            { "n", "G", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview-panel]" }, },

            { "n", "go", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview-panel]" }, },
            { "n", "gO", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview-panel]" }, },
            { "n", "<Leader>ws", actions.goto_file_split, { desc = "Git: open the file in a new split [diffview-panel]" }, },
            { "n", "tn", actions.goto_file_tab, { desc = "Git: open the file in a new tabpag [diffview-panel]" }, },

            { "n", "<Leader>ul", actions.listing_style, { desc = "Git: toggle between 'list' and 'tree' views [diffview-panel]" }, },
            { "n", "<Leader>uL", actions.toggle_flatten_dirs, { desc = "Git: flatten empty subdirectories in tree listing style [diffview-panel]" }, },

            { "n", "R", actions.refresh_files, { desc = "Git: update stats and entries in the file list [diffview-panel]" }, },

            { "n", "<Leader>uE", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-panel]" }, },
            { "n", "<Leader>ue", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-panel]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-panel]" } },

            { "n", "<Leader>gp", actions.prev_conflict, { desc = "Git: go to the previous conflict [diffview-panel]" } },
            { "n", "<Leader>gn", actions.next_conflict, { desc = "Git: go to the next conflict [diffview-panel]" } },

            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold [diffview-panel]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: collapse all folds [diffview-panel]" }, },

            { "n", "<Leader>cO", actions.conflict_choose_all "ours", { desc = "Git: choose the OURS version of a conflict for the whole file [diffview-panel]" }, },
            { "n", "<Leader>cT", actions.conflict_choose_all "theirs", { desc = "Git: choose the THEIRS version of a conflict for the whole file [diffview-panel]" }, },
            { "n", "<Leader>cB", actions.conflict_choose_all "base", { desc = "Git: choose the BASE version of a conflict for the whole file [diffview-panel]" }, },
            { "n", "<Leader>cA", actions.conflict_choose_all "all", { desc = "Git: choose all the versions of a conflict for the whole file [diffview-panel]" }, },

            { "n", "dX", actions.conflict_choose_all "none", { desc = "Git: delete the conflict region for the whole file [diffview-panel]" }, },

            { "n", "g?", actions.help "file_panel", { desc = "Git: open the help panel [diffview-panel]" } },
          },
          --stylua: ignore
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },
            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },
            { "n", "<cr>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "h", false },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },


            { "n", "g!", actions.options, { desc = "Git: open the option panel [diffview-history]" } },
            { "n", "<C-A-d>", actions.open_in_diffview, { desc = "Git: open the entry under the cursor in a diffview [diffview-history]" }, },
            { "n", "y", actions.copy_hash, { desc = "Git: copy the commit hash of the entry under the cursor [diffview-history]" }, },
            { "n", "L", actions.open_commit_log, { desc = "Git: show commit details [diffview-history]" } },
            { "n", "X", actions.restore_entry, { desc = "Git: restore file to the state from the selected entry [diffview-history]" }, },

            { "n", "zo", actions.open_fold, { desc = "Git: expand fold [diffview-history]" } },
            { "n", "zR", actions.open_all_folds, { desc = "Git: expand all folds [diffview-history]" } },
            { "n", "zc", actions.close_fold, { desc = "Git: collapse fold [diffview-history]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold [diffview-history]" } },
            { "n", "zm", actions.close_all_folds, { desc = "Git: collapse all folds [diffview-history]" } },
            { "n", "zM", actions.close_all_folds, { desc = "Git: collapse all folds [diffview-history]" } },


            -- { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview-history]" } },
            -- { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview-history]" } },
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll the view up [diffview-history]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll the view down [diffview-history]" } },

            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold [diffview-history]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: collapse all folds [diffview-history]" }, },

            -- { "n", "<a-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-history]" } },
            -- { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous file [diffview-history]" }, },
            { "n", "<c-n>", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-history]" } },
            { "n", "<c-p>", actions.select_prev_entry, { desc = "Git: open the diff for the previous file [diffview-history]" }, },

            { "n", "gg", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview-history]" }, },
            { "n", "G", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview-history]" } },

            { "n", "go", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview-history]" }, },
            { "n", "gO", actions.goto_file_edit, { desc = "Git: open the file in the previous tabpage [diffview-history]" }, },
            { "n", "<Leader>ws", actions.goto_file_split, { desc = "Git: open the file in a new split [diffview-view]" } },
            { "n", "tn", actions.goto_file_tab, { desc = "Git: open the file in a new tabpage [diffview-history]" } },

            { "n", "<Leader>uE", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-history]" } },
            { "n", "<Leader>ue", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-history]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-history]" } },

            { "n", "g?", actions.help "file_history_panel", { desc = "Git: open the help panel [diffview-history]" } },
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
            h,
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
