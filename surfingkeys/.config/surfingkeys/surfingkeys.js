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
  iunmap,
  addSearchAlias,
  map,
  imap,
  cmap,
  mapkey,
  tabOpenLink,
  unmap,
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

// mapkey("gg", "Jump to the top of the page", function () {
//   window.scrollTo(0, window.pageYOffset - 1000000000);
// });
// mapkey("G", "Jump to the bottom of the page", function () {
//   window.scrollTo(0, window.pageYOffset + 1000000000);
// });

mapkey("k", "#2Scroll up of line", () => {
  scrollBySmooth(window.innerHeight / 10, -2);
});
mapkey("j", "#2Scroll down of line", () => {
  scrollBySmooth(window.innerHeight / 10, 2);
});

mapkey("K", "#2Scroll up of line", () => {
  scrollBySmooth(window.innerHeight / 10, -3);
});
// NOTE: conflict dengan mapping fast forward di youtube video
// mapkey("J", "#2Scroll down of line", () => {
//   scrollBySmooth(window.innerHeight / 10, 3);
// });

mapkey("<Ctrl-f>", "#2Scroll down of page", () => {
  scrollBySmooth(window.innerHeight * 10, 3);
});
mapkey("<Ctrl-b>", "#2Scroll up of page", () => {
  scrollBySmooth(window.innerHeight * 10, -3);
});

// ╭─────────────────────────────────────────────────────────╮
// │ EDITING                                                 │
// ╰─────────────────────────────────────────────────────────╯

unmap("/"); // should do the trick, using it myself.
// unmap("<ctrl-f>"); // should do the trick, using it myself.
// WARN: niatnya ingin run search, tapi ini salah
// mapkey("<Ctrl-g>", "Search", function () {
//   RUNTIME("openFinder");
// });

map("<Ctrl-g>", "/");
// mapkey("n", "Next search result", function () {
//   Visual.next(false);
// });
// mapkey("N", "Previous search result", function () {
//   Visual.next(true);
// });

// ╭─────────────────────────────────────────────────────────╮
// │ OPEN LINKS                                              │
// ╰─────────────────────────────────────────────────────────╯

// map("mf", "cf");
map("F", "gf");

// Edit current link
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

mapkey("ys", "#8Open link in split view", function () {
  Hints.create("*[href]", (element) => {
    const event = new MouseEvent("click", {
      bubbles: true,
      cancelable: true,
      view: window,
      button: 2, // 2 represents the right mouse button
    });
    element.dispatchEvent(event);
  });
});

mapkey("yd", "#8Debug hint", function () {
  Hints.create("*[href]", function (element) {
    RUNTIME("openLink", {
      url: element.href,
      tab: { tabbed: true, split: true },
    });
    console.log("Mencoba membuka:", element.href);
  });
});

mapkey("yk", "#8Open link in split view", function () {
  Hints.create("*[href]", function (element) {
    window.postMessage(
      {
        type: "cmd_zenSplitViewLinkInNewTab",
        url: element.href,
      },
      "*",
    );
  });
});

// mapkey("s", "Search in google in current tab", function () {
//   Front.openOmnibar({ type: "SearchEngine", extra: "g", tabbed: false });
// });
// mapkey("S", "Search in google in new tab", function () {
//   Front.openOmnibar({ type: "SearchEngine", extra: "g" });
// });

// TEST ============================================================
// Forcing keymap H to remap arrowLeft?
// map("H", "<ArrowLeft>");

// Attempted to exit with hh -> <esc>, but it failed."
// imap("hh", "<Esc>");
//
// mapkey(";dv", "#1Download video", function () {
//   Hints.create("video", function (element) {
//     var src = element.src || element.querySelector(`source[src$="mp4"]`).src;
//     RUNTIME("download", {
//       url: src,
//     });
//   });
// });

// END TEST ========================================================

// ╭─────────────────────────────────────────────────────────╮
// │ OMNIBAR                                                 │
// ╰─────────────────────────────────────────────────────────╯

// The default is using <Tab> but in nvim I use `<c-j/k>` for item selection
// with these remappings, I can use them now
cmap("<Ctrl-j>", "<Tab>");
cmap("<Ctrl-k>", "<Shift-Tab>");

// ╭─────────────────────────────────────────────────────────╮
// │ TAB                                                     │
// ╰─────────────────────────────────────────────────────────╯

// Move TAB to the left/right
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
mapkey("<Alt-b>", "#3Close alternate the tabs or go to last tab", function () {
  RUNTIME("goToLastTab");
});
mapkey("M", "Mute/unmute current tab", function () {
  RUNTIME("muteTab");
});

