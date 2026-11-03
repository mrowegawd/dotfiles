local add_local_or_remote = require("vim-pack").add_local_or_remote

local lazy = require("utils.plugin").require_lazy

add_local_or_remote {
  {
    -- Sebelum install: run command ini di cli "gh auth login --scopes read:project"
    -- "pwntester/octo.nvim",
    --"MadKuntilanak/octo.nvim",
    src = "nvim_plugins/octo.nvim",
    version = "feat/big-updates",
    lazy = true,

    opts = {
      picker = "fzf-lua", -- "telescope", "snacks", "fzf-lua"
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
      mappings_disable_default = true, -- disable default mappings if true, but will still adapt user mappings
      mappings = {
        discussion = {
          discussion_options = { lhs = "<CR>", desc = "show discussion options [discussion]" },
          open_in_browser = { lhs = "<C-c>ob", desc = "open discussion in browser [discussion]" },
          copy_url = { lhs = "<C-c>y", desc = "copy url to system clipboard [discussion]" },
          add_comment = { lhs = "<C-c>acc", desc = "add comment [discussion]" },
          add_reply = { lhs = "<C-c>acr", desc = "add reply [discussion]" },
          delete_comment = { lhs = "<C-c>acD", desc = "delete comment [discussion]" },
          comment_edits = { lhs = "<C-c>acE", desc = "show comment edit history [discussion]" },
          reference_in_new_issue = { lhs = "<C-c>aci", desc = "reference comment in new issue [discussion]" },
          add_label = { lhs = "<C-c>all", desc = "add label [discussion]" },
          remove_label = { lhs = "<C-c>alL", desc = "remove label [discussion]" },
          next_comment = { lhs = "<a-n>", desc = "go to next comment [discussion]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [discussion]" },
          react_hooray = { lhs = "<C-c>aRp", desc = "add/remove 🎉 reaction [discussion]" },
          react_heart = { lhs = "<C-c>aRh", desc = "add/remove ❤️ reaction [discussion]" },
          react_eyes = { lhs = "<C-c>aRe", desc = "add/remove 👀 reaction [discussion]" },
          react_thumbs_up = { lhs = "<C-c>aR+", desc = "add/remove 👍 reaction [discussion]" },
          react_thumbs_down = { lhs = "<C-c>aR-", desc = "add/remove 👎 reaction [discussion]" },
          react_rocket = { lhs = "<C-c>aRr", desc = "add/remove 🚀 reaction [discussion]" },
          react_laugh = { lhs = "<C-c>aRl", desc = "add/remove 😄 reaction [discussion]" },
          react_confused = { lhs = "<C-c>aRc", desc = "add/remove 😕 reaction [discussion]" },
        },
        runs = {
          expand_step = { lhs = "<C-c>xE", desc = "expand workflow step [runs]" },
          next_step = { lhs = "<a-n>", desc = "next workflow step [runs]" },
          prev_step = { lhs = "<a-p>", desc = "previous workflow step [runs]" },
          next_job = { lhs = "<c-n>", desc = "next workflow job [runs]" },
          prev_job = { lhs = "<c-p>", desc = "previous workflow job [runs]" },
          open_in_browser = { lhs = "<C-c>ob", desc = "open workflow run in browser [runs]" },
          refresh = { lhs = "<C-c>R", desc = "refresh workflow [runs]" },
          rerun = { lhs = "<C-c><C-r>", desc = "rerun workflow [runs]" },
          rerun_failed = { lhs = "<C-c><C-f>", desc = "rerun failed workflow [runs]" },
          cancel = { lhs = "<C-c><C-x>", desc = "cancel workflow [runs]" },
          copy_url = { lhs = "<C-c>y", desc = "copy url to system clipboard [runs]" },
        },
        issue = {
          issue_options = { lhs = "<CR>", desc = "show issue options [issue]" },
          close_issue = { lhs = "<C-c>xC", desc = "close issue [issue]" },
          reopen_issue = { lhs = "<C-c>xR", desc = "reopen issue [issue]" },
          list_issues = { lhs = "<C-c>ff", desc = "list open issues on same repo [issue]" },
          reload = { lhs = "<C-c>R", desc = "reload issue [issue]" },
          open_in_browser = { lhs = "<C-c>ob", desc = "open issue in browser [issue]" },
          copy_url = { lhs = "<C-c>y", desc = "copy url to system clipboard [issue]" },
          add_assignee = { lhs = "<C-c>ass", desc = "add assignee [issue]" },
          remove_assignee = { lhs = "<C-c>asS", desc = "remove assignee [issue]" },
          create_label = { lhs = "<C-c>alc", desc = "create label [issue]" },
          add_label = { lhs = "<C-c>all", desc = "add label [issue]" },
          remove_label = { lhs = "<C-c>alL", desc = "remove label [issue]" },
          goto_issue = { lhs = "<C-c>oi", desc = "navigate to a local repo issue [issue]" },
          add_comment = { lhs = "<C-c>acc", desc = "add comment [issue]" },
          add_reply = { lhs = "<C-c>acr", desc = "add reply [issue]" },
          delete_comment = { lhs = "<C-c>acD", desc = "delete comment [issue]" },
          comment_edits = { lhs = "<C-c>acE", desc = "show comment edit history [issue]" },
          reference_in_new_issue = { lhs = "<C-c>aci", desc = "reference comment in new issue [issue]" },
          next_comment = { lhs = "<a-n>", desc = "go to next comment [issue]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [issue]" },
          react_hooray = { lhs = "<C-c>aRp", desc = "add/remove 🎉 reaction [issue]" },
          react_heart = { lhs = "<C-c>aRh", desc = "add/remove ❤️ reaction [issue]" },
          react_eyes = { lhs = "<C-c>aRe", desc = "add/remove 👀 reaction [issue]" },
          react_thumbs_up = { lhs = "<C-c>aR+", desc = "add/remove 👍 reaction [issue]" },
          react_thumbs_down = { lhs = "<C-c>aR-", desc = "add/remove 👎 reaction [issue]" },
          react_rocket = { lhs = "<C-c>aRr", desc = "add/remove 🚀 reaction [issue]" },
          react_laugh = { lhs = "<C-c>aRl", desc = "add/remove 😄 reaction [issue]" },
          react_confused = { lhs = "<C-c>aRc", desc = "add/remove 😕 reaction [issue]" },
        },
        pull_request = {
          pr_options = { lhs = "<CR>", desc = "show PR options [pull_request]" },
          checkout_pr = { lhs = "<C-c>co", desc = "checkout PR [pull_request]" },
          merge_pr = { lhs = "<C-c>cm", desc = "merge commit PR [pull_request]" },
          squash_and_merge_pr = { lhs = "<C-c>cs", desc = "squash and merge PR [pull_request]" },
          rebase_and_merge_pr = { lhs = "<C-c>cr", desc = "rebase and merge PR [pull_request]" },
          merge_pr_stack = { lhs = "<C-c>cps", desc = "merge PR stack (this PR and all below it) [pull_request]" },
          merge_pr_queue = {
            lhs = "<C-c>cpq",
            desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo) [pull_request]",
          },
          squash_and_merge_queue = {
            lhs = "<C-c>cpM",
            desc = "squash and add to merge queue (Merge queue must be enabled in the repo) [pull_request]",
          },
          rebase_and_merge_queue = {
            lhs = "<C-c>cpQ",
            desc = "rebase and add to merge queue (Merge queue must be enabled in the repo) [pull_request]",
          },
          list_commits = { lhs = "<C-c>fl", desc = "list PR commits [pull_request]" },
          list_changed_files = { lhs = "<C-c>fL", desc = "list PR changed files [pull_request]" },
          show_pr_diff = { lhs = "<C-c>fd", desc = "show PR diff [pull_request]" },
          add_reviewer = { lhs = "<C-c>ra", desc = "add reviewer [pull_request]" },
          remove_reviewer = { lhs = "<C-c>rD", desc = "remove reviewer request [pull_request]" },
          close_issue = { lhs = "<C-c>xC", desc = "close PR [pull_request]" },
          reopen_issue = { lhs = "<C-c>xR", desc = "reopen PR [pull_request]" },
          list_issues = { lhs = "<C-c>ff", desc = "list open issues on same repo [pull_request]" },
          reload = { lhs = "<C-c>R", desc = "reload PR [pull_request]" },
          approve_pr = { lhs = "<C-c>xA", desc = "approve PR [pull_request]" },
          open_in_browser = { lhs = "<C-c>ob", desc = "open PR in browser [pull_request]" },
          copy_url = { lhs = "<C-c>y", desc = "copy url to system clipboard [pull_request]" },
          copy_sha = { lhs = "<C-c>Y", desc = "copy commit SHA to system clipboard [pull_request]" },
          goto_file = { lhs = "<C-c>of", desc = "go to file [pull_request]" },
          stack_up = { lhs = "]s", desc = "open the next PR up the stack [pull_request]" },
          stack_down = { lhs = "[s", desc = "open the next PR down the stack [pull_request]" },
          goto_check = { lhs = "<C-c>oC", desc = "open the CI check under the cursor [pull_request]" },
          toggle_checks = { lhs = "<C-c>uc", desc = "fold or unfold the CI checks list [pull_request]" },
          add_assignee = { lhs = "<C-c>ass", desc = "add assignee [pull_request]" },
          remove_assignee = { lhs = "<C-c>asS", desc = "remove assignee [pull_request]" },
          create_label = { lhs = "<C-c>alc", desc = "create label [pull_request]" },
          add_label = { lhs = "<C-c>all", desc = "add label [pull_request]" },
          remove_label = { lhs = "<C-c>alL", desc = "remove label [pull_request]" },
          goto_issue = { lhs = "<C-c>oi", desc = "navigate to a local repo issue [pull_request]" },
          add_comment = { lhs = "<C-c>acc", desc = "add comment [pull_request]" },
          add_reply = { lhs = "<C-c>acr", desc = "add reply [pull_request]" },
          delete_comment = { lhs = "<C-c>acD", desc = "delete comment [pull_request]" },
          comment_edits = { lhs = "<C-c>acE", desc = "show comment edit history [pull_request]" },
          reference_in_new_issue = { lhs = "<C-c>aci", desc = "reference comment in new issue [pull_request]" },
          next_comment = { lhs = "<a-n>", desc = "go to next comment [pull_request]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [pull_request]" },
          react_hooray = { lhs = "<C-c>aRp", desc = "add/remove 🎉 reaction [pull_request]" },
          react_heart = { lhs = "<C-c>aRh", desc = "add/remove ❤️ reaction [pull_request]" },
          react_eyes = { lhs = "<C-c>aRe", desc = "add/remove 👀 reaction [pull_request]" },
          react_thumbs_up = { lhs = "<C-c>aR+", desc = "add/remove 👍 reaction [pull_request]" },
          react_thumbs_down = { lhs = "<C-c>aR-", desc = "add/remove 👎 reaction [pull_request]" },
          react_rocket = { lhs = "<C-c>aRr", desc = "add/remove 🚀 reaction [pull_request]" },
          react_laugh = { lhs = "<C-c>aRl", desc = "add/remove 😄 reaction [pull_request]" },
          react_confused = { lhs = "<C-c>aRc", desc = "add/remove 😕 reaction [pull_request]" },
          review = { lhs = "<C-c>rr", desc = "start or resume a review for the current PR [pull_request]" },
          review_start = { lhs = "<C-c><C-s>", desc = "start a review for the current PR [pull_request]" },
          review_resume = { lhs = "<C-c><C-r>", desc = "resume a pending review for the current PR [pull_request]" },
          resolve_thread = { lhs = "<C-c>rt", desc = "resolve PR thread [pull_request]" },
          unresolve_thread = { lhs = "<C-c>rT", desc = "unresolve PR thread [pull_request]" },
        },
        review_thread = {
          goto_issue = { lhs = "<C-c>oi", desc = "navigate to a local repo issue [review_thread]" },
          add_comment = { lhs = "<C-c>acc", desc = "add comment [review_thread]" },
          add_reply = { lhs = "<C-c>acr", desc = "add reply [review_thread]" },
          add_suggestion = { lhs = "<C-c>aS", desc = "add suggestion [review_thread]" },
          delete_comment = { lhs = "<C-c>acD", desc = "delete comment [review_thread]" },
          comment_edits = { lhs = "<C-c>acE", desc = "show comment edit history [review_thread]" },
          reference_in_new_issue = { lhs = "<C-c>aci", desc = "reference comment in new issue [review_thread]" },
          next_comment = { lhs = "<a-n>", desc = "go to next comment [review_thread]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [review_thread]" },
          select_next_entry = { lhs = "gn", desc = "move to next changed file [review_thread]" },
          select_prev_entry = { lhs = "gp", desc = "move to previous changed file [review_thread]" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review_thread]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review_thread]" },
          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file [review_thread]" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file [review_thread]" },
          close_review_tab = { lhs = "<C-c>q", desc = "close review tab [review_thread]" },
          react_hooray = { lhs = "<C-c>aRp", desc = "add/remove 🎉 reaction [review_thread]" },
          react_heart = { lhs = "<C-c>aRh", desc = "add/remove ❤️ reaction [review_thread]" },
          react_eyes = { lhs = "<C-c>aRe", desc = "add/remove 👀 reaction [review_thread]" },
          react_thumbs_up = { lhs = "<C-c>aR+", desc = "add/remove 👍 reaction [review_thread]" },
          react_thumbs_down = { lhs = "<C-c>aR-", desc = "add/remove 👎 reaction [review_thread]" },
          react_rocket = { lhs = "<C-c>aRr", desc = "add/remove 🚀 reaction [review_thread]" },
          react_laugh = { lhs = "<C-c>aRl", desc = "add/remove 😄 reaction [review_thread]" },
          react_confused = { lhs = "<C-c>aRc", desc = "add/remove 😕 reaction [review_thread]" },
          resolve_thread = { lhs = "<C-c>rt", desc = "resolve PR thread [review_thread]" },
          unresolve_thread = { lhs = "<C-c>rT", desc = "unresolve PR thread [review_thread]" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review [submit_win]" },
          comment_review = { lhs = "<C-m>", desc = "comment review [submit_win]" },
          request_changes = { lhs = "<C-r>", desc = "request changes review [submit_win]" },
          close_review_tab = { lhs = "<C-c>q", desc = "close review tab [submit_win]" },
        },
        review_diff = {
          submit_review = { lhs = "<C-c>rs", desc = "submit review [review_diff]" },
          discard_review = { lhs = "<C-c>rD", desc = "discard review [review_diff]" },

          add_review_comment = { lhs = "<C-c>ar", desc = "add review comment [review_diff]" },
          add_review_suggestion = { lhs = "<C-c>aS", desc = "add review suggestion [review_diff]" },

          copy_sha = { lhs = "<C-c>Y", desc = "copy commit SHA to system clipboard [review_diff]" },
          goto_file = { lhs = "<C-c>of", desc = "go to file [review_diff]" },

          review_commits = { lhs = "<C-c>ff", desc = "review PR list commits [review_diff]" },

          focus_files = { lhs = "<Leader>oo", desc = "move focus to changed file panel [review_diff]" },
          toggle_files = { lhs = "<Leader>oO", desc = "hide/show changed files panel [review_diff]" },

          next_thread = { lhs = "<C-n>", desc = "move to next thread [review_diff]" },
          prev_thread = { lhs = "<C-p>", desc = "move to previous thread [review_diff]" },

          select_next_entry = { lhs = "gn", desc = "move to next changed file [review_diff]" },
          select_prev_entry = { lhs = "gp", desc = "move to previous changed file [review_diff]" },

          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review_diff]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review_diff]" },

          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file [review_diff]" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file [review_diff]" },

          close_review_tab = { lhs = "<C-c>q", desc = "close review tab [review_diff]" },
          toggle_viewed = { lhs = "<C-c>uv", desc = "toggle viewer viewed state [review_diff]" },
        },
        file_panel = {
          toggle_viewed = { lhs = "<C-c>uv", desc = "toggle viewer viewed state [file_panel]" },

          submit_review = { lhs = "<C-c>rs", desc = "submit review [file_panel]" },
          discard_review = { lhs = "<C-c>rD", desc = "discard review [file_panel]" },

          next_entry = { lhs = "j", desc = "move cursor down in file list [file_panel]" },
          prev_entry = { lhs = "k", desc = "move cursor up in file list [file_panel]" },

          select_entry = { lhs = "<CR>", desc = "show selected changed file diffs [file_panel]" },

          refresh_files = { lhs = "<C-c>R", desc = "refresh changed files panel [file_panel]" },

          focus_files = { lhs = "<Leader>oo", desc = "move focus to changed file panel [file_panel]" },
          toggle_files = { lhs = "<Leader>oO", desc = "hide/show changed files panel [file_panel]" },

          select_next_entry = { lhs = "gn", desc = "move to next changed file [file_panel]" },
          select_prev_entry = { lhs = "gp", desc = "move to previous changed file [file_panel]" },

          select_first_entry = { lhs = "[Q", desc = "move to first changed file [file_panel]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [file_panel]" },

          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file [file_panel]" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file [file_panel]" },

          close_review_tab = { lhs = "<C-c>q", desc = "close review tab [file_panel]" },

          review_commits = { lhs = "<C-c>ff", desc = "review PR commits [file_panel]" },
        },
        notification = {
          read = { lhs = "<C-c>nr", desc = "mark notification as read [notification]" },
          done = { lhs = "<C-c>nd", desc = "mark notification as done [notification]" },
          unsubscribe = { lhs = "<C-c>nu", desc = "unsubscribe from notifications [notification]" },
        },
        repo = {
          open_in_browser = { lhs = "<C-c>ob", desc = "open repo in browser [repo]" },
          repo_options = { lhs = "<CR>", desc = "show repo options [repo]" },
          create_issue = { lhs = "<C-c>xi", desc = "create issue [repo]" },
          create_discussion = { lhs = "<C-c>xd", desc = "create discussion [repo]" },
          contributing_guidelines = { lhs = "<C-c>oG", desc = "view contributing guidelines [repo]" },
        },
        release = {
          open_in_browser = { lhs = "<C-c>ob", desc = "open release in browser [release]" },
        },
      },
    },
    on_setup = function()
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
}

