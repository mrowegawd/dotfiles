// check default keys:
// https://github.com/brookhong/Surfingkeys/blob/master/src/content_scripts/common/default.js#L485-L491

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
  unmapAllExcept,
  tabOpenLink,
  unmap,
  vmap,
} = api;

unmap("<<");
unmap(">>");

unmap("H");
unmap("L");
unmap("<Ctrl-j>");
unmap("<Ctrl-k>");

imap('hh', '<Esc>');

// general settings
settings.historyMUOrder = false;
settings.tabsMRUOrder = false;
settings.omnibarMaxResults = 20;
settings.tabsThreshold = 0;
settings.omnibarPosition = 'bottom';
settings.showTabIndices = true;

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

mapkey("]", "#Increase speed video", () => {
  const video = document.querySelector("video");
  if (!video) return;
  video.playbackRate = video.playbackRate + 0.1;
  api.Front.showBanner(`${video.playbackRate.toFixed(1)}x`);
});

mapkey("[", "#Decrement speed video", () => {
  const video = document.querySelector("video");
  if (!video) return;
  video.playbackRate = video.playbackRate - 0.1;
  api.Front.showBanner(`${video.playbackRate.toFixed(1)}x`);
});

// ╭─────────────────────────────────────────────────────────╮
// │ SCROLL                                                  │
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

// mapkey("<Ctrl-f>", "#2Scroll down of page", () => {
//   scrollBySmooth(window.innerHeight * 10, 3);
// });
// mapkey("<Ctrl-b>", "#2Scroll up of page", () => {
//   scrollBySmooth(window.innerHeight * 10, -3);
// });

// ╭─────────────────────────────────────────────────────────╮
// │ EDITING                                                 │
// ╰─────────────────────────────────────────────────────────╯
unmap("<Ctrl-g>");
map("<Ctrl-g>", "<Ctrl-f>");

// ╭─────────────────────────────────────────────────────────╮
// │ OPEN LINKS                                              │
// ╰─────────────────────────────────────────────────────────╯

// const hintsCharactersRight = "dhtnsbmwvzcr";
// const hintsCharactersLeft = "iueoakjq;";
const hintsCharactersAll = "crhtnsueoabmwvzkjq;";

Hints.charactersUpper = false;
Hints.style("font-size: 14px !important;");
settings.hintAlign = "left";

unmap("f");
mapkey("f", "#1Open a link", () => {
  Hints.setCharacters(hintsCharactersAll);
  Hints.create("", Hints.dispatchMouseClick);
});

unmap("F");
mapkey("F", "#1Open a link in non-active new tab or click", () => {
  Hints.setCharacters(hintsCharactersAll);
  Hints.create("", Hints.dispatchMouseClick, { tabbed: true, active: false });
});

map("<Ctrl-Space>E", ";u");
map("<Alt-f>", "cf", 0, "#1Open multiple links in a new tab (alternative)");

// WARN: Currently, Idk why this map doesn't work anymore
// mapkey("<Alt-f>", "#1Open link and simulates Zen's Glance", () => {
//   Hints.create("*[href]", (element) => {
//     const event = new MouseEvent("click", {
//       altKey: true,
//       bubbles: true,
//       cancelable: true,
//       view: window,
//     });
//     element.dispatchEvent(event);
//   });
// });


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
cmap("<Alt-p>", "<Tab>");
cmap("<Alt-n>", "<Shift-Tab>");
cmap("<Ctrl-p>", "<Tab>");
cmap("<Ctrl-n>", "<Shift-Tab>");