map("<Space>ff", "T");

map("<Ctrl-l>", "R");
map("<Ctrl-h>", "E");

map("<Ctrl-j>", "R");
map("<Ctrl-k>", "E");

// Side tabbar zen-browser is left side sometimes make confuse
// map("<Ctrl-Alt-j>", "R");
// map("<Ctrl-Alt-k>", "E");

mapkey("<Ctrl-o>", "backward", function () {
  history.go(-1);
});
mapkey("<Ctrl-i>", "forward", function () {
  history.go(1);
});

// reopen closed tab
map("-", "X");

// close tab
mapkey("q", "#3Close current tab", () => {
  RUNTIME("closeTab");
});
mapkey("<Space><Tab>", "#3Close current tab", () => {
  RUNTIME("closeTab");
});

// ╭─────────────────────────────────────────────────────────╮
// │ HISTORY                                                 │
// ╰─────────────────────────────────────────────────────────╯

// open current history tab
mapkey("<Space>fo", "#8Open RecentlyClosed", () => {
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

// Search engines (see https://github.com/b0o/surfingkeys-conf to add extra
// completions)
// mapkey('s', 'Search in google in current tab', function () {
//     Front.openOmnibar({ type: 'SearchEngine', extra: 'g', tabbed: false });
// });
//
// mapkey('S', 'Search in google in new tab', function () {
//     Front.openOmnibar({ type: 'SearchEngine', extra: 'g' });

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

// Alias for search on google
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
// │ THEMES                                                  │
// ╰─────────────────────────────────────────────────────────╯

Hints.style(
  "border: solid 1px #3D3E3E; color:#F92660; background: initial; background-color: #272822; font-family: Maple Mono Freeze; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.8);",
);
Hints.style(
  "border: solid 1px #3D3E3E !important; padding: 1px !important; color: #A6E22E !important; background: #272822 !important; font-family: Maple Mono Freeze !important; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.8) !important;",
  "text",
);
Visual.style("marks", "background-color: #A6E22E99;");
Visual.style("cursor", "background-color: #F92660;");

/* set theme */
settings.theme = `
.sk_theme {
    font-family: Maple Mono Freeze,Input Sans Condensed, Charcoal, sans-serif;
    font-size: 14px;
    background: #282828;
    color: #ebdbb2;
}
.sk_theme tbody {
    color: #b8bb26;
}
.sk_theme input {
    color: #d9dce0;
}
.sk_theme .url {
    color: #38971a;
}
.sk_theme .annotation {
    color: #b16286;
}

#sk_omnibar {
    width: 60%;
    left:20%;
    box-shadow: 0px 30px 50px rgba(0, 0, 0, 0.8);
}

.sk_omnibar_middle {
	top: 15%;
	border-radius: 10px;
}


.sk_theme .omnibar_highlight {
    color: #ebdbb2;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #282828;
}

.sk_theme #sk_omnibarSearchResult {
    max-height: 60vh;
    overflow: hidden;
    margin: 0rem 0rem;
}



#sk_omnibarSearchResult > ul {
	padding: 1.0em;
}

.sk_theme #sk_omnibarSearchResult ul li {
    margin-block: 0.5rem;
    padding-left: 0.4rem;
}

.sk_theme #sk_omnibarSearchResult ul li.focused {
	background: #181818;
	border-color: #181818;
	border-radius: 12px;
	position: relative;
	box-shadow: 1px 3px 5px rgba(0, 0, 0, 0.8);
}


#sk_omnibarSearchArea > input {
	display: inline-block;
	width: 100%;
	flex: 1;
	font-size: 20px;
	margin-bottom: 0;
	padding: 0px 0px 0px 0.5rem;
	background: transparent;
	border-style: none;
	outline: none;
	padding-left: 18px;
}


#sk_tabs {
	position: fixed;
	top: 0;
	left: 0;
    background-color: rgba(0, 0, 0, 0);
	overflow: auto;
	z-index: 2147483000;
    box-shadow: 0px 30px 50px rgba(0, 0, 0, 0.8);
	margin-left: 1rem;
	margin-top: 1.5rem;
    border: solid 1px #282828;
    border-radius: 15px;
    background-color: #282828;
    padding-top: 10px;
    padding-bottom: 10px;

}

#sk_tabs div.sk_tab {
	vertical-align: bottom;
	justify-items: center;
	border-radius: 0px;
    background: #282828;
    //background: #181818 !important;

	margin: 0px;
	box-shadow: 0px 0px 0px 0px rgba(245, 245, 0, 0.3);
	box-shadow: 0px 0px 0px 0px rgba(0, 0, 0, 0.8) !important;

	/* padding-top: 2px; */
	border-top: solid 0px black;
	margin-block: 0rem;
}


#sk_tabs div.sk_tab:not(:has(.sk_tab_hint)) {
	background-color: #181818 !important;
	box-shadow: 1px 3px 5px rgba(0, 0, 0, 0.8) !important;
	border: 1px solid #181818;
	border-radius: 20px;
	position: relative;
	z-index: 1;
	margin-left: 1.8rem;
	padding-left: 0rem;
	margin-right: 0.7rem;
}


#sk_tabs div.sk_tab_title {
	display: inline-block;
	vertical-align: middle;
	font-size: 10pt;
	white-space: nowrap;
	text-overflow: ellipsis;
	overflow: hidden;
	padding-left: 5px;
	color: #ebdbb2;
}



#sk_tabs.vertical div.sk_tab_hint {
    position: inherit;
    left: 8pt;
    margin-top: 3px;
    border: solid 1px #3D3E3E; color:#F92660; background: initial; background-color: #272822; font-family: Maple Mono Freeze;
    box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.8);
}

#sk_tabs.vertical div.sk_tab_wrap {
	display: inline-block;
	margin-left: 0pt;
	margin-top: 0px;
	padding-left: 15px;
}

#sk_tabs.vertical div.sk_tab_title {
	min-width: 100pt;
	max-width: 20vw;
}

#sk_usage, #sk_popup, #sk_editor {
	overflow: auto;
	position: fixed;
	width: 80%;
	max-height: 80%;
	top: 10%;
	left: 10%;
	text-align: left;
	box-shadow: 0px 30px 50px rgba(0, 0, 0, 0.8);
	z-index: 2147483298;
	padding: 1rem;
	border: 1px solid #282828;
	border-radius: 10px;
}

#sk_keystroke {
	padding: 6px;
	position: fixed;
	float: right;
	bottom: 0px;
	z-index: 2147483000;
	right: 0px;
	background: #282828;
	color: #fff;
	border: 1px solid #181818;
	border-radius: 10px;
	margin-bottom: 1rem;
	margin-right: 1rem;
	box-shadow: 0px 30px 50px rgba(0, 0, 0, 0.8);
}

#sk_status {
	position: fixed;
	/* top: 0; */
	bottom: 0;
	right: 39%;
	z-index: 2147483000;
	padding: 8px 8px 4px 8px;
	border-radius: 5px;
	border: 1px solid #282828;
	font-size: 14px;
	box-shadow: 0px 20px 40px 2px rgba(0, 0, 0, 1);
	/* margin-bottom: 1rem; */
	width: 20%;
	margin-bottom: 1rem;
}


#sk_omnibarSearchArea {
    border-bottom: 0px solid #282828;
}


#sk_omnibarSearchArea .resultPage {
	display: inline-block;
    font-size: 14pt;
    font-style: italic;
	width: auto;
}

#sk_omnibarSearchResult li div.url {
	font-weight: normal;
	white-space: nowrap;
	color: #aaa;
}

.sk_theme .omnibar_highlight {
	color: #11eb11;
	font-weight: bold;
}

.sk_theme .omnibar_folder {
	border: 1px solid #188888;
	border-radius: 5px;
	background: #188888;
	color: #aaa;
	box-shadow: 1px 1px 5px rgba(0, 8, 8, 1);
}
.sk_theme .omnibar_timestamp {
	background: #cc4b9c;
	border: 1px solid #cc4b9c;
	border-radius: 5px;
	color: #aaa;
	box-shadow: 1px 1px 5px rgb(0, 8, 8);
}
#sk_omnibarSearchResult li div.title {
	text-align: left;
	max-width: 100%;
	white-space: nowrap;
	overflow: auto;
}

.sk_theme .separator {
	color: #282828;
}

.sk_theme .prompt{
	color: #aaa;
	background-color: #181818;
	border-radius: 10px;
	padding-left: 22px;
	padding-right: 21px;
	/* padding: ; */
	font-weight: bold;
	box-shadow: 1px 3px 5px rgba(0, 0, 0, 0.8);
}



#sk_status, #sk_find {
	font-size: 14px;
	font-weight: bold;
    text-align: center;
    padding-right: 8px;
}


#sk_status span[style*="border-right: 1px solid rgb(153, 153, 153);"] {
    display: none;
}

`;
