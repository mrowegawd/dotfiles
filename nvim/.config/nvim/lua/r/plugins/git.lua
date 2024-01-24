local Util = require "r.utils"
local highlight = require "r.config.highlights"

return {
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
        { desc = "Git(gitconflict): next" },
      },
      {
        "<Leader>gp",
        "<CMD>GitConflictPrevConflict<CR>",
        { des = "Git(gitconflict): prev" },
      },
    },
    event = "LazyFile",
    opts = {
      default_commands = true, -- disable commands created by this plugin
    },
  },
  -- GITLINKER
  {
    "ruifm/gitlinker.nvim", -- generate shareable file permalinks
    keys = {
      {
        "<Leader>go",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        { desc = "Git(gitlinker): range URL repo on browser" },
      },
      {
        "<Leader>gO",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        { desc = "Git(gitlinker): open URL repo" },
      },
      {
        "<Leader>go",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        {
          desc = "Git(gitlinker): range URL repo on browser (visual)",
        },
      },
      { "<leader>gy" }, --"Git(gitlinker): copy url git hash"
    },
    opts = { mappings = "<Leader>gy" },
  },
  -- OCTO
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      picker = "fzf-lua",
      picker_config = {
        mappings = {
          -- open_in_browser = { lhs = "<Leader>bo", desc = "open issue in browser" },
          goto_file = { lhs = "<CR>", desc = "kampang" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
          merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
        },
      },
      mappings = {
        issue = {
          close_issue = { lhs = "<space>ic", desc = "close issue" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<leader>go", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
          merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
          squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
          close_issue = { lhs = "<space>ic", desc = "close PR" },
          reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload PR" },
          open_in_browser = { lhs = "<Leader>go", desc = "open PR in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          goto_file = { lhs = "gf", desc = "go to file" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review" },
          comment_review = { lhs = "<C-m>", desc = "comment review" },
          request_changes = { lhs = "<C-r>", desc = "request changes review" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        review_diff = {
          add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
          add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
          goto_file = { lhs = "gf", desc = "go to file" },
        },
        file_panel = {
          next_entry = { lhs = "j", desc = "move to next changed file" },
          prev_entry = { lhs = "k", desc = "move to previous changed file" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        },
        repo = {}
      },
    },
  },
  -- GITSIGNS
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      _inline2 = false,
      _extmark_signs = true,
      signs = {
        add = { text = "▎", numhl = "GitSignsAddNr" },
        change = { text = "▎", numhl = "GitSignsChangeNr" },
        delete = { text = "_", numhl = "GitSignsDeleteNr" },
        topdelete = { text = "‾", numhl = "GitSignsDeleteNr" },
        changedelete = { text = "▎", numhl = "GitSignsChangeNr" },
        untracked = { text = "▎" },
      },
      on_attach = function()
        require("r.keymaps.git").gitsigns()
      end,
    },
  },
  -- FUGITIVE
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  -- DIFFVIEW
  {
    "sindrets/diffview.nvim",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      Util.disable_ctrl_i_and_o("NoDiffview", { "DiffviewFiles", "DiffviewFileHistory" })

      highlight.plugin("diffview", {
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
        hooks = {
          diff_buf_read = function()
            local opt = vim.opt_local
            opt.wrap, opt.list, opt.relativenumber = false, false, false
            opt.colorcolumn = ""
          end,
          diff_buf_win_enter = function(bufnr, winid, ctx)
            if ctx.layout_name:match "^diff2" then
              if ctx.symbol == "a" then
                vim.opt_local.winhl = table.concat({
                  "DiffAdd:DiffviewDiffAddAsDelete",
                  "DiffDelete:DiffviewDiffDelete",
                }, ",")
              elseif ctx.symbol == "b" then
                vim.opt_local.winhl = table.concat({
                  "DiffDelete:DiffviewDiffDelete",
                }, ",")
              end
            end
          end,
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

            ["<c-d>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<c-u>"] = actions.scroll_view(-0.25), -- Scroll the view up

            ["j"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            ["<c-n>"] = actions.select_next_entry,
            ["<c-p>"] = actions.select_prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,

            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,

            -- ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            -- ["S"] = actions.stage_all, -- Stage all entries.
            -- ["U"] = actions.unstage_all, -- Unstage all entries.
            -- ["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
            -- ["R"] = actions.refresh_files, -- Update stats and entries in the file list.

            ["H"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
            ["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.

            ["o"] = actions.goto_file_edit,
            ["<c-t>"] = actions.goto_file_tab,
            ["<c-s>"] = actions.goto_file_split,

            ["<F4>"] = actions.cycle_layout,
            ["L"] = actions.open_commit_log,
            ["R"] = actions.refresh_files,

            ["<space>E"] = actions.focus_files,
            ["<space>e"] = actions.toggle_files,

            ["gf"] = "",
            ["<space><tab>"] = "<Cmd>DiffviewClose<CR>",
          },
          file_history_panel = {
            ["?"] = actions.options, -- Open the option panel

            ["<c-d>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<c-u>"] = actions.scroll_view(-0.25), -- Scroll the view up

            ["zR"] = actions.open_all_folds,
            ["zM"] = actions.close_all_folds,
            ["zo"] = actions.open_fold,
            ["zc"] = actions.close_fold,
            ["za"] = actions.toggle_fold,
            ["<tab>"] = actions.toggle_fold,
            ["<s-tab>"] = actions.toggle_fold,

            ["j"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            -- ["<down>"] = actions.next_entry,
            -- ["<up>"] = actions.prev_entry,
            ["<c-n>"] = actions.select_next_entry,
            ["<c-p>"] = actions.select_prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,

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
  -- NEOGIT
  {
    "NeogitOrg/neogit",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    --stylua: ignore
    keys = {
      { "<Leader>gc", function() require("neogit").open { "commit" } end, desc = "Git(neogit): create commit" },
      { "<Leader>gN", function() require("neogit").open() end, desc = "Git(neogit): open" },
    },
    opts = {
      disable_signs = false,
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      disable_insert_on_commit = false,
      signs = {
        section = { "", "" }, -- "󰁙", "󰁊"
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
      integrations = {
        diffview = true,
      },
    },
    -- init = function()
    --   highlight.plugin("neogit_hl", {
    --     {
    --       NeogitDiffAdd = {
    --         fg = { from = "NeogitDiffAdd", attr = "fg", alter = -2 },
    --         bg = { from = "NeogitDiffAdd", attr = "bg" },
    --       },
    --       NeogitDiffAddHighlight = {
    --         fg = { from = "NeogitDiffAdd", attr = "fg", alter = -2 },
    --         bg = { from = "NeogitDiffAdd", attr = "bg" },
    --       },
    --     },
    --     -- { NeogitDiffDelete = { bg = { from = "NeogitDiffDelete", attr = "fg", alter = -1.5 } } },
    --   })
    -- end,
    config = function(_, opts)
      require("neogit").setup(opts)
    end,
  },
}
