local vint = {
    sourceName = 'vint',
    command = 'vint',
    debounce = 100,
    args = {
      '--enable-neovim',
      '-'
    },
    -- parseJson = {
    --     errorsRoot = '[0].messages',
    --     line = 'line',
    --     column = 'column',
    --     endLine = 'endLine',
    --     endColumn = 'endColumn',
    --     message = '${message} [${ruleId}]',
    --     security = 'severity',
    -- },
    securities = {
        [2] = 'error',
        [1] = 'warning'
    },
    rootPatterns = {
        '.git',
    },
}

return vint
