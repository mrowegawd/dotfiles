local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local ignore_fts_session = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode", "conf" }

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯

  -- PERSISTENCE
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {

      -- local ignore_fts_session = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode", "conf", "markdown" }
      opts = { options = vim.opt.sessionoptions:get() },
      pre_save = function()
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          if vim.fn.buflisted(bufnr) == 1 then
            if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              vim.api.nvim_buf_delete(bufnr, {})
            end
          end
        end
      end,
    },
    -- stylua: ignore
    -- keys = {
    --   { "<Leader>ll", function() require("persistence").load() end, desc = "Misc: restore session [persistence]" },
    --   { "<Leader>lL", function() require("persistence").load { last = true } end, desc = "Misc: restore last session [persistence]" },
    --   { "<Leader>ls", function() require("persistence").stop() end, desc = "Misc: don't save current session [persistence]" },
    -- },
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
