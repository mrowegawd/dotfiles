Object.assign(settings, {
  smoothScroll: false,
  createHintAlign: "left",
  focusFirstCandidate: true,
  caseSensitive: false
});

Object.assign(Hints, {
  // Only left hand keys
  characters: "asdfgqwertcvb"
});

/* eslint-disable no-unused-vars */
const HELP = 0;
const MOUSE_CLICK = 1;
const SCROLL_PAGE = 2;
const TABS = 3;
const PAGE = 4;
const SESSIONS = 5;
const SEARCH = 6;
const CLIPBOARD = 7;
const OMNIBAR = 8;
const VISUAL = 9;
const VIM = 10;
const SETTINGS = 11;
const CHROME = 12;
const PROXY = 13;
const MISC = 14;
const INSERT = 15;
/* eslint-enable no-unused-vars */

function keymap(group, fn) {
  const bind = mapkeyFn => (keys, annotation, cb, options) => {
    [].concat(keys).forEach(key => {
      mapkeyFn(key, `#${group}${annotation}`, cb, options);
    });
  };

  const helpers = {
    normal: bind(mapkey),
    visual: bind(vmapkey),
    insert: bind(imapkey)
  };

  return fn(helpers);
}

function swap(key1, key2) {
  // Using underscore as a temporary variable to swap key bindings
  map("_", key1);
  map(key1, key2);
  map(key2, "_");
  unmap("_");
}

function remap(newKey, oldKey) {
  map(newKey, oldKey);
  unmap(oldKey);
}

// Bindings that I don't need
unmap("sp"); // namespace for Proxy bindings
unmap("cp"); // toggle proxy for current site
unmap("sfr"); // show failed web requests of current page
unmap("se"); // edit settings
unmap("sm"); // preview markdown
unmap("<Ctrl-Alt-d>"); // settings
unmap("Z"); // namespace for Session bindings
unmap("sql"); // show last action
iunmap(":"); // emoji completion

keymap(HELP, ({ insert }) => {
  map(",", "<Alt-i>");
  unmap("<Alt-i>");

  map("<Ctrl-q>", "<Alt-s>");
  insert("<Ctrl-q>", "Toggle SurfingKeys on current site", () =>
    Normal.toggleBlacklist()
  );
  unmap("<Alt-s>");
});

keymap(MOUSE_CLICK, () => {
  unmap("af");

  // Open multiple links in a new tab
  remap("F", "cf");
  // Mouse out last element
  remap("gm", ";m");
  // Mouse over elements
  remap("gh", "<Ctrl-h>");
  // Mouse out elements
  remap("gH", "<Ctrl-j>");

  remap("gq", "cq");

  // FIXME "Go to the first edit box" doesn't work well on some sites
  swap("i", "gi");
});

keymap(SCROLL_PAGE, () => {
  // Scroll page up/down
  map("<Ctrl-y>", "e");
  map("<Ctrl-e>", "d");

  // Change scroll target
  remap("gs", "cs");

  // Reset scroll target
  remap("gS", "cS");
});

keymap(TABS, () => {
  // Go one tab left
  map("<Ctrl-h>", "E");
  // Go one tab right
  map("<Ctrl-l>", "R");

  unmap("E");

  // Go to last used tab
  remap("`", "<Ctrl-6>");

  // pin/unpin current tab
  remap("gp", "<Alt-p>");

  // mute/unmute current tab
  remap("gm", "<Alt-m>");

  // Move current tab to left
  map("H", "<<");
  // Move current tab to right
  map("L", ">>");

  // Choose a tab
  map("t", "T");

  // Restore closed tab
  map("T", "X");

  map("<Space>fl", "/");
});

keymap(PAGE, ({ normal }) => {
  normal("R", "Reload the page without cache", () =>
    RUNTIME("reloadTab", { nocache: true })
  );

  map("gl", "sU");
  remap("gL", "su");
  unmap("sU");
});

keymap(OMNIBAR, ({ normal }) => {
  unmap("o");

  openOmnibarCombo("a", "Open a URL", {
    type: "URLs",
    extra: "getAllSites",
    noPrefix: true
  });
  openOmnibarCombo("x", "Open recently closed URL", {
    type: "URLs",
    extra: "getRecentlyClosed",
    noPrefix: true
  });
  openOmnibarCombo("u", "Open URL from tab history", {
    type: "URLs",
    extra: "getTabURLs",
    noPrefix: true
  });
  openOmnibar(";", "Open commands", { type: "Commands" });

  const keyPrefix = "o";

  normal(`${keyPrefix}t`, "Choose a tab with omnibar", () => {
    Front.openOmnibar({ type: "Tabs" });
  });

  openOmnibarCombo("a", "Open a URL", { type: "URLs", extra: "getAllSites" });
  openOmnibarCombo("x", "Open recently closed URL", {
    type: "URLs",
    extra: "getRecentlyClosed"
  });
  openOmnibarCombo("u", "Open URL from tab history", {
    type: "URLs",
    extra: "getTabURLs"
  });
  openOmnibarCombo("b", "Open a bookmark", { type: "Bookmarks" });
  openOmnibarCombo("m", "Open URL from vim-like marks", { type: "VIMarks" });
  openOmnibarCombo("y", "Open URL from history", { type: "History" });
  normal(`${keyPrefix}i`, "Open incognito window", () => {
    runtime.command({ action: "openIncognito", url: window.location.href });
  });

  // Helpers

  function openOmnibar(key, annotation, options) {
    normal(key, annotation, () => {
      Front.openOmnibar(options);
    });
  }

  function openOmnibarCombo(key, annotation, options) {
    const { noPrefix, ...opts } = options;
    const prefix = noPrefix ? "" : keyPrefix;

    openOmnibar(`${prefix}${key}`, annotation, { ...opts, tabbed: false });
    openOmnibar(
      `${prefix}${key.toUpperCase()}`,
      `${annotation} in new tab`,
      opts
    );
  }
});

