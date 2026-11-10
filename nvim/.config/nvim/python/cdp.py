"""Minimal Chrome DevTools Protocol client. Tanpa Playwright."""

import json
import threading
import time
from typing import Any
from urllib.parse import urljoin

import requests

try:
    import websocket

    if not hasattr(websocket, "create_connection"):
        raise ImportError(
            "Package 'websocket' yang ke-import bukan 'websocket-client'. "
            "Fix: pip uninstall -y websocket && pip install websocket-client"
        )
except ImportError as e:
    raise ImportError(f"websocket-client tidak tersedia: {e}")


class CDPError(Exception):
    pass


class CDPTab:
    def __init__(self, ws_url: str, debug_host: str):
        self.ws_url = ws_url
        self.debug_host = debug_host
        self.ws = websocket.create_connection(ws_url, timeout=120)
        self._id = 0
        self._lock = threading.Lock()

    def close(self):
        try:
            self.ws.close()
        except Exception:
            pass

    def wait_for(self, selector: str, timeout: int = 20, poll: float = 0.3) -> bool:
        """Tunggu sampai selector ada di DOM."""
        deadline = time.time() + timeout
        while time.time() < deadline:
            if self.exists(selector):
                return True
            time.sleep(poll)
        return False

    def _send(self, method: str, params: dict | None = None) -> dict:
        with self._lock:
            self._id += 1
            msg_id = self._id
            self.ws.send(
                json.dumps({"id": msg_id, "method": method, "params": params or {}})
            )
            deadline = time.time() + 120
            while time.time() < deadline:
                raw = self.ws.recv()
                if not raw:
                    continue
                data = json.loads(raw)
                if data.get("id") == msg_id:
                    if "error" in data:
                        raise CDPError(f"{method}: {data['error']}")
                    return data.get("result", {})
            raise CDPError(f"timeout menunggu response {method}")

    def navigate(self, url: str, wait_load: bool = True):
        self._send("Page.enable")
        self._send("Page.navigate", {"url": url})
        if wait_load:
            try:
                self._wait_event("Page.loadEventFired", timeout=30)
            except CDPError:
                pass
        time.sleep(0.5)

    def _wait_event(self, event_name: str, timeout: int = 30):
        deadline = time.time() + timeout
        while time.time() < deadline:
            raw = self.ws.recv()
            if not raw:
                continue
            data = json.loads(raw)
            if data.get("method") == event_name:
                return data.get("params", {})
        raise CDPError(f"timeout menunggu event {event_name}")

    def eval(self, expression: str, await_promise: bool = False) -> Any:
        result = self._send(
            "Runtime.evaluate",
            {
                "expression": expression,
                "awaitPromise": await_promise,
                "returnByValue": True,
            },
        )
        if result.get("exceptionDetails"):
            raise CDPError(f"JS error: {result['exceptionDetails']}")
        return result.get("result", {}).get("value")

    def focus(self, selector: str) -> bool:
        js = f"""
        (function() {{
          const el = document.querySelector({json.dumps(selector)});
          if (!el) return false;
          el.focus();
          return true;
        }})()
        """
        return bool(self.eval(js))

    def type_text(self, text: str):
        self._send("Input.insertText", {"text": text})

    def press_key(self, key: str):
        keymap = {
            "Enter": ("Enter", 13, "\r"),
            "Backspace": ("Backspace", 8, ""),
            "Tab": ("Tab", 9, ""),
            "Escape": ("Escape", 27, ""),
        }
        k, code, text = keymap.get(key, (key, 0, ""))
        base = {
            "key": k,
            "code": k,
            "windowsVirtualKeyCode": code,
            "nativeVirtualKeyCode": code,
        }
        self._send("Input.dispatchKeyEvent", {**base, "type": "keyDown", "text": text})
        self._send("Input.dispatchKeyEvent", {**base, "type": "keyUp"})

    def click(self, selector: str) -> bool:
        js = f"""
        (function() {{
          const el = document.querySelector({json.dumps(selector)});
          if (!el) return false;
          el.click();
          return true;
        }})()
        """
        return bool(self.eval(js))

    def exists(self, selector: str) -> bool:
        return bool(self.eval(f"!!document.querySelector({json.dumps(selector)})"))

    def text(self, selector: str) -> str:
        js = f"""
        (function() {{
          const els = document.querySelectorAll({json.dumps(selector)});
          if (els.length === 0) return "";
          const el = els[els.length - 1];
          const t = el.innerText;
          if (t && t.trim()) return t;
          return el.textContent || "";
        }})()
        """
        return self.eval(js) or ""

    def html_to_markdown(self, selector: str) -> str:
        """Ambil elemen terakhir yang match selector, konversi HTML -> markdown."""
        js = r"""
        (function() {
          const els = document.querySelectorAll(SEL);
          if (els.length === 0) return "";
          const root = els[els.length - 1];

          function walk(node) {
            if (node.nodeType === Node.TEXT_NODE) {
              return node.textContent.replace(/\u00a0/g, ' ');
            }
            if (node.nodeType !== Node.ELEMENT_NODE) return '';
            const tag = node.tagName.toLowerCase();
            const children = () => Array.from(node.childNodes).map(c => walk(c)).join('');

            switch (tag) {
              case 'br': return '\n';
              case 'p': return children().trim() + '\n\n';
              case 'strong': case 'b': return '**' + children() + '**';
              case 'em': case 'i': return '*' + children() + '*';
              case 'del': case 's': return '~~' + children() + '~~';
              case 'h1': return '# ' + children().trim() + '\n\n';
              case 'h2': return '## ' + children().trim() + '\n\n';
              case 'h3': return '### ' + children().trim() + '\n\n';
              case 'h4': return '#### ' + children().trim() + '\n\n';
              case 'h5': return '##### ' + children().trim() + '\n\n';
              case 'h6': return '###### ' + children().trim() + '\n\n';
              case 'ul':
                return Array.from(node.children).map(li => {
                  const t = walk(li).trim().replace(/\n/g, '\n  ');
                  return '- ' + t;
                }).join('\n') + '\n\n';
              case 'ol':
                return Array.from(node.children).map((li, i) => {
                  const t = walk(li).trim().replace(/\n/g, '\n   ');
                  return (i + 1) + '. ' + t;
                }).join('\n') + '\n\n';
              case 'li': return children();
              case 'code': {
                const isBlock = node.parentElement && node.parentElement.tagName.toLowerCase() === 'pre';
                if (isBlock) return children();
                return '`' + children() + '`';
              }
              case 'pre': {
                const code = node.querySelector('code');
                const cls = code ? (code.className || '') : '';
                const m = cls.match(/language-([\w-]+)/);
                const lang = m ? m[1] : '';
                const raw = (code ? code.textContent : node.textContent) || '';
                return '\n```' + lang + '\n' + raw.replace(/\n$/, '') + '\n```\n\n';
              }
              case 'blockquote':
                return children().trim().split('\n').map(l => '> ' + l).join('\n') + '\n\n';
              case 'a': {
                const href = node.getAttribute('href') || '';
                const text = children();
                return text ? '[' + text + '](' + href + ')' : href;
              }
              case 'img': {
                const src = node.getAttribute('src') || '';
                const alt = node.getAttribute('alt') || '';
                if (src.startsWith('blob:') || src.startsWith('data:')) {
                  const a = node.closest('a');
                  const realSrc = a && a.href ? a.href : src;
                  return '![' + alt + '](' + realSrc + ')';
                }
                return '![' + alt + '](' + src + ')';
              }
              case 'table': {
                const rows = Array.from(node.querySelectorAll('tr'));
                if (rows.length === 0) return children();
                const cellsOf = (tr) => Array.from(tr.children).map(td =>
                  Array.from(td.childNodes).map(c => walk(c)).join('').trim().replace(/\|/g, '\\|')
                );
                const header = cellsOf(rows[0]);
                const sep = header.map(() => '---');
                const body = rows.slice(1).map(cellsOf);
                const toLine = (arr) => '| ' + arr.join(' | ') + ' |';
                return [toLine(header), toLine(sep), ...body.map(toLine)].join('\n') + '\n\n';
              }
              case 'hr': return '\n---\n\n';
              case 'div': case 'section': case 'article': case 'span': case 'figure':
              case 'figcaption': case 'header': case 'footer': case 'main':
                return children();
              default:
                return children();
            }
          }

          let md = walk(root);
          md = md.replace(/\n{3,}/g, '\n\n').trim();
          return md;
        })()
        """.replace("SEL", json.dumps(selector))

        return self.eval(js) or ""


