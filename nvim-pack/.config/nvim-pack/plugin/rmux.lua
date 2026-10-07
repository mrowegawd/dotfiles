local add_local_or_remote = require("vim-pack").add_local_or_remote

local UtilKey = require "utils.map"
local ConfigPath = require("config").path

add_local_or_remote {
  {
    --"MadKuntilanak/rmux",
    src = "nvim_plugins/rmux",
    opts = function()
      return {
        rmuxdirrc = ConfigPath.dropbox_path .. "/data.programming.forprivate/runmux/vscode",
        setnotif = false,
      }
    end,
    on_setup = function()
      UtilKey.nnoremap("<Leader>rf", vim.cmd.RmuxRunFile, { desc = "Task: run file [rmux]" })
      --stylua: ignore
      UtilKey.noremap({ "n", "x" }, "<Leader>rl", vim.cmd.RmuxSendline, { desc = "Task: send line [rmux]" })
      UtilKey.noremap({ "n", "x" }, "<Leader>r<CR>", vim.cmd.RmuxSendEnter, { desc = "Task: send enter key [rmux]" })
      UtilKey.nnoremap("<Leader>rs", vim.cmd.RmuxSelectTargetPane, { desc = "Task: select target pane [rmux]" })
      --stylua: ignore
      UtilKey.nnoremap("<Leader>rR", vim.cmd.RmuxSendRestartTaskPane, { desc = "Task: restart the selected task pane [rmux]" })
      UtilKey.nnoremap("<Leader>ri", vim.cmd.RmuxSendInterrupt, { desc = "Task: send interrupt [rmux]" })
      UtilKey.nnoremap("<Leader>rI", vim.cmd.RmuxSendInterruptAll, { desc = "Task: send interrupt all [rmux]" })
      UtilKey.nnoremap("<Leader>rC", vim.cmd.RmuxKillAllPanes, { desc = "Task: kill all panes [rmux]" })
      UtilKey.nnoremap("<a-R>", vim.cmd.RmuxGrepBuf, { desc = "Task: open single find err [rmux]" })

      UtilKey.nnoremap("<Leader>rF", function()
        local task_cmds = {
          ["Task - Run task with Rmux"] = function()
            vim.cmd "RmuxRunFile"
          end,
          ["Task - Setup file rc"] = function()
            vim.cmd "RmuxSetTemplate"
          end,
          ["Task - Send interrupt"] = function()
            vim.cmd "RmuxSendInterrupt"
          end,
          ["Task - Send interrupt all"] = function()
            vim.cmd "RmuxSendInterruptAll"
          end,
          ["Task - Grep error (task running required)"] = function()
            vim.cmd "RmuxGrepErr"
          end,
          ["Task - Kill all panes"] = function()
            vim.cmd "RmuxKillAllPanes"
          end,
          ["Task - Select target pane"] = function()
            vim.cmd "RmuxKillAllPanes"
          end,
          ["Task - Edit config tasks.json"] = function()
            vim.cmd "RmuxEDITConfig"
          end,
          ["Task - Select filerc"] = function()
            vim.cmd "RmuxSelectFilerc"
          end,
          ["Task - Printout / Show configs"] = function()
            vim.cmd "RmuxSelectFilerc"
          end,

          ["TaskOverseer - Open overseer window toggle"] = function()
            vim.cmd "OverseerToggle"
          end,
          ["TaskOverseer - Run task with Overseer"] = function()
            vim.cmd "OverseerRun"
          end,
          ["TaskOverseer - Run open shell"] = function()
            vim.cmd "OverseerShell"
          end,

          ["Gitignore - Run generate gitignore"] = function()
            vim.cmd "Gitignore"
          end,

          -- Refactoring
          ["Refactoring - Select refactor"] = function()
            require("refactoring").select_refactor()
          end,
          ["Refactoring - Extract"] = function()
            vim.cmd "Refactor extract"
          end,
          ["Refactoring - Extract entire block"] = function()
            vim.cmd "Refactor extract_block"
          end,
          ["Refactoring - Extract function to a file"] = function()
            vim.cmd "Refactor extract_block_to_file"
          end,
          ["Refactoring - Clean all debug print string"] = function()
            require("refactoring").debug.cleanup {}
          end,
        }

        if vim.bo.filetype == "python" then
          task_cmds["Pyrola - Open / Start init"] = function()
            vim.cmd "Pyrola init"
          end

          task_cmds["Pyrola - Inspector under cursor"] = function()
            require("pyrola").inspect()
          end

          task_cmds["Pyrola - Send entire buffer to REPL"] = function()
            require("pyrola").send_buffer_to_repl()
          end

          task_cmds["Pyrola - History image viewer"] = function()
            require("pyrola").open_history_manager()
          end

          task_cmds["Pyrola - Send semantic code block"] = function()
            require("pyrola").send_statement_definition()
          end
        end

        if vim.bo.filetype == "yaml.ansible" then
          task_cmds["Ansible - Run task with Nvim.ansible"] = function()
            require("ansible").run()
          end
        end

        table.sort(task_cmds)

        require("utils.fzflua").open_cmd_bulk_center(task_cmds, { winopts = { title = "Task Commands" } })
      end, { desc = "Bulk: task commands" })
    end,
  },
}
