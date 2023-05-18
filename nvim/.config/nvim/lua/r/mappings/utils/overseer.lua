local cmd = vim.cmd

local task = {}

function task.run_task(bufnr)
    require("legendary").keymaps {
        {
            itemgroup = "Task runner",
            keymaps = {

                {
                    "<F4>",
                    function()
                        local overseer = require "overseer"
                        local tasks = overseer.list_tasks {
                            recent_first = true,
                        }
                        if vim.tbl_isempty(tasks) then
                            return vim.notify(
                                "No tasks found",
                                vim.log.levels.WARN
                            )
                        else
                            return overseer.run_action(tasks[1], "restart")
                        end
                    end,
                    description = "Overseer: run or restart the task",
                    opts = { buffer = bufnr },
                },

                {
                    "<F1>",
                    function()
                        if vim.bo.filetype ~= "OverseerList" then
                            return cmd "OverseerRun"
                        end
                        return cmd "OverseerQuickAction"
                    end,
                    description = "Overseer: run quick action",
                    opts = { buffer = bufnr },
                },
            },
        },
    }
end

return task
