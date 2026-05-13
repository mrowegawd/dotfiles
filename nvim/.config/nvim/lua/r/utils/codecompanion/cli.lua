local M = {}

-- Constants
local GITHUB_TOKEN = 'GITHUB_TOKEN="$(pass show git/github/<user>/api-key)"'

-- Helpers
local function with_env(cmd, env)
  return {
    cmd = "sh",
    args = { "-lc", table.concat(env, " ") .. ' exec "$@"', "sh", cmd },
  }
end

function M.build()
  return {
    agent = "codex",
    agents = {
      codex = with_env("codex", { GITHUB_TOKEN }),
      claude_code = with_env("claude", { GITHUB_TOKEN }),
    },
  }
end

return M