class CDPManager:
    def __init__(self, host: str = "127.0.0.1", port: int = 9222):
        self.host = host
        self.port = port
        self.base = f"http://{host}:{port}"

    def is_alive(self) -> bool:
        try:
            r = requests.get(urljoin(self.base, "/json/version"), timeout=2)
            return r.ok
        except Exception:
            return False

    def list_tabs(self) -> list[dict]:
        r = requests.get(urljoin(self.base, "/json"), timeout=3)
        r.raise_for_status()
        return [t for t in r.json() if t.get("type") == "page"]

    def find_or_open(self, url_prefix: str, fallback_url: str) -> CDPTab:
        for t in self.list_tabs():
            if t.get("url", "").startswith(url_prefix):
                return CDPTab(t["webSocketDebuggerUrl"], self.base)
        # buka tab baru
        r = requests.put(
            urljoin(
                self.base, f"/json/new?{requests.utils.quote(fallback_url, safe='')}"
            ),
            timeout=5,
        )
        if not r.ok:
            r = requests.get(
                urljoin(
                    self.base,
                    f"/json/new?{requests.utils.quote(fallback_url, safe='')}",
                ),
                timeout=5,
            )
        r.raise_for_status()
        info = r.json()
        return CDPTab(info["webSocketDebuggerUrl"], self.base)

    def activate(self, tab: CDPTab):
        try:
            for t in self.list_tabs():
                if t["webSocketDebuggerUrl"] == tab.ws_url:
                    requests.get(
                        urljoin(self.base, f"/json/activate/{t['id']}"), timeout=3
                    )
                    return
        except Exception:
            pass
