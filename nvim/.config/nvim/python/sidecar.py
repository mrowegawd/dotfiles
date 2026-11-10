"""
WritingSidecar for nvim-web-ai.
No Playwright needed—just connect to a regular Chrome instance via CDP.

Supports:

- POST /v1/chat/completions  (Chat Completions & Responses payloads)
- POST /v1/responses         (Responses payloads)

Responses are extracted as Markdown using `html_to_markdown` instead of
`innerText`, keeping code blocks, tables, lists, and images intact.
"""

import asyncio
import json as jsonlib
import logging
import os
import time
import uuid
from contextlib import asynccontextmanager

from cdp import CDPError, CDPManager, CDPTab
from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, model_validator
from select_profiles import get_profile

# -------- Config --------
HOST = os.getenv("WEB_AI_HOST", "127.0.0.1")
PORT = int(os.getenv("WEB_AI_PORT", "8787"))
CDP_HOST = os.getenv("WEB_AI_CDP_HOST", "127.0.0.1")
CDP_PORT = int(os.getenv("WEB_AI_CDP_PORT", "9222"))
PROFILE = get_profile()
NEW_CHAT_PER_REQUEST = os.getenv("WEB_AI_NEW_CHAT", "true").lower() == "true"
DEBUG_DUMP = os.getenv("WEB_AI_DEBUG_DUMP", "/tmp/web-ai-last.md")

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("web-ai")


# -------- State --------
class State:
    manager: CDPManager | None = None
    tab: CDPTab | None = None
    lock: asyncio.Lock = asyncio.Lock()


state = State()


def get_manager() -> CDPManager:
    if state.manager is None:
        state.manager = CDPManager(CDP_HOST, CDP_PORT)
    return state.manager


def ensure_tab() -> CDPTab:
    mgr = get_manager()
    if not mgr.is_alive():
        raise RuntimeError(
            f"Chrome tidak berjalan di {CDP_HOST}:{CDP_PORT}. Jalankan python/launch-browser.sh"
        )
    if state.tab is None:
        try:
            state.tab = mgr.find_or_open(PROFILE["url_prefix"], PROFILE["url"])
        except Exception as e:
            raise RuntimeError(f"Gagal buka tab CDP: {e}")
        mgr.activate(state.tab)
    return state.tab


# ================================================================
# Scraping
# ================================================================
def submit_and_wait(tab: CDPTab, prompt: str, timeout: int = 180) -> str:
    """Blocking; jalankan di threadpool. Return markdown."""
    # 1. tunggu prompt box benar-benar muncul
    if not tab.wait_for(PROFILE["prompt"], timeout=30):
        # coba reload sekali
        log.warning("Prompt box belum muncul, reload halaman...")
        try:
            tab.navigate(PROFILE["url"])
        except Exception:
            pass
        if not tab.wait_for(PROFILE["prompt"], timeout=20):
            raise RuntimeError(
                f"Prompt selector tidak ketemu setelah retry: {PROFILE['prompt']}"
            )

    if not tab.focus(PROFILE["prompt"]):
        raise RuntimeError(f"Prompt selector tidak ketemu: {PROFILE['prompt']}")

    # 2. bersihkan isi
    tab.eval(
        "document.execCommand && document.execCommand('selectAll', false, null); 0"
    )
    tab.press_key("Backspace")

    # 3. ketik prompt
    tab.type_text(prompt)

    # 4. kirim
    if not tab.click(PROFILE["send"]):
        tab.press_key("Enter")

    # 5. tunggu stop button muncul lalu hilang
    try:
        deadline = time.time() + 30
        while time.time() < deadline and not tab.exists(PROFILE["stop"]):
            time.sleep(0.3)
        deadline = time.time() + timeout
        while time.time() < deadline and tab.exists(PROFILE["stop"]):
            time.sleep(0.5)
    except Exception as e:
        log.warning("stop-button wait failed: %s", e)

    # 6. tunggu ada response
    deadline = time.time() + 30
    resp = ""
    while time.time() < deadline:
        resp = tab.text(PROFILE["response"])
        if resp.strip():
            break
        time.sleep(0.5)

    # 7. tunggu stabil (innerText compare)
    prev = ""
    stable = 0
    for _ in range(timeout):
        time.sleep(1)
        cur = tab.text(PROFILE["response"])
        if cur == prev and cur.strip():
            stable += 1
            if stable >= 2:
                break
        else:
            stable = 0
        prev = cur

    # 8. ekstrak markdown
    md = ""
    try:
        md = tab.html_to_markdown(PROFILE["response"])
    except Exception as e:
        log.warning("html_to_markdown error: %s", e)

    final = (md or prev or resp or "").strip()

    # final = (md or prev or resp or "").strip()

    # Hapus label bahasa yang nyasar sebelum triple backtick
    # Mencocokkan kata (misal: Bash, Lua, Python) diikuti enter dan triple backtick
    # final = re.sub(
    #     r"\n(?:Bash|Lua|Python|Javascript|JSON|HTML|CSS|Text)\n```", "\n```", final
    # )
    # final = re.sub(
    #     r"^(?:Bash|Lua|Python|Javascript|JSON|HTML|CSS|Text)\n```", "```", final
    # )

    return final

    # 9. debug dump
    if DEBUG_DUMP:
        try:
            with open(DEBUG_DUMP, "w", encoding="utf-8") as f:
                f.write(final)
        except Exception:
            pass

    return final


