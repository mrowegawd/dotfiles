local fmt = string.format
require "r.utils.globals"

return {
  org_agenda_files = {
    fmt("%s/orgmode/gtd/*", as.wiki_path),
    fmt("%s/orgmode/journal/homeclean/*", as.wiki_path),
    fmt("%s/orgmode/journal/HBD/*", as.wiki_path),
  },
  org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", as.wiki_path),
  notifications = {
    reminder_time = { 0, 1, 5, 10 },
    repeater_reminder_time = { 0, 1, 5, 10 },
    deadline_warning_reminder_time = { 0, 5 },
    cron_notifier = function(tasks)
      for _, task in ipairs(tasks) do
        local title = fmt("%s (%s)", task.category, task.humanized_duration)
        local subtitle = fmt(
          "[%s] %s",
          -- string.rep("*", task.level),
          task.todo,
          task.title
        )
        -- local date =
        --     string.format("%s: %s", task.type, task.time:to_string())

        if vim.fn.executable "dunstify" == 1 then
          vim.uv.spawn("dunstify", {
            args = {
              fmt("%s\n%s", title, subtitle),
              fmt("--icon=%s/.config/dunst/bell.png", as.home),
              "-u",
              "low",
            },
          })
        end

        if vim.fn.executable "mpv" == 1 then
          vim.loop.spawn("mpv", {
            args = {
              "--audio-display=no",
              fmt("%s/.config/dunst/notif-me.wav", as.home),
              "--volume=50",
            },
          })
        end
      end
    end,
  },
}
