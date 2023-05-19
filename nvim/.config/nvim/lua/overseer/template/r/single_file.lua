local overseer = require "overseer"

return {
    name = "Run Single",
    desc = "Build and run single file",
    tags = { overseer.TAG.BUILD },
    strategy = { "toggleterm", open_on_start = true, close_on_exit = false },
    params = { save = { type = "boolean", default = true } },
    builder = function(params)
        return {
            cmd = { vim.b.make, vim.fn.expand "%" },
            components = {
                "default",
                "on_output_quickfix",
                "unique",
                { "r.dispatch", save = params.save },
            },
        }
    end,
    condition = {
        filetype = { "java", "lua", "python", "javascript", "perl", "dart" },
    },
    priority = 20,
}
