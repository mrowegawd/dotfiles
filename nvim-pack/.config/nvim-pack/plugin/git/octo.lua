local add_local_or_remote = require("vim-pack").add_local_or_remote

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
          discussion_options = { lhs = "<CR>", desc = "show discussion options" },

          open_in_browser = { lhs = "<Leader>gob", desc = "open issue in browser [discussion]" },
          copy_url = { lhs = "<Leader>cy", desc = "copy url to system clipboard [discussion]" },

          goto_issue = { lhs = "<Leader>oe", desc = "go to issue/pr/discussion under cursor [pull request]" },

          -- add_comment = { lhs = "<LocalLeader>qaca", desc = "add comment [discussion]" },
          -- add_reply = { lhs = "<LocalLeader>qacr", desc = "add reply [discussion]" },
          -- delete_comment = { lhs = "<LocalLeader>qacd", desc = "delete comment [discussion]" },
          -- reference_in_new_issue = { lhs = "<localleader>qaci", desc = "reference comment in new issue [discussion]" },

          -- add_label = { lhs = "<LocalLeader>qala", desc = "add label [discussion]" },
          -- remove_label = { lhs = "<LocalLeader>qald", desc = "remove label [discussion]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [discussion]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [discussion]" },

          -- react_hooray = { lhs = "<LocalLeader>qarp", desc = "add/remove 🎉 reaction [discussion]" },
          -- react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [discussion]" },
          -- react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [discussion]" },
          -- react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [discussion]" },
          -- react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [discussion]" },
          -- react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [discussion]" },
          -- react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [discussion]" },
          -- react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [discussion]" },
        },
        runs = {
          open_in_browser = { lhs = "<Leader>gob", desc = "open workflow run in browser [runs]" },
          copy_url = { lhs = "<Leader>cy", desc = "copy url to system clipboard [runs]" },

          refresh = { lhs = "R", desc = "refresh workflow [runs]" },

          expand_step = { lhs = "o", desc = "expand workflow step [runs]" },
          rerun = { lhs = "<C-o>", desc = "rerun workflow [runs]" },
          rerun_failed = { lhs = "<C-f>", desc = "rerun failed workflow [runs]" },
          cancel = { lhs = "<C-x>", desc = "cancel workflow [runs]" },
        },
        issue = {
          issue_options = { lhs = "<CR>", desc = "show issue options" },

          open_in_browser = { lhs = "<Leader>gob", desc = "open issue in browser [issue]" },
          copy_url = { lhs = "<Leader>cy", desc = "copy url to system clipboard [issue]" },

          -- close_issue = { lhs = "<LocalLeader>qC", desc = "close issue [issue]" },
          -- reopen_issue = { lhs = "<LocalLeader>qR", desc = "reopen issue [issue]" },

          list_issues = { lhs = "<LocalLeader>qf", desc = "list open issues on same repo [issue]" },
          -- reload = { lhs = "R", desc = "reload issue [issue]" },

          -- add_assignee = { lhs = "<LocalLeader>qaaa", desc = "add assignee [issue]" },
          -- remove_assignee = { lhs = "<LocalLeader>qaad", desc = "remove assignee [issue]" },

          -- add_label = { lhs = "<LocalLeader>qala", desc = "add label [issue]" },
          -- create_label = { lhs = "<LocalLeader>qalc", desc = "create label [issue]" },
          -- remove_label = { lhs = "<LocalLeader>qald", desc = "remove label [issue]" },

          goto_issue = { lhs = "<Leader>oe", desc = "go to issue/pr/discussion under cursor [issue]" },

          -- add_comment = { lhs = "<LocalLeader>qaca", desc = "add comment [issue]" },
          -- add_reply = { lhs = "<LocalLeader>qacr", desc = "add reply [issue]" },
          -- delete_comment = { lhs = "<LocalLeader>qacd", desc = "delete comment [issue]" },
          -- reference_in_new_issue = { lhs = "<localleader>qaci", desc = "reference comment in new issue [issue]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [issue]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [issue]" },

          -- react_hooray = { lhs = "<LocalLeader>qaro", desc = "add/remove 🎉 reaction [issue]" },
          -- react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [issue]" },
          -- react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [issue]" },
          -- react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [issue]" },
          -- react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [issue]" },
          -- react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [issue]" },
          -- react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [issue]" },
          -- react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [issue]" },
        },
        pull_request = {
          pr_options = { lhs = "<CR>", desc = "show PR options" },

          open_in_browser = { lhs = "<Leader>gob", desc = "open PR in browser [pull request]" },
          copy_url = { lhs = "<Leader>cy", desc = "copy url to system clipboard [pull request]" },
          copy_sha = { lhs = "<Leader>gy", desc = "copy commit SHA to system clipboard [pull request]" },

          -- checkout_pr = { lhs = "<LocalLeader>qco", desc = "checkout PR [pull request]" },
          -- merge_pr = { lhs = "<LocalLeader>qcm", desc = "merge commit PR [pull request]" },
          -- squash_and_merge_pr = { lhs = "<LocalLeader>qcs", desc = "squash and merge PR [pull request]" },
          -- rebase_and_merge_pr = { lhs = "<LocalLeader>qcr", desc = "rebase and merge PR [pull request]" },

          -- merge_pr_queue = {
          --   lhs = "<LocalLeader>qcP",
          --   desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          -- },
          -- squash_and_merge_queue = {
          --   lhs = "<LocalLeader>qcS",
          --   desc = "squash and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          -- },
          -- rebase_and_merge_queue = {
          --   lhs = "<LocalLeader>qcR",
          --   desc = "rebase and add to merge queue (Merge queue must be enabled in the repo) [pull request]",
          -- },

          -- list_commits = { lhs = "<LocalLeader>qvf", desc = "list PR commits [pull request]" },
          -- list_changed_files = { lhs = "<LocalLeader>qvF", desc = "list PR changed files [pull request]" },
          -- show_pr_diff = { lhs = "<LocalLeader>qvd", desc = "show PR diff [pull request]" },

          -- close_issue = { lhs = "<LocalLeader>qC", desc = "close PR [pull request]" },
          -- reopen_issue = { lhs = "<LocalLeader>qR", desc = "reopen PR [pull request]" },

          list_issues = { lhs = "<LocalLeader>qf", desc = "list open issues on same repo [pull request]" },

          -- reload = { lhs = "<Leader>R", desc = "reload PR [pull request]" },

          goto_file = { lhs = "<Leader>oO", desc = "go to file [pull request]" },

          -- add_assignee = { lhs = "<LocalLeader>qaaa", desc = "add assignee [pull request]" },
          -- remove_assignee = { lhs = "<LocalLeader>qaad", desc = "remove assignee [pull request]" },

          -- add_label = { lhs = "<LocalLeader>qala", desc = "add label [pull request]" },
          -- create_label = { lhs = "<LocalLeader>qalc", desc = "create label [pull request]" },
          -- remove_label = { lhs = "<LocalLeader>qald", desc = "remove label [pull request]" },

          goto_issue = { lhs = "<Leader>oe", desc = "go to issue/pr/discussion under cursor [pull request]" },

          -- add_comment = { lhs = "<LocalLeader>qaca", desc = "add comment [pull request]" },
          -- add_reply = { lhs = "<LocalLeader>qacr", desc = "add reply [pull request]" },
          -- delete_comment = { lhs = "<LocalLeader>qacd", desc = "delete comment [pull request]" },
          -- reference_in_new_issue = { lhs = "<localleader>qaci", desc = "reference comment in new issue [pull request]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [pull request]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [pull request]" },
          -- add_reviewer = { lhs = "<LocalLeader>qRa", desc = "add reviewer [pull request]" },
          -- remove_reviewer = { lhs = "<LocalLeader>qRd", desc = "remove reviewer request [pull request]" },
          -- review_start = { lhs = "<LocalLeader>qRs", desc = "start a review for the current PR [pull request]" },
          -- review_resume = {
          --   lhs = "<LocalLeader>qRr",
          --   desc = "resume a pending review for the current PR [pull request]",
          -- },

          -- react_hooray = { lhs = "<LocalLeader>qaro", desc = "add/remove 🎉 reaction [pull request]" },
          -- react_heart = { lhs = "<LocalLeader>qarh", desc = "add/remove ❤️ reaction [pull request]" },
          -- react_eyes = { lhs = "<LocalLeader>qare", desc = "add/remove 👀 reaction [pull request]" },
          -- react_thumbs_up = { lhs = "<LocalLeader>qarn", desc = "add/remove 👍 reaction [pull request]" },
          -- react_thumbs_down = { lhs = "<LocalLeader>qarp", desc = "add/remove 👎 reaction [pull request]" },
          -- react_rocket = { lhs = "<LocalLeader>qarr", desc = "add/remove 🚀 reaction [pull request]" },
          -- react_laugh = { lhs = "<LocalLeader>qarl", desc = "add/remove 😄 reaction [pull request]" },
          -- react_confused = { lhs = "<LocalLeader>qarc", desc = "add/remove 😕 reaction [pull request]" },

          -- resolve_thread = { lhs = "<LocalLeader>qtt", desc = "resolve PR thread [pull request]" },
          -- unresolve_thread = { lhs = "<LocalLeader>qtU", desc = "unresolve PR thread [pull request]" },
        },
        review_thread = {
          goto_issue = { lhs = "<Leader>oe", desc = "go to issue/pr/discussion under cursor [review thread]" },

          add_comment = { lhs = "<LocalLeader>qaca", desc = "add comment [review thread]" },
          add_reply = { lhs = "<LocalLeader>qacr", desc = "add reply [review thread]" },
          add_suggestion = { lhs = "<LocalLeader>qacs", desc = "add suggestion [review thread]" },
          delete_comment = { lhs = "<LocalLeader>qacd", desc = "delete comment [review thread]" },
          reference_in_new_issue = { lhs = "<localleader>qaci", desc = "reference comment in new issue [pull request]" },

          next_comment = { lhs = "<a-n>", desc = "go to next comment [review thread]" },
          prev_comment = { lhs = "<a-p>", desc = "go to previous comment [review thread]" },

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
          submit_review = { lhs = "<LocalLeader>qR", desc = "submit review [review diff]" },
          discard_review = { lhs = "<LocalLeader>qD", desc = "discard review [review diff]" },

          add_review_comment = { lhs = "<LocalLeader>qc", desc = "add review comment [review diff]" },
          add_review_suggestion = { lhs = "<LocalLeader>qS", desc = "add review suggestion [review diff]" },

          copy_sha = { lhs = "<Leader>gy", desc = "copy commit SHA to system clipboard [review diff]" },
          goto_file = { lhs = "<Leader>oe", desc = "go to file [review diff]" },

          review_commits = { lhs = "<LocalLeader>qf", desc = "review PR list commits [review diff]" },

          focus_files = { lhs = "<Leader>oo", desc = "move focus to changed file panel [review diff]" },
          toggle_files = { lhs = "<Leader>oO", desc = "hide/show changed files panel [review diff]" },

          next_thread = { lhs = "<C-n>", desc = "move to next thread [review diff]" },
          prev_thread = { lhs = "<C-p>", desc = "move to previous thread [review diff]" },

          select_next_entry = { lhs = "gn", desc = "move to next changed file [review diff]" },
          select_prev_entry = { lhs = "gp", desc = "move to previous changed file [review diff]" },

          select_first_entry = { lhs = "[Q", desc = "move to first changed file [review diff]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [review diff]" },

          select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed file" },

          close_review_tab = { lhs = "<C-c>", desc = "close review tab [review diff]" },
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [review diff]" },
        },
        file_panel = {
          toggle_viewed = { lhs = "<space><space>", desc = "toggle viewer viewed state [file panel]" },

          submit_review = { lhs = "<LocalLeader>qS", desc = "submit review [file panel]" },
          discard_review = { lhs = "<LocalLeader>qR", desc = "discard review [file panel]" },

          next_entry = { lhs = "j", desc = "move to next changed file [file panel]" },
          prev_entry = { lhs = "k", desc = "move to previous changed file [file panel]" },

          select_entry = { lhs = "<CR>", desc = "show selected changed file diffs [file panel]" },

          refresh_files = { lhs = "<Leader>R", desc = "refresh changed files panel [file panel]" },

          focus_files = { lhs = "<Leader>oo", desc = "move focus to changed file panel [file panel]" },
          toggle_files = { lhs = "<Leader>oO", desc = "hide/show changed files panel [file panel]" },

          select_next_entry = { lhs = "]q", desc = "move to next changed file [file panel]" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file [file panel]" },

          select_first_entry = { lhs = "[Q", desc = "move to first changed file [file panel]" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file [file panel]" },

          select_next_unviewed_entry = { lhs = "gn", desc = "move to next unviewed file" },
          select_prev_unviewed_entry = { lhs = "gp", desc = "move to previous unviewed file" },

          close_review_tab = { lhs = "<C-c>", desc = "close review tab [file panel]" },

          review_commits = { lhs = "<space>mC", desc = "review PR commits [file panel]" },
        },
        notification = {
          read = { lhs = "<LocalLeader>qnr", desc = "mark notification as read [notification]" },
          done = { lhs = "<LocalLeader>qnd", desc = "mark notification as done [notification]" },
          unsubscribe = { lhs = "<LocalLeader>qnu", desc = "unsubscribe from notifications [notification]" },
        },
        repo = {
          repo_options = { lhs = "<CR>", desc = "show repo options" },

          copy_url = { lhs = "<Leader>cy", desc = "copy url to system clipboard [repo]" },
          open_in_browser = { lhs = "<Leader>gob", desc = "open repo in browser [repo]" },

          -- create_issue = { lhs = "<LocalLeader>qci", desc = "create issue [repo]" },
          -- create_discussion = { lhs = "<LocalLeader>qcd", desc = "create discussion [repo]" },
          -- contributing_guidelines = { lhs = "<LocalLeader>qcG", desc = "view contributing guidelines [repo]" },
        },
        release = {
          open_in_browser = { lhs = "<Leader>gob", desc = "open release in browser [release]" },
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

  -- {
  --   -- "pwntester/octo.nvim",
  --   -- "MadKuntilanak/octo.nvim",
  --   src = "nvim_plugins/octo.nvim",
  --   master = "feat/big-updates",
  --   opts = function()
  --     vim.treesitter.language.register("markdown", "octo")
  --     -- Keep some empty windows in sessions
  --     vim.api.nvim_create_autocmd("ExitPre", {
  --       group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
  --       ---@diagnostic disable-next-line: unused-local
  --       callback = function(ev)
  --         local keep = { "octo" }
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           local buf = vim.api.nvim_win_get_buf(win)
  --           if vim.tbl_contains(keep, vim.bo[buf].filetype) then
  --             vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
  --           end
  --         end
  --       end,
  --     })
  --   end,
  -- },
}

vim.api.nvim_create_user_command("Octo", function(args)
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
