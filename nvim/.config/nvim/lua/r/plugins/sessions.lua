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
    cond = vim.g.neovide ~= nil or not vim.env.TMUX,
    keys = {
      {
        "<a-g>",
        function()
          local contents = require("project_nvim").get_recent_projects()
          local reverse = {}
          for i = #contents, 1, -1 do
            reverse[#reverse + 1] = contents[i]
          end

          if #reverse == 0 then
            local dropbox_path = RUtils.config.path.dropbox_path
            local path_fzmark = dropbox_path .. "/data.programming.forprivate/marked-pwd"

            local cat_fzmark = vim.api.nvim_exec2("!cat " .. path_fzmark, { output = true })
            if cat_fzmark.output ~= nil then
              local res = vim.split(cat_fzmark.output, "\n")
              -- print(vim.inspect(#res - 1))
              for index = 2, #res - 1 do
                if #res[index] > 1 then
                  reverse[#reverse + 1] = res[index]
                end
              end
            end
          end

          return fzf_lua.fzf_exec(reverse, {
            prompt = "   ",
            winopts = {
              title = RUtils.fzflua.format_title("FzMark", "󰈙"),
            },
            actions = {
              ["default"] = function(e)
                vim.cmd.cd(e[1])
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
