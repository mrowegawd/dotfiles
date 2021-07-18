local dap = require("dap")

local g = vim.g
-- local fn = vim.fn
local api = vim.api

-- fn.sign_define("DapBreakpoint", {text = "綠", texthl = "", linehl = "", numhl = ""})
-- fn.sign_define("DapStopped", {text = "->", texthl = "", linehl = "", numhl = ""})

vim.fn.sign_define(
    "DapBreakpoint",
    {
        text = "綠",
        texthl = "LspDiagnosticsDefaultError",
        linehl = "",
        numhl = ""
    }
)
vim.fn.sign_define(
    "DapStopped",
    {
        text = "->",
        texthl = "LspDiagnosticsDefaultWarning",
        linehl = "",
        numhl = ""
    }
)

local function gmap(mode, key, result, opts)
    api.nvim_set_keymap(mode, key, result, opts)
end

local debug_mappings = {
    ["<a-w>"] = "<cmd>lua require'dap'.step_out()<CR>",
    ["<a-s>"] = "<cmd>lua require'dap'.step_over()<CR>",
    ["<a-d>"] = "<cmd>lua require'dap'.step_into()<CR>",
    ["<leader>dk"] = "<cmd>lua require'dap'.up()<CR>",
    ["<leader>dj"] = "<cmd>lua require'dap'.down()<CR>",
    ["<leader>d_"] = "<cmd>lua require'dap'.run_last<CR>",
    ["<leader>dP"] = "<cmd>lua require'dap.ui.widgets'.hover()<CR>",
    ["<leader>dA"] = "<cmd>lua require'dapui'.toggle()<CR>", -- toggle nvim-dap-ui
    ["<leader>ds"] = "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
    ["<leader>de"] = "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<CR>",
    ["<leader>dr"] = "<cmd>lua require'dap'.repl.open({}, 'vsplit')<CR><C-w>l",
    ["<leader>df"] = ":Telescope dap frames<CR>",
    ["<leader>dB"] = ":Telescope dap list_breakpoints<CR>",
    ["<leader>dT"] = ":Telescope dap commands<CR>"
}

for map_name, map_desc in pairs(debug_mappings) do
    gmap("n", map_name, map_desc, {silent = true})
end

local debugJest = function(testName, filename)
    print("starting " .. testName .. " with file " .. filename)
    dap.run(
        {
            type = "node2",
            request = "launch",
            cwd = vim.fn.getcwd(),
            runtimeArgs = {
                "--inspect-brk",
                "/usr/local/bin/jest",
                "--no-coverage",
                "-t",
                testName,
                "--",
                filename
            },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = {"<node_internals>/**/*.js"},
            console = "integratedTerminal",
            port = 9229
        }
    )
end

g.dap_virtual_text = true

local attachDebug = function()
    print("Debugger dap launched..")
    -- PYTHON --------------------------------------------------------------- {{{
    require("dap-python").setup(os.getenv("HOME") .. "/.config/debugpy/bin/python", {console = "internalConsole"})
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            console = "integratedTerminal",
            justMyCode = false,
            pythonPath = function()
                return "python"
            end
        }
    }
    -- }}}

    -- NODE ----------------------------------------------------------------- {{{
    dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = {
            os.getenv("HOME") .. "/bin/build/vscode-node-debug2/out/src/nodeDebug.js"
        }
    }
    dap.configurations.javascript = {
        {
            type = "node2",
            request = "launch",
            -- request = "attach",
            program = "${workspaceFolder}/${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
            skipFiles = {"<node_internals>/**/*.js"}
        }
    }
    dap.configurations.typescript = {
        {
            type = "node2",
            request = "launch",
            program = "${workspaceFolder}/${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
            skipFiles = {"<node_internals>/**/*.js"}
        }
    }
    -- }}}
end

return {
    debugJest = debugJest,
    attachDebug = attachDebug
}