local CreateCmd = lazy("utils.cmd").create_command
local UtilAugroup = lazy("utils.map").augroup

CreateCmd("Octo", function(args)
  require("vim-pack").load_now "octo.nvim"

  if #args.fargs == 0 then
    vim.notify("Usage: OctoLazy <command> [args...]", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_cmd({
    cmd = "Octo",
    args = args.fargs,
  }, {})
end, {
  nargs = "*",
})

local whichkey = lazy "which-key"

UtilAugroup("Octo", {
  event = "FileType",
  pattern = "octo",
  command = function(ev)
    whichkey.add {
      { "<C-c>f", group = "find", buffer = ev.buf },
      { "<C-c>ff", name = "list:issue", buffer = ev.buf },
      { "<C-c>o", group = "open", buffer = ev.buf },
      { "<C-c>y", name = "yank/copy", buffer = ev.buf },
      { "<C-c>a", group = "add:review/assignee/label/comment/reactions", buffer = ev.buf },
      { "<C-c>as", group = "assignee", buffer = ev.buf },
      { "<C-c>al", group = "label", buffer = ev.buf },
      { "<C-c>ac", group = "comment/reply", buffer = ev.buf },
      { "<C-c>aR", group = "reactions", buffer = ev.buf },
      { "<C-c>r", group = "review", buffer = ev.buf },
      { "<C-c>R", group = "reload/refresh", buffer = ev.buf },
      { "<C-c>c", group = "check:checkout/merge/rebase/rebase", buffer = ev.buf },
      { "<C-c>cp", group = "mergequeue", buffer = ev.buf },
      { "<C-c>u", group = "toggle", buffer = ev.buf },
      { "<C-c>x", group = "exec", buffer = ev.buf },
    }
  end,
})