// ╭─────────────────────────────────────────────────────────╮
// │ TAB                                                     │
// ╰─────────────────────────────────────────────────────────╯
mapkey("<Ctrl-Alt-ArrowLeft>", "#3Move current tab to left", function () {
  RUNTIME("moveTab", { step: -1 });
});
mapkey("<Ctrl-Alt-ArrowRight>", "#3Move current tab to right", function () {
  RUNTIME("moveTab", { step: 1 });
});
mapkey("<Ctrl-Alt-ArrowUp>", "#Move current tab to up", function () {
  RUNTIME("moveTab", { step: -1 });
});
mapkey("<Ctrl-Alt-ArrowDown>", "#Move current tab to down", function () {
  RUNTIME("moveTab", { step: 1 });
});
mapkey("<Space>bK", "#3Close all tabs except current one", function () {
  RUNTIME("tabOnly");
});
mapkey("<Space>bl", "#3Alternate the tabs", function () {
  RUNTIME("goToLastTab");
});
mapkey("M", "#3Mute/unmute current tab", function () {
  RUNTIME("muteTab");
});

map("<Space>ff", "T");
map("<Ctrl-Alt-l>", "R");
map("<Ctrl-Alt-h>", "E");
map("<Alt-l>", "R");
map("<Alt-h>", "E");

