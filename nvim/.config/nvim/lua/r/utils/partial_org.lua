local fmt = string.format

require "r.utils"

return {
  org_agenda_files = {
    fmt("%s/orgmode/gtd/*", RUtils.config.path.wiki_path),
    fmt("%s/orgmode/gym/*", RUtils.config.path.wiki_path),
    fmt("%s/orgmode/habit/*", RUtils.config.path.wiki_path),
    fmt("%s/orgmode/day-to-remember/*", RUtils.config.path.wiki_path),
  },
  org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", RUtils.config.path.wiki_path),
  notifications = {
    reminder_time = { 0, 1, 5 },
    deadline_warning_reminder_time = { 10, 5, 0, -5 },
    repeater_reminder_time = { 10, 5, 0 },
    cron_notifier = function(tasks)
      for _, task in ipairs(tasks) do
        local subtitle = fmt("%s", task.title)
        local date = task.time:to_string()
        local time = vim.split(date, " ")

        if vim.fn.executable "dunstify" then
          vim.system {
            "dunstify",
            "-t",
            "12000",
            fmt("%s - %s", time[3], subtitle),
            fmt("--icon=%s/.config/miscxrdb/icons/bell.png", os.getenv "HOME"),
          }
        end

        if vim.fn.executable "mpv" then
          vim.system {
            "mpv",
            "--audio-display=no",
            "--volume=50",
            fmt("%s/.config/miscxrdb/mp3-wav/notif-me.mp3", os.getenv "HOME"),
          }
        end
      end
    end,
  },
}
