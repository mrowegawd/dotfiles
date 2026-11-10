import os

PROFILES = {
    # "chatgpt": {
    #     "url": "https://chatgpt.com",
    #     "prompt": "#prompt-textarea, div[contenteditable='true'][id='prompt-textarea']",
    #     "send": "button[data-testid='send-button']",
    #     "stop": "button[data-testid='stop-button']",
    #     "response": "[data-message-author-role='assistant']",
    #     "url_prefix": "https://chatgpt.com",
    # },
    "chatgpt": {
        "url": "https://chatgpt.com",
        "prompt": 'div.ProseMirror[contenteditable="true"], div[contenteditable="true"]',
        "send": 'button[data-testid="send-button"], button[aria-label*="Send"]',
        "stop": 'button[data-testid="stop-button"], button[aria-label*="Stop"]',
        # "response": '[data-message-author-role="assistant"]',
        # "response": '[data-message-author-role="assistant"] .markdown, [data-message-author-role="assistant"]',
        # "response": '[class*="message"]:has([class*="prose"]) [class*="prose"]',
        "response": '[class*="prose"], [class*="markdown"]',
        "url_prefix": "https://chatgpt.com",
    },
    "claude": {
        "url": "https://claude.ai/new",
        "prompt": "div[contenteditable='true'].ProseMirror",
        "send": "button[aria-label='Send message'], button[aria-label='Send Message']",
        "stop": "button[aria-label='Stop response']",
        "response": "[data-testid='chat-message'], .font-claude-message",
        "url_prefix": "https://claude.ai",
    },
    "gemini": {
        "url": "https://gemini.google.com/app",
        "prompt": "rich-textarea div[contenteditable='true'], div.ql-editor[contenteditable='true']",
        "send": "button.send-button, button[aria-label='Send message']",
        "stop": "button[aria-label='Stop response']",
        "response": "model-response .markdown, message-content .markdown",
        "url_prefix": "https://gemini.google.com",
    },
}


def get_profile(name: str | None = None) -> dict:
    name = name or os.getenv("WEB_AI_PROVIDER", "chatgpt")
    prof = PROFILES.get(name)
    if not prof:
        raise ValueError(f"Unknown provider: {name}")
    prof = dict(prof)
    for key in ("url", "prompt", "send", "stop", "response", "url_prefix"):
        env_key = f"WEB_AI_SEL_{key.upper()}"
        if os.getenv(env_key):
            prof[key] = os.getenv(env_key)
    prof["provider"] = name
    return prof