# ================================================================
# Prompt builders
# ================================================================
def _build_chat_prompt(messages: list) -> str:
    parts = []
    for m in messages:
        if m.role == "system":
            parts.append(f"[SYSTEM INSTRUCTIONS]\n{m.content}")
        elif m.role == "user":
            parts.append(f"[USER]\n{m.content}")
        elif m.role == "assistant":
            parts.append(f"[ASSISTANT]\n{m.content}")
    return "\n\n".join(parts)


def _build_responses_prompt(items: list, instructions: str | None) -> str:
    parts = []
    if instructions:
        parts.append(f"[SYSTEM INSTRUCTIONS]\n{instructions}")
    for item in items:
        text = item.text()
        if not text.strip():
            continue
        if item.role == "user":
            parts.append(f"[USER]\n{text}")
        elif item.role == "assistant":
            parts.append(f"[ASSISTANT]\n{text}")
        elif item.role == "system":
            parts.append(f"[SYSTEM INSTRUCTIONS]\n{text}")
    return "\n\n".join(parts)


# ================================================================
# SSE helpers — streaming per-baris agar markdown tidak pecah
# ================================================================
def _chat_chunk(id_: str, delta: dict, finish: str | None = None) -> str:
    obj = {
        "id": id_,
        "object": "chat.completion.chunk",
        "created": int(time.time()),
        "model": "web-ai",
        "choices": [{"index": 0, "delta": delta, "finish_reason": finish}],
    }
    return f"data: {jsonlib.dumps(obj)}\n\n"


def _pseudo_chat_stream(answer: str):
    cid = f"chatcmpl-{uuid.uuid4().hex[:12]}"
    # chunk per baris; gabung dua baris berurutan untuk kurangi jumlah chunk
    lines = answer.split("\n")
    buf: list[str] = []
    for i, line in enumerate(lines):
        buf.append(line)
        if i == len(lines) - 1 or (len(buf) >= 2 and not line.startswith("```")):
            piece = "\n".join(buf)
            if i < len(lines) - 1:
                piece += "\n"
            buf = []
            yield _chat_chunk(cid, {"content": piece})
            time.sleep(0.01)
    yield _chat_chunk(cid, {}, finish="stop")
    yield "data: [DONE]\n\n"


def _resp_chunk(event_type: str, **kwargs) -> str:
    return f"data: {jsonlib.dumps({'type': event_type, **kwargs})}\n\n"