mapkey(
  "<Ctrl-l>",
  "#Go one tab right",
  function () {
    RUNTIME("nextTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Ctrl-h>",
  "#3Go one tab left",
  function () {
    RUNTIME("previousTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Ctrl-j>",
  "#3Go one tab right",
  function () {
    RUNTIME("nextTab");
  },
  { repeatIgnore: true },
);
mapkey(
  "<Ctrl-k>",
  "#3Go one tab left",
  function () {
    RUNTIME("previousTab");
  },
  { repeatIgnore: true },
);

map("gH", ":feedkeys 99E", 0, "#3Go to the first tab");
map("gL", ":feedkeys 99R", 0, "#3Go to the last tab");
map("gK", ":feedkeys 99E", 0, "#3Go to the first tab");
map("gJ", ":feedkeys 99R", 0, "#3Go to the last tab");

// map("<Ctrl-Space>R", ":feedkeys 99r", 0, "#3Reload all tabs");
mapkey('<Ctrl-Space>R', 'Reload all tabs', function() {
    RUNTIME('reloadAllTabs');
});


mapkey("q", "#3Close current tab", () => {
  RUNTIME("closeTab");
});

mapkey("<Space>bk", "#3Close tab", function () {
    RUNTIME.repeats = 1;
    RUNTIME('closeTab');
});

mapkey("<Space>fo", "#3Open recently closed", () => {
  Front.openOmnibar({ type: "RecentlyClosed" });
});

// ╭─────────────────────────────────────────────────────────╮
// │ VIEW                                                    │
// ╰─────────────────────────────────────────────────────────╯
// View page source
mapkey('<Space>vs', 'View page source', function () {
    RUNTIME('viewSource', { tab: { tabbed: true } });
});

mapkey("<Space>vi", "#1Click on an Image or a button in background, multiple", function () {
  Hints.create("img, button", (i) => {
    tabOpenLink(i.src)();
  });
});

// ╭─────────────────────────────────────────────────────────╮
// │ HISTORY                                                 │
// ╰─────────────────────────────────────────────────────────╯

map("<Ctrl-o>", "S"); // backward link history
map("<Ctrl-i>", "D"); // forward link history

mapkey("<Space>fh", "#3Open history tabs", () => {
  Front.openOmnibar({ type: "History" });
});

mapkey('<Space>fH', 'Delete history older than 30 days', function () {
    RUNTIME('deleteHistoryOlderThan', { days: 30, });
});

// ╭─────────────────────────────────────────────────────────╮
// │ BOOKMARKS                                               │
// ╰─────────────────────────────────────────────────────────╯
mapkey("<Space>fb", "#3Open bookmark", function () {
  Front.openOmnibar({ type: "Bookmarks" });
});

// ╭─────────────────────────────────────────────────────────╮
// │ ZOOM                                                    │
// ╰─────────────────────────────────────────────────────────╯
mapkey("<Ctrl-0>", "#3Zoom reset", function () {
  RUNTIME("setZoom", {
    zoomFactor: 0,
  });
});

// ╭─────────────────────────────────────────────────────────╮
// │ SEARCH                                                  │
// ╰─────────────────────────────────────────────────────────╯

mapkey('<Space>sg', 'Search in google in current tab', function () {
    Front.openOmnibar({ type: 'SearchEngine', extra: 'g', tabbed: false });
});

mapkey('<Space>sG', 'Search in google in new tab', function () {
    Front.openOmnibar({ type: 'SearchEngine', extra: 'g' });
});

mapkey('<Space>sy', 'Search in Youtube in current tab', function () {
    Front.openOmnibar({ type: 'SearchEngine', extra: 'y', tabbed: false });
});

mapkey('<Space>sY', 'Search in Youtube in new tab', function () {
    Front.openOmnibar({ type: 'SearchEngine', extra: 'y' });
});

// ╭─────────────────────────────────────────────────────────╮
// │ YANK                                                    │
// ╰─────────────────────────────────────────────────────────╯

addSearchAlias(
  "S",
  "StackOverflow",
  "https://stackoverflow.com/search?q=",
  "<Space>y",
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
  "<Space>y",
  "https://www.google.com/complete/search?client=chrome-omni&gs_ri=chrome-ext&oit=1&cp=1&pgcl=7&q=",
  function (response) {
    var res = eval(response.text);
    Omnibar.listWords(res[1]);
  },
);


addSearchAlias(
  "G",
  "GitHub",
  "https://github.com/search?q=",
  "<Space>y",
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

// ╭─────────────────────────────────────────────────────────╮
// │ MISC                                                    │
// ╰─────────────────────────────────────────────────────────╯

// Chrome specific
mapkey('<Space>od', 'Open Chrome Downloads', function () {
    tabOpenLink('chrome://downloads/');
});

mapkey('<Space>oh', 'Open Chrome History', function () {
    tabOpenLink('chrome://history/');
});

mapkey('<Space>xd', 'Close Downloads Shelf', function () {
    RUNTIME('closeDownloadsShelf', { clearHistory: true });
});

// ╭─────────────────────────────────────────────────────────╮
// │ HINT                                                    │
// ╰─────────────────────────────────────────────────────────╯
// Link Hints
Hints.style(`
    font-family: 'JetBrainsMono Nerd Font Mono', 'SF Pro', monospace;
    font-size: 18px;
    font-weight: bold;
    text-transform: lowercase;
    color: #ECEFF4 !important;        /* teks terang */
    background: #1B1E28 !important;   /* bg sangat gelap */
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
    color: #ECEFF4 !important;
    background: #232838 !important;
    border: solid 2px #81A1C1 !important;
    text-align: center;
    padding: 5px;
    line-height: 1;
  `,
  "text",
);

// set visual-mode style
Visual.style(
  "marks",
  "background-color: #A3BE8C; border: 1px solid #1B1E28 !important; text-decoration: underline; color: #1B1E28 !important;",
);
Visual.style(
  "cursor",
  "background-color: #ECEFF4 !important; border: 1px solid #81A1C1 !important; border-bottom: 2px solid #A3BE8C !important; padding: 2px !important; outline: 1px solid rgba(255,255,255,.75) !important;",
);

// ╭─────────────────────────────────────────────────────────╮
// │ THEMES                                                  │
// ╰─────────────────────────────────────────────────────────╯
settings.theme = `
  :root {
    --font: "JetBrainsMono Nerd Font Mono", Arial, sans-serif;
    --font-size: 18px;
    --font-weight: bold;

    /* Teks terang */
    --fg:        #ECEFF4;
    --fg-dim:    #D8DEE9;

    /* Background gelap */
    --bg:        #1B1E28;
    --bg-dark:   #14161E;
    --bg-alt:    #232838;

    /* Aksen */
    --border:    #3B4252;
    --border-hi: #4C566A;
    --main-fg:   #88C0D0;
    --accent-fg: #A3BE8C;
    --info-fg:   #5E81AC;
    --select:    #434C5E;
    --orange:    #D08770;
    --red:       #BF616A;
    --yellow:    #EBCB8B;
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
    background-color: #88C0D0;
    color: #14161E;
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
    background: var(--bg-alt);
    border: 1px solid var(--border-hi);
  }
  #sk_tabs .sk_tab_title {
    color: var(--fg);
  }
  #sk_tabs .sk_tab_url {
    color: var(--main-fg);
  }
  #sk_tabs .sk_tab_hint {
    background: var(--bg);
    border: 1px solid var(--border-hi);
    color: var(--accent-fg);
  }
  .sk_theme #sk_frame {
    background: var(--bg);
    opacity: 0.2;
    color: var(--accent-fg);
  }

  /* ---------- Omnibar ---------- */
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
    background: var(--bg-alt);
    padding: 5px;
  }
  .sk_theme #sk_omnibarSearchResult ul li:nth-child(even) {
    background: var(--bg-alt);
    padding: 5px;
  }
  .sk_theme #sk_omnibarSearchResult ul li.focused {
    background: var(--bg-dark);
    border-left: 2px solid var(--orange);
    padding: 5px;
    padding-left: 15px;
  }
  .sk_theme #sk_omnibarSearchArea {
    border-top-color: var(--border-hi);
    border-bottom-color: transparent;
    margin: 0;
    padding: 5px 10px;
    background: var(--bg);
  }
  .sk_theme #sk_omnibarSearchArea:before {
    content: "󱋤";
    display: inline-block;
    margin-left: 5px;
    font-size: 22px;
    color: var(--main-fg);
  }
  .sk_theme #sk_omnibarSearchArea input,
  .sk_theme #sk_omnibarSearchArea span {
    font-size: 20px;
    padding: 10px 0;
    color: var(--fg);
  }
  .sk_theme #sk_omnibarSearchArea .prompt {
    text-transform: uppercase;
    padding-left: 10px;
    color: var(--fg-dim);
  }
  .sk_theme #sk_omnibarSearchArea .prompt:after {
    content: "";
    display: inline-block;
    margin-right: 5px;
    color: var(--accent-fg);
  }
  .sk_theme #sk_omnibarSearchArea .separator {
    color: var(--bg);
    display: none;
  }
  .sk_theme #sk_omnibarSearchArea .separator:after {
    content: "";
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
    border-color: var(--border-hi);
    color: var(--fg);
    opacity: 0.95;
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
    border-color: var(--border-hi) !important;
  }
  #sk_bubble * {
    color: var(--fg) !important;
  }
  #sk_bubble div.sk_arrow div:nth-of-type(1) {
    border-top-color: var(--border-hi) !important;
    border-bottom-color: var(--border-hi) !important;
  }
  #sk_bubble div.sk_arrow div:nth-of-type(2) {
    border-top-color: var(--bg) !important;
    border-bottom-color: var(--bg) !important;
  }

  /* ---------- Search ---------- */
  #sk_status,
  #sk_find {
    font-size: var(--font-size);
    border-color: var(--border-hi);
    background: var(--bg);
    color: var(--fg);
  }
  .sk_theme kbd {
    background: var(--bg-dark);
    border-color: var(--border-hi);
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
  }
  .ace_dialog-bottom {
    border-top: 1px solid var(--bg) !important;
  }
  .ace-chrome .ace_print-margin,
  .ace_gutter,
  .ace_gutter-cell,
  .ace_dialog {
    background: var(--bg-alt) !important;
  }
  .ace-chrome {
    color: var(--fg) !important;
    background: var(--bg-dark) !important;
  }
  .ace_gutter,
  .ace_dialog {
    color: var(--fg-dim) !important;
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
    color: var(--fg);
  }

  /* Disable RichHints CSS animation */
  .expandRichHints {
    animation: 0s ease-in-out 1 forwards expandRichHints;
  }
  .collapseRichHints {
    animation: 0s ease-in-out 1 forwards collapseRichHints;
  }
`;
