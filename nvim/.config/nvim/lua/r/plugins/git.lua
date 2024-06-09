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
      require("litee.gh").setup()
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
        desc = "Git: open hash, on cursur git in browser [gitlinker]",
      },
      {
        "<Leader>gO",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        desc = "Git: open URL repo [gitlinker]",
      },
      {
        "<leader>gy",
        desc = "Git: yank/copy URL git hash on cursor [gitlinker]",
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
    init = function()
      vim.treesitter.language.register("markdown", "octo")
    end,
    opts = {
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
          close_issue = { lhs = "<space>ic", desc = "close issue" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<space>go", desc = "open issue in browser" },
          copy_url = { lhs = "<space>gy", desc = "copy url to system clipboard" },
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
          rebase_and_merge_pr = { lhs = "<space>prm", desc = "rebase and merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
          close_issue = { lhs = "<space>ic", desc = "close PR" },
          reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "R", desc = "reload PR" },
          open_in_browser = { lhs = "<space>go", desc = "open PR in browser" },
          copy_url = { lhs = "<leader><C-y>", desc = "copy url to system clipboard" },
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
          review_start = { lhs = "<space>vs", desc = "start a review for the current PR" },
          review_resume = { lhs = "<space>vr", desc = "resume a pending review for the current PR" },
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
          submit_review = { lhs = "<leader>vs", desc = "submit review" },
          discard_review = { lhs = "<leader>vd", desc = "discard review" },
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
          submit_review = { lhs = "<leader>vs", desc = "submit review" },
          discard_review = { lhs = "<leader>vd", desc = "discard review" },
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
        repo = {},
      },
    },
  },
  -- OCTO
  {
    "pwntester/octo.nvim",
    opts = function(_, opts)
      if RUtils.has "telescope.nvim" then
        opts.picker = "telescope"
      elseif RUtils.has "fzf-lua" then
        opts.picker = "fzf-lua"
      else
        RUtils.error "`octo.nvim` requires `telescope.nvim` or `fzf-lua`"
      end
      local Signs = require "octo.ui.signs"

      ---@type {buf: number, from: number, to: number, dirty: boolean}[]
      local signs = {}

      local unplace = Signs.unplace
      function Signs.unplace(bufnr)
        signs = vim.tbl_filter(function(s)
          return s.buf ~= bufnr
        end, signs)
        return unplace(bufnr)
      end

      function Signs.place_signs(bufnr, start_line, end_line, is_dirty)
        signs[#signs + 1] = { buf = bufnr, from = start_line, to = end_line, dirty = is_dirty }
      end
      -- stylua: ignore
      local corners = {
        top    = "┌╴",
        middle = "│ ",
        last   = "└╴",
        single = "[ ",
      }

      --- Fixes octo's comment rendering to take wrapping into account
      ---@param buf number
      ---@param lnum number
      ---@param vnum number
      ---@param win number
      table.insert(RUtils.ui.virtual, function(buf, lnum, vnum, win)
        lnum = lnum - 1
        for _, s in ipairs(signs) do
          if buf == s.buf and lnum >= s.from and lnum <= s.to then
            local height = vim.api.nvim_win_text_height(win, { start_row = s.from, end_row = s.to }).all
            local height_end = vim.api.nvim_win_text_height(win, { start_row = s.to, end_row = s.to }).all
            local corner = corners.middle
            if height == 1 then
              corner = corners.single
            elseif lnum == s.from and vnum == 0 then
              corner = corners.top
            elseif lnum == s.to and vnum == height_end - 1 then
              corner = corners.last
            end
            return { { text = corner, texthl = s.dirty and "OctoDirty" or "IblScope" } }
          end
        end
      end)
    end,
  },
  -- GITSIGNS
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = function()
      require("r.keymaps.git").gitsigns()
      return {
        signs = {
          add = { text = "▎", numhl = "GitSignsAddNr" },
          change = { text = "▎", numhl = "GitSignsChangeNr" },
          delete = { text = "_", numhl = "GitSignsDeleteNr" },
          topdelete = { text = "‾", numhl = "GitSignsDeleteNr" },
          changedelete = { text = "▎", numhl = "GitSignsChangeNr" },
          untracked = { text = "▎" },
        },
        update_debounce = 100,
        max_file_length = 40000,
        sign_priority = 15, -- higher than diagnostic,todo signs. lower than dapui breakpoint sign
        attach_to_untracked = true,
        on_attach = function()
          if vim.bo.ft == "markdown" then
            return false
          end
        end,
      }
    end,
  },
  -- MINI.GIT (disabled)
  {
    "echasnovski/mini-git",
    version = false,
    enabled = false,
  },
  -- MINI.DIFF (disabled)
  {
    "echasnovski/mini.diff",
    enabled = false,
    event = "VeryLazy",
    keys = {
      {
        "<leader>gto",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Git: toggle mini.diff overlay [mini.diff]",
      },
    },
    opts = function()
      require("r.keymaps.git").minigit()
      return {
        view = {
          style = "sign",
          signs = {
            add = "▎",
            change = "▎",
            delete = "",
          },
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Apply hunks inside a visual/operator region
          -- apply = "<Leader>gha",
          apply = "gh",

          -- Reset hunks inside a visual/operator region
          -- reset = "<Leader>ghr",
          reset = "gH",

          -- Hunk range textobject to be used inside operator
          textobject = "",

          -- Go to hunk range in corresponding direction
          goto_first = "gF",
          goto_prev = "gp",
          goto_next = "gn",
          goto_last = "gL",
        },
      }
    end,
  },
  -- FUGITIVE
  {
    "tpope/vim-fugitive",
    cmd = { "GitHistory", "Git", "GBrowse", "Gwrite", "GitEditDiff", "GitEditChanged" },
    -- cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
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
  -- FUGIT2
  {
    "SuperBo/fugit2.nvim",
    enabled = false,
    cmd = { "Fugit2", "Fugit2Graph" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      {
        "chrisgrieser/nvim-tinygit",
        dependencies = { "stevearc/dressing.nvim" },
      },
    },
    keys = { { "<leader>G", mode = "n", "<cmd>Fugit2<cr>", desc = "Git: open fugit2 [fugit2]" } },
    opts = {
      link_colors = {
        Fugit2Header = "Label",
        Fugit2ObjectId = "Comment",
        Fugit2Author = "Tag",
        Fugit2HelpHeader = "Label",
        Fugit2HelpTag = "Tag",
        Fugit2Heading = "PreProc",
        Fugit2UntrackedHeading = "PreCondit",
        Fugit2UnstagedHeading = "Macro",
        Fugit2StagedHeading = "Include",
        Fugit2MessageHeading = "diffAdded",
        Fugit2Modifier = "Type",
        Fugit2Ignored = "Ignore",
        Fugit2Unstaged = "diffRemoved",
        Fugit2Staged = "diffAdded",
        Fugit2Modified = "Constant",
        Fugit2Unchanged = "",
        Fugit2Untracked = "Error",
        Fugit2Instruction = "Type",
        Fugit2Stop = "Function",
        Fugit2Hash = "Identifier",
        Fugit2SymbolicRef = "Function",
        Fugit2Count = "Number",
        Fugit2WindowHelp = "Comment",
        Fugit2MenuHead = "Function",
        Fugit2MenuKey = "Keyword",
        Fugit2MenuArgOff = "Comment",
        Fugit2MenuArgOn = "Number",
        Fugit2BranchHead = "Type",
        Fugit2FloatTitle = "@parameter",
        Fugit2RebasePick = "diffAdded", -- green
        Fugit2RebaseDrop = "diffRemoved", -- red
        Fugit2RebaseSquash = "Type", -- yellow
        Fugit2Branch1 = "GitSignsAdd", -- green
        Fugit2Branch2 = "@field", --dark blue
        Fugit2Branch3 = "Type", -- yellow
        Fugit2Branch4 = "PreProc", -- orange
        Fugit2Branch5 = "Error", --red
        Fugit2Branch6 = "Keyword", -- violet
        Fugit2Branch7 = "@parameter", -- blue
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
        { DiffviewCursorLine = { bg = { from = "MyQuickFixLine", attr = "bg" } } },

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