def _pseudo_responses_stream(answer: str, response_id: str):
    yield _resp_chunk(
        "response.created",
        response={
            "id": response_id,
            "object": "response",
            "created_at": int(time.time()),
            "status": "in_progress",
            "model": "web-ai",
            "output": [],
        },
    )
    item_id = f"msg_{uuid.uuid4().hex[:12]}"
    yield _resp_chunk(
        "response.output_item.added",
        output_index=0,
        item={
            "id": item_id,
            "type": "message",
            "role": "assistant",
            "status": "in_progress",
            "content": [],
        },
    )
    yield _resp_chunk(
        "response.content_part.added",
        item_id=item_id,
        output_index=0,
        content_index=0,
        part={"type": "output_text", "text": "", "annotations": []},
    )

    lines = answer.split("\n")
    buf: list[str] = []
    for i, line in enumerate(lines):
        buf.append(line)
        if i == len(lines) - 1 or (len(buf) >= 2 and not line.startswith("```")):
            piece = "\n".join(buf)
            if i < len(lines) - 1:
                piece += "\n"
            buf = []
            yield _resp_chunk(
                "response.output_text.delta",
                item_id=item_id,
                output_index=0,
                content_index=0,
                delta=piece,
            )
            time.sleep(0.01)

    yield _resp_chunk(
        "response.output_text.done",
        item_id=item_id,
        output_index=0,
        content_index=0,
        text=answer,
    )
    yield _resp_chunk(
        "response.content_part.done",
        item_id=item_id,
        output_index=0,
        content_index=0,
        part={"type": "output_text", "text": answer, "annotations": []},
    )
    yield _resp_chunk(
        "response.output_item.done",
        output_index=0,
        item={
            "id": item_id,
            "type": "message",
            "role": "assistant",
            "status": "completed",
            "content": [{"type": "output_text", "text": answer, "annotations": []}],
        },
    )
    yield _resp_chunk(
        "response.completed",
        response={
            "id": response_id,
            "object": "response",
            "created_at": int(time.time()),
            "status": "completed",
            "model": "web-ai",
            "output": [
                {
                    "id": item_id,
                    "type": "message",
                    "role": "assistant",
                    "status": "completed",
                    "content": [
                        {"type": "output_text", "text": answer, "annotations": []}
                    ],
                }
            ],
            "usage": {"input_tokens": 0, "output_tokens": 0, "total_tokens": 0},
        },
    )


# ================================================================
# FastAPI lifespan
# ================================================================
@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        mgr = get_manager()
        if mgr.is_alive():
            log.info("CDP detected at %s:%s", CDP_HOST, CDP_PORT)
        else:
            log.warning("CDP belum aktif di %s:%s", CDP_HOST, CDP_PORT)
    except Exception as e:
        log.warning("CDP check error: %s", e)
    yield
    if state.tab:
        state.tab.close()


app = FastAPI(lifespan=lifespan)


# ================================================================
# Schema
# ================================================================
class ChatMessage(BaseModel):
    role: str
    content: str | list

    def text(self) -> str:
        if isinstance(self.content, str):
            return self.content
        parts = []
        for p in self.content:
            if isinstance(p, dict):
                if p.get("type") in ("input_text", "text", "output_text"):
                    parts.append(str(p.get("text", "")))
                elif "text" in p:
                    parts.append(str(p["text"]))
            elif isinstance(p, str):
                parts.append(p)
        return "\n".join(parts)


class ResponsesInputItem(ChatMessage):
    pass


class FlexibleRequest(BaseModel):
    """Menerima payload Chat Completions maupun Responses."""

    model: str = "web-ai"
    messages: list[ChatMessage] | None = None
    input: list[ResponsesInputItem] | None = None
    instructions: str | None = None
    stream: bool = False
    temperature: float | None = None
    max_tokens: int | None = None
    max_output_tokens: int | None = None

    @model_validator(mode="after")
    def _at_least_one(self):
        if not self.messages and not self.input:
            raise ValueError("butuh 'messages' atau 'input'")
        return self


def _is_responses_shape(req: FlexibleRequest) -> bool:
    return bool(req.input) and not req.messages


