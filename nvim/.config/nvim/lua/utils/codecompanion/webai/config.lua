local M = {
  host = "127.0.0.1",
  port = 8787, -- port sidecar
  cdp_port = 9222, -- port Chrome remote debugging
  auto_start = true,
  python_cmd = "python3",
  sidecar_script = nil,
  provider = "chatgpt",
  new_chat = true,
}

return M
