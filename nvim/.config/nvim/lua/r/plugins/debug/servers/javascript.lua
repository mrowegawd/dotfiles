local DEBUGGER_PATH = vim.fn.stdpath "data"
    .. "/site/pack/packer/opt/vscode-js-debug"

local M = {}

-- WARN: WADUH https://github.com/mfussenegger/nvim-dap/issues/508#issuecomment-1095264064
-- typescript not working

function M.setup()
    require("dap-vscode-js").setup {
        node_path = "node",
        debugger_path = DEBUGGER_PATH,
        -- debugger_cmd = { "js-debug-adapter" },
        adapters = {
            "pwa-node",
            "pwa-chrome",
            "pwa-msedge",
            "node-terminal",
            "pwa-extensionHost",
        }, -- which adapters to register in nvim-dap
    }

    for _, language in ipairs { "typescript", "javascript" } do
        require("dap").configurations[language] = {
            {
                name = "Launch file",
                type = "pwa-node",
                request = "launch",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
            {
                name = "Attach",
                type = "pwa-node",
                request = "attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
            {
                name = "Debug Jest Tests",
                type = "pwa-node",
                request = "launch",
                -- trace = true, -- include debugger info
                runtimeExecutable = "node",
                runtimeArgs = {
                    "./node_modules/jest/bin/jest.js",
                    "--runInBand",
                },
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
            },
        }
    end

    for _, language in ipairs { "typescriptreact", "javascriptreact" } do
        require("dap").configurations[language] = {
            {
                name = "Attach - Remote Debugging",
                type = "pwa-chrome",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222,
                webRoot = "${workspaceFolder}",
            },
            {
                name = "Launch Chrome",
                type = "pwa-chrome",
                request = "launch",
                url = "http://localhost:3000",
            },
        }
    end
end

-- "resolveSourceMapLocations": [
--   "${workspaceFolder}/**",
--   "!**/node_modules/**"
-- ],

return M
