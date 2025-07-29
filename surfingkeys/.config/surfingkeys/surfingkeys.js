// check default keys:
// https://github.com/brookhong/Surfingkeys/blob/master/src/content_scripts/common/default.js#L485-L491
//
// Awesome stuff
// https://github.com/b0o/surfingkeys-conf

const {
  Clipboard,
  Front,
  Hints,
  RUNTIME,
  Visual,
  addSearchAlias,
  cmap,
  imap,
  iunmap,
  map,
  mapkey,
  tabOpenLink,
  unmap,
  vmap,
} = api;

unmap("H");
unmap("<<");
unmap(">>");

// general settings
settings.historyMUOrder = false;
settings.tabsMRUOrder = false;
settings.omnibarMaxResults = 20;
settings.tabsThreshold = 0;

function scrollBySmooth(size, ward) {
  window.scrollTo({
    top: window.scrollY + ward * size,
    left: 0,
    behavior: "smooth",
  });
}

function scrollToSmooth(position) {
  window.scrollTo({
    top: position,
    left: 0,
    behavior: "smooth",
  });
}

// ╭─────────────────────────────────────────────────────────╮
// │ GENERAL                                                 │
// ╰─────────────────────────────────────────────────────────╯
mapkey("<Ctrl-d>", "#2Scroll down of half", () => {
  scrollBySmooth(window.innerHeight / 2, 2);
});
mapkey("<Ctrl-u>", "#2Scroll up of half", () => {
  scrollBySmooth(window.innerHeight / 2, -2);
});

mapkey("G", "#2Jump to the bottom of the page", () => {
  scrollToSmooth(1000000000);
});
mapkey("gg", "#2Jump to the top of the page", () => {
  scrollToSmooth(-1000000000);
});

mapkey("k", "#2Scroll up of line", () => {
  scrollBySmooth(window.innerHeight / 10, -2);
});
mapkey("j", "#2Scroll down of line", () => {
  scrollBySmooth(window.innerHeight / 10, 2);
});

mapkey("<Ctrl-f>", "#2Scroll down of page", () => {
  scrollBySmooth(window.innerHeight * 10, 3);
});
mapkey("<Ctrl-b>", "#2Scroll up of page", () => {
  scrollBySmooth(window.innerHeight * 10, -3);
});

// ╭─────────────────────────────────────────────────────────╮
// │ EDITING                                                 │
// ╰─────────────────────────────────────────────────────────╯
unmap("/");
map("<Ctrl-g>", "/");

// ╭─────────────────────────────────────────────────────────╮
// │ OPEN LINKS                                              │
// ╰─────────────────────────────────────────────────────────╯
map("F", "gf");
map("C", ";u");

mapkey("<Alt-f>", "Open Links With simulates Zen's Glance", () => {
  Hints.create("*[href]", (element) => {
    const event = new MouseEvent("click", {
      altKey: true,
      bubbles: true,
      cancelable: true,
      view: window,
    });
    element.dispatchEvent(event);
  });
});

mapkey(
  "Q",
  "#1Click on an Image or a button in background, multiple",
  function () {
    Hints.create("img, button", Hints.dispatchMouseClick, {
      multipleHits: true,
      tabbed: true,
      active: false,
    });
  },
);

// TEST ============================================================
// mapkey(";dv", "#1Download video", function () {
//   Hints.create("video", function (element) {
//     var src = element.src || element.querySelector(`source[src$="mp4"]`).src;
//     RUNTIME("download", {
//       url: src,
//     });
//   });
// });

