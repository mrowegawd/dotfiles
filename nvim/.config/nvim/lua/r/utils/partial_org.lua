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
        local title = fmt("%s (%s)", task.category, task.humanized_duration)
        local subtitle = fmt("%s", task.title)
        -- local date = string.format("%s: %s", task.type, task.time:to_string())
        local date = string.format("%s", task.time:to_string())

        if vim.fn.executable "dunstify" == 1 then
          vim.uv.spawn("dunstify", {
            args = {
              "-t",
              "8000",
              fmt("[%s %s]\n%s:", task.type, date, title),
              fmt("<b><span foreground='#7ba05b'>%s</span></b>", subtitle),
              fmt("--icon=%s/.config/miscxrdb/icons/bell.png", os.getenv "HOME"),
              "-u",
              "normal",
            },
          })
        end

        if vim.fn.executable "mpv" == 1 then
          vim.uv.spawn("mpv", {
            args = {
              "--audio-display=no",
              fmt("%s/.config/miscxrdb/mp3-wav/notif-me.mp3", os.getenv "HOME"),
              "--volume=50",
            },
          })
        end
      end
    end,
  },
}
