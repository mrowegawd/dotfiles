-- Get ascii generator:
-- https://lachlanarthur.github.io/Braille-ASCII-Art/
local logos = {
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[      `       --._    `-._   `-.   `.     :   /  .'   .-'   _.-'    _.--'                   ]],
    [[        `--.__     `--._   `-._  `-.  `. `. : .' .'  .-'  _.-'   _.--'     __.--'           ]],
    [[           __    `--.__    `--._  `-._ `-. `. :/ .' .-' _.-'  _.--'    __.--'    __         ]],
    [[            `--..__   `--.__   `--._ `-._`-.`_=_'.-'_.-' _.--'   __.--'   __..--'           ]],
    [[          --..__   `--..__  `--.__  `--._`-q(-_-)p-'_.--'  __.--'  __..--'   __..--         ]],
    [[                ``--..__  `--..__ `--.__ `-'_) (_`-' __.--' __..--'  __..--''               ]],
    [[          ...___        ``--..__ `--..__`--/__/  --'__..--' __..--''        ___...          ]],
    [[                ```---...___    ``--..__`_(<_   _/)_'__..--''    ___...---'''               ]],
    [[           ```-----....._____```---...___(____|_/__)___...---'''_____.....-----'''          ]],
    [[]],
    [[]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⠤⠤⠤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⠈⠉⠉⠁⠒⠤⡀⠀⠀ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠾⠿⠶⠀⠀⠀⠀⠀⠈⠑⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⣰⣯⣍⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⡸⠥⠤⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣ ]],
    [[                 ⠀⠀⠀⠀⠀⢠⣯⠭⠭⠭⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸ ]],
    [[                 ⠀⠀⠀⠀⠀⣼⣛⣛⣛⣒⡀⠀⠀⠤⠤⠤⠤⠤⠀⠀⠤⠤⠤⠄⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⢀⣀⡀⡀⠀⡀⠀⠀⠀⢸ ]],
    [[                 ⠀⠀⠀⠀⠀⢹⡤⠤⠄⠀⠀⠀⡔⠒⠛⠗⢲⠀⢀⠐⠚⠍⢑⡆⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⢰⠁⠀⡐⣧⣎⠀⠀⠀⠀⢸ ]],
    [[                 ⠀⠀⠀⠀⢰⣏⣙⣶⣒⣈⡁⠀⠈⠒⠂⠒⠁⠀⢸⠈⠒⠒⠊⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠁⠀⠀⠈⠒⠊⠀⠃⠀⠑⠀⠀⠀⢸ ]],
    [[                 ⠀⠀⠀⠀⣿⠉⣹⡍⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸ ]],
    [[                 ⠀⠀⠀⠀⠸⣝⣟⣅⡀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇ ]],
    [[                 ⠀⠀⠀⠀⠀⠙⢌⣁⡤⠤⠶⠤⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⢹⣈⣉⣉⣉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠃⠀ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡭⠥⠄⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⣀⠀⠀⠀⢀⡠⠔⠁⠀⠀ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡶⢭⣁⠀⠀⠀⠀⠀⢀⡤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠁⠀⠀⠀⠀  ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡧⠀⣈⡛⠒⠒⠒⠋⢹⠤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⠀⠀⠀⠀⠀⠀⠀⢀⡠⢴⠷⡏⠉⠉⠀⠀⠀⠀⠀⢸⣆⠈⢧⡙⡖⢤⠐⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⠀⠀⠀⢀⣀⣖⣚⣻⣛⣿⣏⢻⣄⡀⠀⠀⠀⠀⠀⢈⡼⢦⡀⢳⣿⣶⣤⡄⠑⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⠀⠀⣼⣁⣀⣉⣙⣿⣿⣿⣷⢸⡀⠈⠉⠓⣲⡶⣾⡍⠀⠀⣳⢄⣛⣟⣛⣠⣶⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⠀⢠⣟⣿⣿⢷⣶⣮⡭⢽⡒⣿⣗⣤⣀⣀⣻⠙⠁⢇⣴⣾⣿⣿⣷⣿⣾⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⣰⢻⣧⣍⡹⣽⣿⣧⡗⡤⣠⣥⣿⣿⣿⡾⣧⣘⣣⠼⢹⣿⣿⣿⣿⣿⣿⢻⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⣯⣽⣿⣿⢚⣻⣿⣷⣿⣫⣟⣻⣿⣿⣿⣷⡇⢸⣿⡄⢸⣿⣿⣿⣿⣿⣿⡿⣟⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[                 ⣾⣶⣿⣾⣯⣥⣿⣿⣟⣿⣯⣿⣿⣿⣿⣿⣿⣇⣸⣿⣃⣸⣿⣿⣿⣿⣿⣷⣿⣿⣿⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[]],
    [[]],
  },
  -- {
  --   [[]],
  --   [[]],
  --   [[                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⠀⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⠀⠀⠀⠀⢀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡀⠀⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⠀⠀⠠⠁⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡆⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠉⠉⠑⠒⠦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⢀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠒⠂⠤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀ ]],
  --   [[                    ⠀⠀⠀⠌⠀⠀⠀⠤⠀⠀⠀⠤⢄⡀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀ ]],
  --   [[                    ⠀⠠⡚⠀⠀⠀⠸⠀⠀⠀⠲⠀⠀⠈⢲⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢠⠃⠀⠀⠀⠀⠑⠄⣀⠀⠀⢀⡠⠊⢀⠃⠀⠀⠀⠀⠀⢠⠂⠉⠀⠒⠢⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⡜⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠎⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠶⠀⠀⠈⠑⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠣⣀⠀⠀⠀⠀⠀⢀⠜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠁⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠐⠒⠒⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡏⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡟⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⠚⠩⠖⡀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢤⡴⠁⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠴⣺⠁⣿⡇⠄⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣥⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣟⠃⠃⣿⡓⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡀⠀⠀⠀⠀⠀⠀⠐⡿⣿⣿⣿⣿⣿⣿⣿⣷⠶⢒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠟⠌⢀⡼⠓⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠛⠛⠛⠫⠉⠂⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⢟⡥⠆⠀⢛⠉⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⢒⢒⣓⡲⢟⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠀⠀⠄⡐⠁⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⣿⣿⣯⡯⠗⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⠀⠚⡇⠀⠀⠌⠀⠀⠀⢣⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣾⣿⣿⣇⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠀⢀⢤⣤⣤⠄⠈⠀⠀⠀⠀⡇⠀⡌⠀⠀⠀⠀⢠⣧⣢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⣿⣿⡄⠰⠀⠀⠀⢀⠔⡢⠡⠤⣖⠠⡀⠀⠀ ]],
  --   [[⠀⠀⠀⠀⠐⠁⠸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠰⠀⠀⠀⠀⢠⣿⣿⠟⢷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣀⣤⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⣇⣘⣂⡀⠣⠬⠥⠬⠆⠀ ]],
  --   [[⠀⠀⠀⠄⠀⠀⠀⣿⣧⡀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⢠⣿⡟⠁⠀⢠⣿⣿⣿⣶⣤⣤⣤⣤⣤⣤⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⡇⢀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⠀⡀⠀⠀⠀⢹⣿⣿⣴⣿⣿⣿⣿⣷⣄⠀⠀⢠⡿⠋⠀⠀⣠⣿⢟⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⠁⢸⠀⠈⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⠀⢀⢤⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⣰⠟⠀⠀⠀⣰⠟⢁⢣⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡿⢿⡇⣿⣿⡏⠀⡄⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⢀⠂⠋⠆⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⡼⠃⠀⡸⣎⣿⢽⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠯⡋⠓⢻⢸⣿⣿⠁⠀⠃⠀⠀⠀⠀⠂⢄⠀⠀⠀⠀⠀⠀⠀ ]],
  --   [[⠀⡈⡄⠀⢈⠄⠀⠀⠘⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠜⠀⠀⠀⡇⣿⣿⣼⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣅⢣⢶⣼⣦⣻⢸⣿⡇⠀⠸⠀⠀⠀⢸⡆⠀⠀⠈⠐⠠⢀⠀⠀⠀ ]],
  --   [[⠀⢱⡃⠀⠀⠈⢆⠀⠀⠈⠛⠿⠿⠟⠋⠀⠀⠀⠀⢠⠊⠀⠀⠀⠀⢣⣿⣿⣿⣿⣿⣿⣯⣙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⡏⣿⣿⠀⠀⡆⠀⠀⢀⡿⠀⠀⠀⠀⠀⠀⠀⠁⠢⡀ ]],
  --   [[⠘⡜⠉⣀⢀⣠⣭⣢⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡔⡱⢲⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡻⢊⣿⠇⠀⢰⠇⠀⠀⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀ ]],
  --   [[⢷⣗⢰⡎⡽⣿⡟⠷⢵⢄⠀⠀⠀⠀⠀⢀⡴⢫⠾⠃⡸⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⠽⠋⠀⢸⡿⠀⠀⣾⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⢀⣤⣾⢿⣿ ]],
  --   [[]],
  -- },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[  ⠀⠀⠀⢠⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣦⣠⣾⢋⡛⢷⣄⠀⠀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡀⠀ ]],
    [[  ⠀⠀⢰⣿⢫⠄⠤⠠⠄⠤⠠⠄⠤⠠⠄⠤⠠⠄⠤⠠⡽⣿⣦⢯⡻⣮⡚⣷⣼⣿⢫⠛⡛⢛⠛⡛⢛⠛⡛⢛⠛⡛⢛⠛⡛⠫⣽⣿⠀ ]],
    [[  ⠀⠀⢸⣿⠸⡊⡐⡁⡊⡐⡁⡊⡐⡁⡊⡐⡁⡊⡐⡁⣟⣿⣟⢮⡺⣜⢽⢦⣻⣿⢐⠅⢌⠄⢅⠌⢄⠅⢌⠄⢅⠌⢄⠅⡨⣢⢿⣿⠀ ]],
    [[  ⠀⠀⠈⠻⣷⣿⣽⢸⠔⡨⠐⢌⠐⢌⠐⢌⠠⡫⣺⣵⣾⣿⢝⡵⣹⡪⣳⢕⡟⣿⣷⣯⠗⠡⠢⡈⠢⡈⠢⡈⠢⡈⢂⢂⢞⣼⣾⠋⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⠢⡈⠢⡁⠪⡀⠕⡐⠄⣏⢾⣿⣫⢎⣗⢝⢮⡳⣝⢮⣫⣾⠟⢁⠔⡡⢑⠈⡢⢈⠢⡈⠢⣈⢖⣽⣾⠟⠁⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⢅⠨⢂⠌⠢⡈⠢⡈⠂⡧⣻⣿⣕⢯⡪⣏⢞⢮⢎⣷⠟⠁⡠⢂⠢⠐⠅⢌⠄⡑⢄⢊⡴⣯⣾⠟⠁⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⠢⠑⢄⠑⢌⠐⢅⠨⠂⡗⢽⣿⣎⢗⡝⣮⢫⣷⡿⠃⡠⢊⠄⡡⢊⠌⡂⠢⡈⢂⢶⢫⣿⠟⠁⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⡑⠡⡂⢑⠄⡑⢄⢑⠈⣏⢾⣿⢮⡳⣝⣾⡿⠋⡠⢎⠐⡡⢂⠢⢂⠌⡐⠅⡬⣪⣷⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⠅⠪⠠⡡⢈⠂⠢⠠⡁⡧⣻⣿⣳⣽⡿⠋⡠⠞⠡⡂⢑⠄⡡⠊⢔⢈⣢⢞⣵⣿⢿⡌⢿⣦⡀⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⣠⣿⣿⢸⡑⡑⠐⢄⠡⡁⡑⠐⠄⡗⢽⣿⡿⠋⠠⢊⠌⡊⢔⢈⠂⠢⡈⠢⣡⢾⣵⣿⢿⡫⡺⡺⡦⡪⡻⣦⡀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⣠⡾⢋⣼⣿⢸⠌⢌⢈⠂⠢⡈⢌⢈⠂⡟⡼⠋⢀⠔⡑⢄⠊⠔⠠⢂⠅⡑⢬⢺⣽⡿⣟⢝⢮⣝⢝⢮⡫⣞⢮⡪⡳⣤⠀⠀⠀ ]],
    [[  ⣠⡾⢋⣴⢿⣻⣿⢸⡑⠄⠢⡁⡑⠐⠄⢅⠨⡮⢁⠔⡡⢈⠢⡐⠡⡑⠡⢂⢌⡴⣣⣿⡯⣫⢮⡫⣞⢜⢧⡻⣜⢮⡳⣝⢮⡚⢷⣄⠀ ]],
    [[  ⠙⢿⣟⢷⡱⣻⣿⢸⢌⢈⠂⠢⠨⡈⡂⠢⢂⠗⡡⢊⠄⡑⢄⠊⢔⠈⢢⡵⣣⣿⣿⢫⢞⡵⣣⢻⣜⢝⡮⣺⢜⡵⣹⡪⣳⢿⡿⠋⠀ ]],
    [[  ⠀⠀⠙⢯⣟⣾⣿⢸⠢⠡⡁⡑⢐⠄⢌⠢⠡⡈⢂⠢⡈⠢⡐⡁⣶⠷⠿⢾⣿⢟⡜⡧⡻⣜⢧⡳⣕⢯⡺⣕⢯⡺⣵⣟⡿⠋⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠹⣿⣿⢸⡑⠔⠄⢌⠢⡈⡂⡑⠐⠌⢄⠅⡨⠂⢔⣸⢃⢊⠐⣽⡯⣪⢏⢾⡱⡳⣕⢯⣪⢳⢝⢮⣳⣿⡽⠋⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⢌⢈⠂⠢⠂⠔⡨⢈⠌⡂⠢⢂⠌⣢⢎⣿⡿⣻⢟⡟⡮⡳⣝⢵⡝⣵⢹⢎⡮⡳⣽⣫⡷⠋⠀⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⠢⠡⡁⡑⡁⢊⠔⠠⡊⡐⠡⣢⢾⣟⣛⢛⠛⣛⣿⢺⣟⡛⢛⠛⢻⣮⣷⠛⡛⠛⢿⣯⡵⠟⠿⠻⡻⡄⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⡑⠔⠄⢌⠄⡡⠊⠔⠄⣬⢞⣽⣿⣿⠇⢄⠑⣼⣯⢫⡿⠠⡁⣑⣐⣄⣢⠑⢌⠨⣂⣢⣈⣂⢑⠐⢼⠇⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⡌⡈⢂⠢⢂⢌⢈⢊⣜⣶⣿⡟⢷⡏⢂⠢⣱⣿⡪⣻⢃⠑⢄⣿⢿⣿⡟⡈⠢⣹⠋⠉⣽⠣⠠⣑⡟⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⠢⠨⡀⠕⠠⢂⡴⣫⣿⡟⣵⡹⡿⠠⡑⢄⣿⢮⣺⡟⠠⡑⣼⣿⣿⣾⠡⡈⢢⡏⠀⢠⣏⠊⠔⣼⠁⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⢸⣿⢸⡃⠢⡈⢌⣼⣫⣿⠟⠻⣽⢮⣾⠃⢆⠈⣾⣏⢷⣽⢁⠊⢴⣿⠟⢡⣏⠢⡈⣾⡁⠀⣾⠡⠊⢴⣏⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⠸⢿⣦⣷⣾⣶⣯⣾⠟⠁⠀⠀⠙⢿⣯⣬⣦⣵⣤⡿⡷⣧⣴⣥⠦⠟⠀⠺⠦⠦⠬⠼⠃⠸⠧⠥⠵⠤⠿⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠙⢿⣯⣻⣜⣝⣞⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣯⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
    [[]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[ .                                                          . ]],
    [[  ~7!^.                                                .^!7~  ]],
    [[   ~P&&G5J!^:.                                  .:^!J5G&&P~   ]],
    [[     ~G@@@@@&BPY7~.                        .~7YPB&@@@@@G~     ]],
    [[      .?&@@@@@@@@@?                        ?@@@@@@@@@&?.      ]],
    [[        ^B@@@@@@@@@7       ^:    :^       7@@@@@@@@@B^        ]],
    [[         .G@@@@@@@@@J      7B~  ~B7      J@@@@@@@@@G.         ]],
    [[          .B@@@@@@@@@P:    J@@BB@@?    ^P@@@@@@@@@B.          ]],
    [[           ^@@@@@@@@@@&J: .B@@@@@@B. :J&@@@@@@@@@@^           ]],
    [[            ?PB#@@@@@@@@&PB@@@@@@@@BP&@@@@@@@@#BP?            ]],
    [[               :^7YB@@@@@@@@@@@@@@@@@@@@@&BY7^:               ]],
    [[                    ^?G@@@@@@@@@@@@@@@@G?^                    ]],
    [[                       ^J#@@@@@@@@@@#J^                       ]],
    [[                         :J&@@@@@@&J:                         ]],
    [[                           :5@@@@5:                           ]],
    [[                             7&&7                             ]],
    [[                              !!                              ]],
    [[                                                              ]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[                                   ]],
    [[                                   ]],
    [[                                   ]],
    [[   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ]],
    [[    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ]],
    [[          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ]],
    [[           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ]],
    [[          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ]],
    [[   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ]],
    [[  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ]],
    [[ ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ]],
    [[ ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ]],
    [[      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ]],
    [[       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ]],
    [[                                   ]],
    [[]],
    [[]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⢀⢄⠀⠀⡴⠁⠈⡆⠀⢀⡤⡀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠢⣄⠀⠀⡇⠀⡕⠀⢸⠀⢠⠃⠀⢮⠀⠹⠀⠀⣠⢾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣞⠀⢀⠇⠀⡇⠀⡸⠀⠈⣆⠀⡸⠀⢰⠀⠀⡇⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠘⢶⣯⣊⣄⡨⠟⡡⠁⠐⢌⠫⢅⣢⣑⣵⠶⠁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⣼⣀⠀⢀⠒⠒⠂⠉⠀⠀⠀⠀⠁⠐⠒⠂⡀⠀⣸⣄⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢮⣵⣶⣦⡩⡲⣄⠀⠀⣿⣿⣽⠲⠭⣥⣖⣂⣀⣀⣀⣀⣐⣢⡭⠵⠖⣿⣿⢫⠀⠀⣠⣖⣯⣶⣶⣮⡷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢸⡟⢉⣉⠙⣿⣿⣦⠀⣿⣿⣿⣿⣷⣲⠶⠤⠭⣭⡭⠭⠴⠶⣖⣾⣿⣿⡿⢸⢀⣼⣿⡿⠋⣉⠉⢳⠁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠮⣳⣴⣫⠂⠘⣿⣿⣇⢷⢻⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣿⣿⣿⣿⣿⢿⢃⡟⣼⣿⣿⠁⠸⣘⣢⣚⠜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠈⢧⢻ ⣿⣿⣟⠻⣿⣿⣿⣿⠛⣩⣿⣿ ⢟⡞⢀⣿⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣒⣒⣦⣄⣿⣿⣿⢀⡬⣟⣯  ⣿⢷⣼⡟⢿⣿⡿⣿⣿  ⡻⣤⡀⣿⣿⣸⡠⢔⣒⡒⢤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⢾⣟⣅⠉⢎⣽⣿⣿⡏⡟⣤⣮⣿⣿  ⡏⣿⠀⠀⣿⢡⣷  ⣿⣟⢎⣷⢻⣿⣿⣾⡟⠉⣽⡇⡇⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⡴⣫⣭⣭⣍⡲⢄⠀⠀⠀⠀⠈⠻⠋⣠⡮⣻⣿⣿⠃⠳⣏⣼⣿⣿⣿⣿⡇⣿⣴⣴⣿⣾⣿⣿⣿⡿⣄⣩⠏⢸⣿⣿⣿⣧⡀⠛⠞⠁⠀⠀⠀⢀⣤⣺⣭⣭⣭⡝⢦⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⢸⢹⡟⠁⠀⠉⢫⡳⣵⣄⠀⠀⢀⠴⢊⣿⣾⣿⣿⣿⠀⠀⠀⠻⣬⣽⣿⣿⣿⣿  ⣿⣿⣿⣿⣯⣵⠏⠀⠀⢸⣿⣿⣿⣿⣿⣗⢤⡀⠀⠀⣠⣿⢟⠟⠉⠀⠈⢻⢸⡆⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠘⢏⢧⣤⡀⠀⠀⣇⢻⣿⣆⢔⢕⣵⠟⣏⣿⣿⣿⠋⣵⠚⠄⣾⣿⣿⣿⡿⠟⣛⣛⣛⣛⠻⣿⣿⣿⣿⣧⢰⠓⣏⠻⣿⣿⣿⢹⠻⣿⣿⢦⣸⣿⡏⡾⠀⠀⢠⣤⠎⡼⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠈⠑⠂⠁⠀⠀⣿⠸⣿⢏⢂⣾⠇⠀⣿⣿⣿⡇⡆⠹⢷⣴⣿⡿⠟⠉⣐⡀⠄⣠⡄⡠⣁⡠⠙⠻⢿⣿⣴⡾⠃⢠⢹⣿⣿⢸⠀⢹⣿⣷⢹⣿⢃⡇⠀⠀⠈⠒⠋⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡀⣿⢀⣿⣿⡀⠀⢫⣿⣿⣷⣙⠒⠀⠄⠐⠂⣼⠾⣵⠾⠟⣛⣛⠺⢷⣮⠷⣢⠐⠂⠀⠀⠒⣣⣾⣿⡿⡎⠀⢠⣿⣿⡄⣿⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣟⣿⢸⣿⣿⣷⣄⡈⣾⣿⣿⣿⣿⣿⠻⡷⢺⠃⠠⠁⠈⠋⠀⠀⠉⠁⠙⡀⠘⡗⣾⠿⣿⣿⣿⣿⣿⡿⢀⣴⣿⣿⡿⢃⣯⣽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⡆⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣵⡞⠀⠁⠐⢁⠎⠄⣠⠀⠀⡄⠀⢳⠈⠆⠈⠈⢳⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣸⡷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣌⠛⢿⣿⣿⣿⣿⣿⣿⠿⠋⣠⣢⠂⠀⢂⠌⠀⠃⠀⠀⠘⠀⢢⡑⠀⠰⣵⡀⠻⢿⣿⣿⣿⣿⣿⣿⡿⠋⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠳⣤⣭⢛⣻⠿⣿⣷⣶⢞⡟⡁⢀⢄⠎⠀⠀⠀⠀⠀⡀⠁⠀⠳⢠⠀⢈⢿⢳⣶⣾⣿⠿⣟⣛⣅⡴⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠻⠿⠿⡟⢜⠔⡠⢊⠔⠀⡆⠀⡆⠀⠀⢡⢰⢠⠀⢢⠱⣌⢂⠃⢿⠿⠿⠟⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢤⣊⡰⠵⢺⠉⠸⠀⢰⢃⠀⠀⠀⠀⠀⠸⢸⠀⠀⡇⡞⡑⠬⢆⣑⢤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠘⣾⡸⢀⡜⡾⡀⡇⠀⠀⡴⢠⢻⢦⠀⢃⡿⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡎⠀⠱⡡⠐⠀⠠⠃⢢⠋⠀⢧⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢤⡀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[]],
    [[]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⠿⠿⠿⠿⢿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣶⣾⣿⣿⠀⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⠀⣿⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⣿⡿⠟⠛⠉⠉⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠉⠉⠛⠻⢿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡿⠋⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠃⠀⠀⣠⣶⣾⣿⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⣿⣷⣦⣄⠀⠀⠸⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⢀⣾⣿⡿⠛⠉⠀⣿⣿⡇⠀⠀⣀⣀⠀⠀⠀⠀⠀⣀⣀⠀⠀⢸⣿⣿⠀⠉⠛⢿⣿⣷⡀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣆⢸⣿⣿⠀⠀⠀⠀⣿⣿⡇⠀⢾⣿⣿⡇⠀⠀⠀⢾⣿⣿⡇⠀⢸⣿⣿⠀⠀⠀⠈⣿⣿⡇⣼⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣄⠀⠀⠀⣿⣿⡇⠀⠈⠙⠋⠀⠀⠀⠀⠈⠙⠋⠀⠀⢸⣿⣿⠀⠀⠀⣰⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣷⣶⣶⣿⣿⣿⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⣿⣿⣶⣶⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠛⠛⠛⠛⠛⠛⢻⣿⣿⠛⣿⣿⣿⢻⣿⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣈⣉⣉⣉⣉⡉⢹⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡏⢉⣉⣉⣉⣉⣁⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⣿⣄⣼⣿⣿⠀⣿⣿⣿⠸⣿⣿⣆⣠⣿⣿⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣄⠻⢿⣿⣿⠿⢋⣴⣿⣿⣿⣦⡙⠿⣿⣿⡿⠛⣠⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣷⣶⣤⣴⣶⣿⣿⠿⠙⢿⣿⣿⣶⣦⣴⣶⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⠛⠋⠁⠀⠀⠀⠈⠙⠛⠿⠿⠛⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⠀⠀⠀⠀⢰⣶⣶⣶⣶⡆⠀⣠⣿⡿⣿⣷⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⡤⠀⠀⠀⠀⠀⢀⡀⠀⠀⠄⠊⠉⠉⣍⠉⠛⠻⣿⣷⣦⡀⣸⣿⣿⣿⠿⠃⠀⢿⣿⣷⠀⠉⠙⠛⠻⠿⠶⠶⠶⣒⣒⣈⣀⣀⣠⣠⣀⠀⠀⠈⢻⣿⣿⡄⠀⠀⢀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⡏⣀⠀⠀⠀⢀⣴⣿⣿⣿⣶⡄⠀⠀⣴⣿⣷⣄⡀⠈⢻⣿⣿⣮⠹⣿⣿⡆⠀⠀⠸⣿⣿⣇⢀⣿⣿⣿⣿⣿⣿⡟⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣿⣿⣷⢀⣤⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⡟⠉⢹⣿⣿⣿⣍⠉⣾⣿⣷⡄⠐⣿⣿⣿⠛⢿⣿⣿⢰⣾⣿⡿⢿⣿⢃⣴⡅⢹⣿⣿⡆⢿⣿⣿⠀⠀⠀⢻⣿⣿⡘⣿⣿⣿⠉⣿⣿⣧⠘⣩⣭⣉⠉⠉⠈⠉⣻⣿⣿⡇⢸⣿⣿⣿⣿⡿⠛⠉⠉⠉⠉⠉⠑⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠙⠻⣿⣿⣧⠈⢻⣿⣿⡄⢹⣿⣿⡇⠸⣿⣿⣏⣿⣿⣧⠈⠏⣿⣿⣧⠀⢿⣿⣿⠘⣿⣿⣇⠀⠀⠈⣿⣿⣧⠸⣿⣿⡇⢹⣿⣿⡶⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠈⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⠞⠋⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⡆⠈⣿⣿⣷⠀⢿⣿⣿⡀⢻⣿⣿⣼⣿⣿⡆⠀⢹⣿⣿⡆⠸⣿⣿⣇⢻⣿⣿⡀⢰⠀⢹⣿⣿⡆⢿⣿⣿⡀⢿⣿⣿⠘⣿⣿⣟⢻⣿⣯⣍⠁⠀⢸⠀⢿⣿⣿⠛⢻⣿⣿⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠈⣿⣿⣷⢿⣿⣿⠀⠀⣿⣿⣿⠀⢻⣿⣿⡘⣿⣿⣇⠘⣇⠈⣿⣿⣷⠘⣿⣿⣧⠘⣿⣿⣇⢹⣿⣿⡞⠿⣿⣿⣦⢀⣾⣷⣼⣿⣿⡇⠀⠹⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⢠⡾⠟⠛⠛⠛⠛⠛⠛⠛⠛⢻⣿⣿⡟⠛⢿⣿⣿⠛⢻⣿⣿⣂⡸⣿⣿⣾⣿⣿⣇⠀⣿⣿⣿⣁⠈⣿⣿⣧⢻⣿⣿⡸⣿⣦⡸⣿⣿⡇⢹⣿⣿⣄⣹⣿⡟⠘⣿⣿⣇⠀⠹⣿⣿⣯⠛⢿⣿⣿⣿⣿⡀⠀⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣷⠀⠸⣿⣿⡇⠸⣿⣿⣿⣿⣿⣿⡿⢻⣿⣿⣀⡿⣿⣿⣿⣿⠟⠉⠠⣼⣿⣯⣁⢿⣿⣿⣿⣿⣿⡸⠿⣿⣿⣿⡿⠀⠀⢻⣿⣿⣤⡂⠹⣿⣿⣆⠀⠉⠻⣿⣿⡿⠁⠸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣧⠀⢻⣿⣿⡄⠀⠈⠙⠀⠈⠉⠃⠈⣿⣿⠏⠀⠀⠀⠉⠋⠀⣀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠈⠉⠃⠀⠀⠈⠻⣿⠋⠀⠀⠹⣿⣿⣷⣄⡀⠀⠉⣠⠀⠀⢿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⡟⠈⢿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⢸⠏⠀⠀⠀⠀⠀⠀⡔⠉⠁⠀⠀⠈⠹⡿⠛⠁⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣷⡾⠃⠀⠀⠘⣿⣿⣷⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠀⠀⠈⠻⣿⣿⣿⡀⠀⢀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠈⠛⠿⠷⠦⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[]],
    [[  ██████   █████                   █████   █████  ███                  ]],
    [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
    [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
    [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
    [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
    [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
    [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
    [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
    [[                                                                       ]],
    [[]],
  },
  {
    [[]],
    [[]],
    [[]],
    [[                               _                          ]],
    [[                           ,--.\`-. __                    ]],
    [[                         _,.`. \:/,"  `-._                ]],
    [[                     ,-*" _,.-;-*`-.+"*._ )               ]],
    [[                    ( ,."* ,-" / `.  \.  `.               ]],
    [[                   ,"   ,;"  ,"\../\  \:   \              ]],
    [[                  (   ,"/   / \.,' :   ))  /              ]],
    [[                   \  |/   / \.,'  /  // ,'               ]],
    [[                    \_)\ ,' \.,'  (  / )/                 ]],
    [[                        `  \._,'   `"                     ]],
    [[                           \../                           ]],
    [[                           \../                           ]],
    [[                 ~        ~\../           ~~              ]],
    [[          ~~          ~~   \../   ~~   ~      ~~          ]],
    [[     ~~    ~   ~~  __...---\../-...__ ~~~     ~~          ]],
    [[       ~~~~  ~_,--'        \../      `--.__ ~~    ~~      ]],
    [[   ~~~  __,--'              `"             `--.__   ~~~   ]],
    [[~~  ,--'                                         `--.     ]],
    [[   '------......______             ______......------` ~  ]],
    [[ ~~~   ~    ~~      ~ `````---"""""  ~~   ~     ~~        ]],
    [[        ~~~~    ~~  ~~~~       ~~~~~~  ~ ~~   ~~ ~~~  ~   ]],
    [[     ~~   ~   ~~~     ~~~ ~         ~~       ~~   SSt     ]],
    [[              ~        ~~       ~~~       ~               ]],
    [[]],
    [[]],
  },
}

return function()
  math.randomseed(os.time())
  local check = math.random(1, #logos)
  return logos[check]
end
-- {
--   __index = function(logos, key)
--     if key == "random" then
--     end
--     return logos[key]
--   end,
-- })