// Theme

const monospaceFontFamily =
  "FiraMono Nerd Font, Lucida Console, Courier, monospace";
const fontFamily = "system-ui, Helvetica, Verdana, Arial, sans-serif";

// Colors
const white = "#ff0000";
const lightGray = "#a7aba9";
const gray = "#696b6a";
const darkGray = "#454746";
const black = "#282c2f";
const lightBlack = "#3c4043";
const aquamarine = "#24ddb2";
const yellow = "#fece48";
const lightYellow = "#fcdc7c";
const green = "#A6F772";
const lightGreen = "#C6F9A5";
const darkGreen = "#6A9E49";

Hints.style(`
  font-family: ${monospaceFontFamily};
`);

Hints.style(
  `
  font-family: ${fontFamily};
  border-color: ${darkGreen};
  background: linear-gradient(0deg, ${green}, ${lightGreen});
`,
  "text"
);

settings.theme = `
#sk_omnibarSearchArea .prompt, #sk_omnibarSearchArea .resultPage {
    font-size: 10px;
}
.sk_theme {
    background: #282a36;
    color: #f8f8f2;
}
.sk_theme tbody {
    color: #ff5555;
}
.sk_theme input {
    color: #ffb86c;
}
.sk_theme .url {
    color: #6272a4;
}
#sk_omnibarSearchResult>ul>li {
    background: #282a36;
}
#sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #282a36;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #282a36;
}
.sk_theme .annotation {
    color: #6272a4;
}
.sk_theme .focused {
    background: #44475a !important;
}
.sk_theme kbd {
    background: #f8f8f2;
    color: #44475a;
}
.sk_theme .frame {
    background: #8178DE9E;
}
.sk_theme .omnibar_highlight {
    color: #8be9fd;
}
.sk_theme .omnibar_folder {
    color: #ff79c6;
}
.sk_theme .omnibar_timestamp {
    color: #bd93f9;
}
.sk_theme .omnibar_visitcount {
    color: #f1fa8c;
}

.sk_theme .prompt, .sk_theme .resultPage {
    color: #50fa7b;
}
.sk_theme .feature_name {
    color: #ff5555;
}
.sk_omnibar_middle #sk_omnibarSearchArea {
    border-bottom: 1px solid #282a36;
}
#sk_status {
    border: 1px solid #282a36;
}
#sk_richKeystroke {
    background: #282a36;
    box-shadow: 0px 2px 10px rgba(40, 42, 54, 0.8);
}
#sk_richKeystroke kbd>.candidates {
    color: #ff5555;
}
#sk_keystroke {
    background-color: #282a36;
    color: #f8f8f2;
}
kbd {
    border: solid 1px #f8f8f2;
    border-bottom-color: #f8f8f2;
    box-shadow: inset 0 -1px 0 #f8f8f2;
}
#sk_frame {
    border: 4px solid #ff5555;
    background: #8178DE9E;
    box-shadow: 0px 0px 10px #DA3C0DCC;
}
#sk_banner {
    border: 1px solid #282a36;
    background: rgb(68, 71, 90);
}
div.sk_tabs_bg {
    background: #f8f8f2;
}
div.sk_tab {
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#6272a4), color-stop(100%,#44475a));
}
div.sk_tab_title {
    color: #f8f8f2;
}
div.sk_tab_url {
    color: #8be9fd;
}
div.sk_tab_hint {
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#f1fa8c), color-stop(100%,#ffb86c));
    color: #282a36;
    border: solid 1px #282a36;
}
#sk_bubble {
    border: 1px solid #f8f8f2;
    color: #282a36;
    background-color: #f8f8f2;
}
#sk_bubble * {
    color: #282a36 !important;
}
div.sk_arrow[dir=down]>div:nth-of-type(1) {
    border-top: 12px solid #f8f8f2;
}
div.sk_arrow[dir=up]>div:nth-of-type(1) {
    border-bottom: 12px solid #f8f8f2;
}
div.sk_arrow[dir=down]>div:nth-of-type(2) {
    border-top: 10px solid #f8f8f2;
}
div.sk_arrow[dir=up]>div:nth-of-type(2) {
    border-bottom: 10px solid #f8f8f2;
}
#sk_omnibar {
    width: 100%;
    left: 0%;
}`;
