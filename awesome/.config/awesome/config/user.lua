local user = {}

user = {
    -- >> Default applications <<
    -- This is used later as the default terminal and editor to run.
    terminal        = "kitty",
    editor          = "kitty -class editor -e vim",
    browser         = "firefox",
    file_manager    = "Thunar",
    -- editor = "emacs",

    -- >> Search <<
    -- web_search_cmd = "exo-open https://duckduckgo.com/?q="
    web_search_cmd  = "xdg-open https://duckduckgo.com/?q=",
    -- web_search_cmd = "exo-open https://www.google.com/search?q="

    -- >> Music <<
    music_client    = "st --class music -e ncmpcpp",

    -- TODO
    -- >> Screenshots <<
    -- Make sure the directory exists!
    screenshot_dir  = os.getenv("HOME") .. "/Pictures/Screenshots/",

    -- >> Email <<
    email_client    = "st --class email -e neomutt",

    -- >> Anti-aliasing <<
    -- ------------------
    -- Requires a compositor to be running.
    -- ------------------
    -- Currently this works if you set your titlebar position to "top", but it
    -- is trivial to make it work for any titlebar position.
    -- ------------------
    -- This setting only affects clients, but you can "manually" apply
    -- anti-aliasing to other wiboxes. Check out the notification
    -- widget_template in notifications.lua for an example.
    -- ------------------
    -- If anti_aliasing is set to true, the top titlebar corners are
    -- antialiased and a small titlebar is also added at the bottom in order to
    -- round the bottom corners.
    -- If anti_aliasing set to false, the client shape will STILL be rounded,
    -- just without anti-aliasing, according to your theme's border_radius
    -- variable.
    -- ------------------
    anti_aliasing = true,

    -- >> Sidebar <<
    sidebar_hide_on_mouse_leave = true,
    sidebar_show_on_mouse_screen_edge = true,

    -- >> Lock screen <<
    -- You can set this to whatever you want or leave it empty in
    -- order to unlock with just the Enter key.
    lock_screen_password = "awesome",
    -- lock_screen_password = "",

    -- >> Weather <<
    -- Get your key and find your city id at
    -- https://openweathermap.org/
    -- (You will need to make an account!)
    openweathermap_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    openweathermap_city_id = "yyyyyy",
    -- Use "metric" for Celcius, "imperial" for Fahrenheit
    weather_units = "metric",
}

return user
