return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- RESESSION
  {
    "stevearc/resession.nvim",
    event = "LazyFile",
    -- stylua: ignore
    keys = {
      { "<Leader>sl", function() require("resession").load() end, desc = "Misc(resession): load from the list" },
      { "<Leader>sd", function() require("resession").delete() end, desc = "Misc(resession): delete" },
      { "<Leader>ss", function() require("resession").save() end, desc = "Misc(resession): save" },
      { "<Leader>sr", function() require("resession").load(nil, {reset = false}) end, desc = "Misc(resession): save without reset" },
    },
    opts = {
      autosave = {
        enabled = true,
        notify = false,
      },
      -- extensions = {
      --   oil = {},
      -- },
    },
    config = function(_, opts)
      local resession = require "resession"
      local aug = vim.api.nvim_create_augroup("StevearcResession", {})
      resession.setup(opts)

      vim.api.nvim_create_user_command("SessionDetach", function()
        resession.detach()
      end, {})

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = aug,
        callback = function()
          resession.save "last"
        end,
      })
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         PROJECTS                         │
  --  ╰──────────────────────────────────────────────────────────╯
  -- PROJECTS.NVIM
  {
    "ahmedkhalf/project.nvim",
    event = "LazyFile",
    keys = {
      {
        "<Leader>fP",
        "<CMD> ProjectRoot <CR>",
        desc = "Projects(project.nvim): save project",
      },
      {
        "<Leader>fp",
        function()
          local contents = require("project_nvim").get_recent_projects()
          local reverse = {}
          for i = #contents, 1, -1 do
            reverse[#reverse + 1] = contents[i]
          end
          return require("fzf-lua").fzf_exec(reverse, {
            fzf_opts = {
              ["--header"] = [[Ctrl-x:'del cwd']],
            },
            actions = {
              ["default"] = function(e)
                vim.cmd.cd(e[1])
              end,
              ["ctrl-x"] = function(x)
                -- local choice = vim.fn.confirm("Delete '" .. #x .. "' projects? ", "&Yes\n&No", 2)
                -- if choice == 1 then
                local history = require "project_nvim.utils.history"
                for _, v in ipairs(x) do
                  history.delete_project(v)
                end
                -- end
              end,
            },
          })
        end,
        desc = "Projects(project.nvim): open project lists",
      },
    },
    opts = {
      manual_mode = true,
      detection_methods = { "pattern" },
      silent_chdir = false,
      exclude_dirs = {
        "~/",
      },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
}