def _build_flexible_prompt(req: FlexibleRequest) -> str:
    if _is_responses_shape(req):
        return _build_responses_prompt(req.input or [], req.instructions)
    msgs = req.messages or []
    # kalau ada instructions tapi tidak ada system message, prepend
    has_system = any(m.role == "system" for m in msgs)
    if req.instructions and not has_system:
        prefix = f"[SYSTEM INSTRUCTIONS]\n{req.instructions}\n\n"
        return prefix + _build_chat_prompt(msgs)
    return _build_chat_prompt(msgs)


# ================================================================
# Core handler
# ================================================================
async def _run_scrape(req: FlexibleRequest) -> str:
    prompt = _build_flexible_prompt(req)
    if not prompt.strip():
        raise HTTPException(400, "empty prompt")

    async with state.lock:
        try:
            tab = await asyncio.to_thread(ensure_tab)
            if NEW_CHAT_PER_REQUEST:
                await asyncio.to_thread(tab.navigate, PROFILE["url"])
                await asyncio.sleep(1.0)  # beri waktu render
            answer = await asyncio.to_thread(submit_and_wait, tab, prompt)
        except CDPError as e:
            raise HTTPException(500, f"CDP error: {e}")
        except Exception as e:
            log.exception("scrape error")
            raise HTTPException(500, f"{type(e).__name__}: {e}")
    return answer


# ================================================================
# Endpoints
# ================================================================
@app.post("/v1/chat/completions")
async def chat_completions(req: FlexibleRequest):
    is_resp = _is_responses_shape(req)
    answer = await _run_scrape(req)

    if is_resp:
        response_id = f"resp_{uuid.uuid4().hex[:16]}"
        if not req.stream:
            return {
                "id": response_id,
                "object": "response",
                "created_at": int(time.time()),
                "status": "completed",
                "model": "web-ai",
                "output": [
                    {
                        "id": f"msg_{uuid.uuid4().hex[:12]}",
                        "type": "message",
                        "role": "assistant",
                        "status": "completed",
                        "content": [
                            {"type": "output_text", "text": answer, "annotations": []}
                        ],
                    }
                ],
                "usage": {"input_tokens": 0, "output_tokens": 0, "total_tokens": 0},
            }
        return StreamingResponse(
            _pseudo_responses_stream(answer, response_id),
            media_type="text/event-stream",
        )

    if not req.stream:
        return {
            "id": f"chatcmpl-{uuid.uuid4().hex[:12]}",
            "object": "chat.completion",
            "created": int(time.time()),
            "model": "web-ai",
            "choices": [
                {
                    "index": 0,
                    "message": {"role": "assistant", "content": answer},
                    "finish_reason": "stop",
                }
            ],
            "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
        }
    return StreamingResponse(
        _pseudo_chat_stream(answer), media_type="text/event-stream"
    )


@app.post("/v1/responses")
async def responses(req: FlexibleRequest):
    answer = await _run_scrape(req)
    response_id = f"resp_{uuid.uuid4().hex[:16]}"

    if not req.stream:
        return {
            "id": response_id,
            "object": "response",
            "created_at": int(time.time()),
            "status": "completed",
            "model": "web-ai",
            "output": [
                {
                    "id": f"msg_{uuid.uuid4().hex[:12]}",
                    "type": "message",
                    "role": "assistant",
                    "status": "completed",
                    "content": [
                        {"type": "output_text", "text": answer, "annotations": []}
                    ],
                }
            ],
            "usage": {"input_tokens": 0, "output_tokens": 0, "total_tokens": 0},
        }
    return StreamingResponse(
        _pseudo_responses_stream(answer, response_id),
        media_type="text/event-stream",
    )


@app.get("/v1/models")
async def models():
    return {
        "object": "list",
        "data": [{"id": "web-ai", "object": "model", "owned_by": "local"}],
    }


@app.get("/health")
async def health():
    mgr = get_manager()
    return {
        "ok": True,
        "cdp_alive": mgr.is_alive(),
        "tab_connected": bool(state.tab and state.tab.ws.connected),
        "provider": PROFILE["provider"],
        "cdp_url": f"{CDP_HOST}:{CDP_PORT}",
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host=HOST, port=PORT, log_level="info")
