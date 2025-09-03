return {
  -- Matches: a URL in parens: (URL)
  {
    regex = "\\((\\w+://\\S+)\\)",
    format = "$0",
    highlight = 1,
  },
  -- Matches: a URL in brackets: [URL]
  {
    regex = "\\[(\\w+://\\S+)\\]",
    format = "$0",
    highlight = 1,
  },
  -- Matches: a URL in curly braces: {URL}
  {
    regex = "\\{(\\w+://\\S+)\\}",
    format = "$0",
    highlight = 1,
  },
  -- Matches: a URL in angle brackets: <URL>
  {
    regex = "<(\\w+://\\S+)>",
    format = "$0",
    highlight = 1,
  },

  -- match the URL with a PORT
  -- such 'http://localhost:3000/index.html'
  {
    regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b",
    format = "$0",
  },

  -- ╓
  -- ║ ERRORS
  -- ╙
  {
    regex = "^/[^/\r\n]+(?:/[^/\r\n]+)*:\\d+:\\d+",
    format = "$0",
  },
}