// mapkey("ys", "#8Open link in split view", function () {
//   Hints.create("*[href]", (element) => {
//     const event = new MouseEvent("click", {
//       bubbles: true,
//       cancelable: true,
//       view: window,
//       button: 2, // 2 represents the right mouse button
//     });
//     element.dispatchEvent(event);
//   });
// });
//
// mapkey("yd", "#8Debug hint", function () {
//   Hints.create("*[href]", function (element) {
//     RUNTIME("openLink", {
//       url: element.href,
//       tab: { tabbed: true, split: true },
//     });
//     console.log("Mencoba membuka:", element.href);
//   });
// });
//
// mapkey("yk", "#8Open link in split view", function () {
//   Hints.create("*[href]", function (element) {
//     window.postMessage(
//       {
//         type: "cmd_zenSplitViewLinkInNewTab",
//         url: element.href,
//       },
//       "*",
//     );
//   });
// });

// ╭─────────────────────────────────────────────────────────╮
// │ OMNIBAR                                                 │
// ╰─────────────────────────────────────────────────────────╯
cmap("<Ctrl-j>", "<Tab>");
cmap("<Ctrl-k>", "<Shift-Tab>");
cmap("<Ctrl-n>", "<Tab>");
cmap("<Ctrl-p>", "<Shift-Tab>");

// ╭─────────────────────────────────────────────────────────╮
// │ TAB                                                     │
// ╰─────────────────────────────────────────────────────────╯
mapkey("<Alt-ArrowLeft>", "#3Move current tab to left", function () {
  RUNTIME("moveTab", { step: -1 });
});
mapkey("<Alt-ArrowRight>", "#3Move current tab to right", function () {
  RUNTIME("moveTab", { step: 1 });
});
mapkey("<Alt-ArrowUp>", "#3Move current tab to up", function () {
  RUNTIME("moveTab", { step: -1 });
});
mapkey("<Alt-ArrowDown>", "#3Move current tab to down", function () {
  RUNTIME("moveTab", { step: 1 });
});
mapkey("<Space>bO", "#3Close all tabs except current one", function () {
  RUNTIME("tabOnly");
});
mapkey("<Alt-b>", "#3Close alternate the tabs", function () {
  RUNTIME("goToLastTab");
});
mapkey("M", "Mute/unmute current tab", function () {
  RUNTIME("muteTab");
});

map("<Space>ff", "T");
map("<Space>fF", "t"); // include bookmark search
map("<Ctrl-l>", "R");
map("<Ctrl-h>", "E");
// map("<Alt-h>", "R");
// map("<Alt-l>", "E");

// map("<Alt-j>", "R");
// map("<Alt-k>", "E");

mapkey("gxk", "#3Close tab on up", function () {
  RUNTIME("closeTabLeft");
});
mapkey("gxj", "#3Close tab on down", function () {
  RUNTIME("closeTabRight");
});
mapkey("gxK", "#3Close all tabs on up", function () {
  RUNTIME("closeTabsToLeft");
});
mapkey("gxJ", "#3Close all tabs on down", function () {
  RUNTIME("closeTabsToRight");
});

