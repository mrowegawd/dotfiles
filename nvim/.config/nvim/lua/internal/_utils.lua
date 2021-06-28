local fn = vim.fn
local api = vim.api

local function is_qf_window()
    local filetype = api.nvim_buf_get_option(0, "filetype")

    if filetype ~= "qf" then
        return false
    end

    print("[!] you still inside quickfix morron..~_~")
    return true
end

local clear_prompt = function()
    api.nvim_command("normal :esc<CR>")
end

local clear_prompt_with_print = function()
    clear_prompt()
    print("aborting..")
    return
end

local create_filename = function()
    -- local cwd = fn.resolve(fn.getcwd())
    -- cwd = fn.substitute(cwd, "^" .. os.getenv("HOME") .. "/", "", "")
    -- cwd = fn.fnamemodify(cwd, ":p:gs?/?_?")
    -- cwd = fn.substitute(cwd, "^\\.", "", "")
    local cwd = fn.fnamemodify(fn.getcwd(), ":t")
    return cwd
end

return {
    create_filename = create_filename,
    clear_prompt = clear_prompt,
    clear_prompt_with_print = clear_prompt_with_print,
    is_qf_window = is_qf_window
}
