local fmt = string.format
local Config = require "r.config"

require "r.utils"

return {
  org_agenda_files = {
    fmt("%s/orgmode/gtd/*", Config.path.wiki_path),
    fmt("%s/orgmode/habit/*", Config.path.wiki_path),
    fmt("%s/orgmode/day-to-remember/*", Config.path.wiki_path),
  },
  org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", Config.path.wiki_path),
  notifications = {
    -- reminder_time = { 0, 1, 5, 10 },
    -- repeater_reminder_time = { 0, 1, 5, 10 },
    -- deadline_warning_reminder_time = { 0, 5 },
    reminder_time = { 0, 1, 5, 50 },
    deadline_warning_reminder_time = { 10, 5, 0, -5 },
    repeater_reminder_time = { 30, 20, 10, 5, 0 },
    cron_notifier = function(tasks)
      for _, task in ipairs(tasks) do
        local title = fmt("%s (%s)", task.category, task.humanized_duration)
        local subtitle = fmt("%s", task.title)
        local date = string.format("%s: %s", task.type, task.time:to_string())

        if vim.fn.executable "dunstify" == 1 then
          vim.uv.spawn("dunstify", {
            args = {
              fmt("TODO: %s\n%s\n%s", subtitle, date, title),
              fmt("--icon=%s/.config/dunst/bell.png", os.getenv "HOME"),
              "-u",
              "normal",
            },
          })
        end

        if vim.fn.executable "mpv" == 1 then
          vim.loop.spawn("mpv", {
            args = {
              "--audio-display=no",
              fmt("%s/.config/dunst/notif-me.wav", os.getenv "HOME"),
              "--volume=50",
            },
          })
        end
      end
    end,
  },
}
