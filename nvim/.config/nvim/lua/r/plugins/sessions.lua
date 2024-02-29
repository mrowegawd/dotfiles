local Util = require "r.utils"

local fzf_lua = Util.cmd.reqcall "fzf-lua"

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- MINI.SESSIONS
  {
    "echasnovski/mini.sessions",
    version = "*",
    event = "BufReadPre",
    keys = {
      {
        "<Leader>ss",
        function()
          Util.sessions.save_ses()
        end,
        desc = "Misc(mini.session): save session",
      },

      {
        "<Leader>sl",
        function()
          Util.sessions.load_ses()
        end,
        desc = "Misc(mini.session): restore last session",
      },
    },
    opts = {
      autoread = false,
      autowrite = false,
    },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         PROJECTS                         │
  --  ╰──────────────────────────────────────────────────────────╯
  -- PROJECTS.NVIM
  {
    "ahmedkhalf/project.nvim",
    event = "LazyFile",
    cond = vim.g.neovide ~= nil,
    keys = {
      {
        "<a-g>",
        function()
          local contents = require("project_nvim").get_recent_projects()
          local reverse = {}
          for i = #contents, 1, -1 do
            reverse[#reverse + 1] = contents[i]
          end
          return fzf_lua.fzf_exec(reverse, {
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
      datapath = "~/Dropbox",
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