mapkey(
  "<Alt-l>",
  "Go one tab right",
  function () {
    RUNTIME("nextTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Alt-j>",
  "Go one tab right",
  function () {
    RUNTIME("nextTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Alt-h>",
  "Go one tab left",
  function () {
    RUNTIME("previousTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Alt-k>",
  "Go one tab left",
  function () {
    RUNTIME("previousTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Alt-n>",
  "Go one tab right",
  function () {
    RUNTIME("nextTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Alt-p>",
  "Go one tab left",
  function () {
    RUNTIME("previousTab");
  },
  { repeatIgnore: true },
);

map("gH", ":feedkeys 99E", 0, "#3Go to the first tab");
map("gL", ":feedkeys 99R", 0, "#3Go to the last tab");
map("gK", ":feedkeys 99E", 0, "#3Go to the first tab");
map("gJ", ":feedkeys 99R", 0, "#3Go to the last tab");
map("<Space>R", ":feedkeys 99r", 0, "#3Reload all tab");

// mapkey("<Ctrl-o>", "backward", function () {
//   history.go(-1);
// });
// mapkey("<Ctrl-i>", "forward", function () {
//   history.go(1);
// });

map("<Ctrl-o>", "S");
map("<Ctrl-i>", "D");

mapkey("q", "#3Close current tab", () => {
  RUNTIME("closeTab");
});
mapkey("<Space><Tab>", "#3Close current tab", () => {
  RUNTIME("closeTab");
});

// open current history tab
mapkey("<Space>fo", "#8Open Recently Closed", () => {
  Front.openOmnibar({ type: "RecentlyClosed" });
});
// open global history tab
mapkey("<Space>fO", "#8Open History", () => {
  Front.openOmnibar({ type: "History" });
});

// ╭─────────────────────────────────────────────────────────╮
// │ BOOKMARKS                                               │
// ╰─────────────────────────────────────────────────────────╯
// Open bookmark
mapkey("<Alt-B>", "#8Open a bookmark", function () {
  Front.openOmnibar({ type: "Bookmarks" });
});

// ╭─────────────────────────────────────────────────────────╮
// │ ZOOM                                                    │
// ╰─────────────────────────────────────────────────────────╯
mapkey("<Ctrl-0>", "#3zoom reset", function () {
  RUNTIME("setZoom", {
    zoomFactor: 0,
  });
});

// ╭─────────────────────────────────────────────────────────╮
// │ SEARCH                                                  │
// ╰─────────────────────────────────────────────────────────╯
addSearchAlias(
  "s",
  "StackOverflow",
  "https://stackoverflow.com/search?q=",
  "s",
  "https://api.stackexchange.com/2.2/search/advanced?pagesize=10&" +
    "order=desc&sort=relevance&site=stackoverflow&q=",
  function (response) {
    var res = JSON.parse(response.text)["items"];
    return res.map(function (r) {
      return {
        title: "[" + r.score + "] " + r.title,
        url: r.link,
      };
    });
  },
);

addSearchAlias(
  "g",
  "Google",
  "https://www.google.com/search?q=",
  "s",
  "https://www.google.com/complete/search?client=chrome-omni&gs_ri=chrome-ext&oit=1&cp=1&pgcl=7&q=",
  function (response) {
    var res = eval(response.text);
    Omnibar.listWords(res[1]);
  },
);

// mapkey("p", "Open the clipboard in the current tab", function () {
//   let data;
//   Clipboard.read(function (response) {
//     if (
//       response.data.startsWith("http://") ||
//       response.data.startsWith("https://") ||
//       response.data.startsWith("www.")
//     ) {
//       data = response.data;
//     } else {
//       data = "https://www.google.com/search?q=" + response.data;
//     }
//     RUNTIME("openLink", {
//       tab: { tabbed: false },
//       url: data,
//     });
//   });
// });

addSearchAlias(
  "G",
  "GitHub",
  "https://github.com/search?q=",
  "s",
  "https://api.github.com/search/repositories?order=desc&q=",
  function (response) {
    var res = JSON.parse(response.text)["items"];
    return res.map(function (r) {
      var prefix = "";
      if (r.stargazers_count) {
        prefix += "[★" + r.stargazers_count + "] ";
      }
      return {
        title: prefix + r.description,
        url: r.html_url,
      };
    });
  },
);

addSearchAlias(
  "y",
  "YouTube LOL",
  "https://www.youtube.com/results?search_query=",
);

// ╭─────────────────────────────────────────────────────────╮
// │ HINT                                                    │
// ╰─────────────────────────────────────────────────────────╯
// Link Hints
Hints.style(`
    font-family: 'JetBrainsMono Nerd Font Mono', 'SF Pro', monospace;
    font-size: 18px;
    font-weight: bold;
    text-transform: lowercase;
    color: #FFFF00 !important;
    background: #3B4252 !important;
    border: solid 1px #4C566A !important;
    text-align: center;
    padding: 5px;
    line-height: 1;
  `);

// Text Hints
Hints.style(
  `
    font-family: 'JetBrainsMono Nerd Font Mono', 'SF Pro', monospace;
    font-size: 18px;
    font-weight: bold;
    text-transform: lowercase;
    color: #FFFF00 !important;
    background: #6272a4 !important;
    border: solid 2px #4C566A !important;
    text-align: center;
    padding: 5px;
    line-height: 1;
  `,
  "text",
);

// set visual-mode style
Visual.style(
  "marks",
  "background-color: #A3BE8C; border: 1px solid #3B4252 !important; text-decoration: underline;",
);
Visual.style(
  "cursor",
  "background-color: #E5E9F0 !important; border: 1px solid #6272a4 !important; border-bottom: 2px solid green !important; padding: 2px !important; outline: 1px solid rgba(255,255,255,.75) !important;",
);

// ╭─────────────────────────────────────────────────────────╮
// │ THEMES                                                  │
// ╰─────────────────────────────────────────────────────────╯
settings.theme = `
  :root {
    --font: "JetBrainsMono Nerd Font Mono", Arial, sans-serif;
    --font-size: 18px;
    --font-weight: bold;
    --fg: #E5E9F0;
    --bg: #3B4252;
    --bg-dark: #2E3440;
    --border: #4C566A;
    --main-fg: #88C0D0;
    --accent-fg: #A3BE8C;
    --info-fg: #5E81AC;
    --select: #4C566A;
    --orange: #D08770;
    --red: #BF616A;
    --yellow: #EBCB8B;
  }
  /* ---------- Generic ---------- */
  .sk_theme {
  background: var(--bg);
  color: var(--fg);
    background-color: var(--bg);
    border-color: var(--border);
    font-family: var(--font);
    font-size: var(--font-size);
    font-weight: var(--font-weight);
  }
  input {
    font-family: var(--font);
    font-weight: var(--font-weight);
  }

  div.surfingkeys_cursor {
    background-color: #0642CE;
    color: red;
  }
  .sk_theme tbody {
    color: var(--fg);
  }
  .sk_theme input {
    color: var(--fg);
  }
  /* Hints */
  #sk_hints .begin {
    color: var(--accent-fg) !important;
  }
  #sk_tabs .sk_tab {
    background: var(--bg-dark);
    border: 1px solid var(--border);
  }
  #sk_tabs .sk_tab_title {
    color: var(--fg);
  }
  #sk_tabs .sk_tab_url {
    color: var(--main-fg);
  }
  #sk_tabs .sk_tab_hint {
    background: var(--bg);
    border: 1px solid var(--border);
    color: var(--accent-fg);
  }
  .sk_theme #sk_frame {
    background: var(--bg);
    opacity: 0.2;
    color: var(--accent-fg);
  }

  /* ---------- Omnibar ---------- */
  /* Uncomment this and use settings.omnibarPosition = 'bottom' for Pentadactyl/Tridactyl style bottom bar */
  /* .sk_theme#sk_omnibar {
    width: 100%;
    left: 0;
  } */
  .sk_theme .title {
    color: var(--accent-fg);
  }
  .sk_theme .url {
    color: var(--main-fg);
  }
  .sk_theme .annotation {
    color: var(--accent-fg);
  }
  .sk_theme .omnibar_highlight {
    color: var(--accent-fg);
  }
  .sk_theme .omnibar_timestamp {
    color: var(--info-fg);
  }
  .sk_theme .omnibar_visitcount {
    color: var(--accent-fg);
  }
  .sk_theme #sk_omnibarSearchResult ul li .url {
    font-size: calc(var(--font-size) - 2px);
  }
  .sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: var(--border);
    padding: 5px;
  }
  .sk_theme #sk_omnibarSearchResult ul li:nth-child(even) {
    background: var(--border);
    padding: 5px;
  }
  .sk_theme #sk_omnibarSearchResult ul li.focused {
    background: var(--bg-dark);
    border-left: 2px solid var(--orange);
    padding: 5px;
    padding-left: 15px;
  }
  .sk_theme #sk_omnibarSearchArea {
    border-top-color: var(--border);
    border-bottom-color: transparent;
    margin: 0;
    padding: 5px 10px;
  }
  .sk_theme #sk_omnibarSearchArea:before {
    content: "󱋤";
    display: inline-block;
    margin-left: 5px;
    font-size: 22px;
  }
  .sk_theme #sk_omnibarSearchArea input,
  .sk_theme #sk_omnibarSearchArea span {
    font-size: 20px;
    padding:10px 0;
  }
  .sk_theme #sk_omnibarSearchArea .prompt {
    text-transform: uppercase;
    padding-left: 10px;
  }
  .sk_theme #sk_omnibarSearchArea .prompt:after {
    content: "";
    display: inline-block;
    margin-right: 5px;
    color: var(--accent-fg);
  }
  .sk_theme #sk_omnibarSearchArea .separator {
    color: var(--bg);
    display: none;
  }
  .sk_theme #sk_omnibarSearchArea .separator:after {
    content: "";
    display: inline-block;
    margin-right: 5px;
    color: var(--accent-fg);
  }

  /* ---------- Popup Notification Banner ---------- */
  #sk_banner {
    font-family: var(--font);
    font-size: var(--font-size);
    font-weight: var(--font-weight);
    background: var(--bg);
    border-color: var(--border);
    color: var(--fg);
    opacity: 0.9;
  }

  /* ---------- Popup Keys ---------- */
  #sk_keystroke {
    background-color: var(--bg);
  }
  .sk_theme kbd .candidates {
    color: var(--info-fg);
  }
  .sk_theme span.annotation {
    color: var(--accent-fg);
  }

  /* ---------- Popup Translation Bubble ---------- */
  #sk_bubble {
    background-color: var(--bg) !important;
    color: var(--fg) !important;
    border-color: var(--border) !important;
  }
  #sk_bubble * {
    color: var(--fg) !important;
  }
  #sk_bubble div.sk_arrow div:nth-of-type(1) {
    border-top-color: var(--border) !important;
    border-bottom-color: var(--border) !important;
  }
  #sk_bubble div.sk_arrow div:nth-of-type(2) {
    border-top-color: var(--bg) !important;
    border-bottom-color: var(--bg) !important;
  }

  /* ---------- Search ---------- */
  #sk_status,
  #sk_find {
    font-size: var(--font-size);
    border-color: var(--border);
  }
  .sk_theme kbd {
    background: var(--bg-dark);
    border-color: var(--border);
    box-shadow: none;
    color: var(--fg);
  }
  .sk_theme .feature_name span {
    color: var(--main-fg);
  }

  /* ---------- ACE Editor ---------- */
  #sk_editor {
    background: var(--bg-dark) !important;
    height: 50% !important;
    /* Remove this to restore the default editor size */
  }
  .ace_dialog-bottom {
    border-top: 1px solid var(--bg) !important;
  }
  .ace-chrome .ace_print-margin,
  .ace_gutter,
  .ace_gutter-cell,
  .ace_dialog {
    background: var(--bg) !important;
  }
  .ace-chrome {
    color: var(--fg) !important;
  }
  .ace_gutter,
  .ace_dialog {
    color: var(--fg) !important;
  }
  .ace_cursor {
    color: var(--fg) !important;
  }
  .normal-mode .ace_cursor {
    background-color: var(--fg) !important;
    border: var(--fg) !important;
    opacity: 0.7 !important;
  }
  .ace_marker-layer .ace_selection {
    background: var(--select) !important;
  }
  .ace_editor,
  .ace_dialog span,
  .ace_dialog input {
    font-family: var(--font);
    font-size: var(--font-size);
    font-weight: var(--font-weight);
  }

  /* Disable RichHints CSS animation */
  .expandRichHints {
      animation: 0s ease-in-out 1 forwards expandRichHints;
  }
  .collapseRichHints {
      animation: 0s ease-in-out 1 forwards collapseRichHints;
  }
  `;
