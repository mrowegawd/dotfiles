import re

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut

VIM_ID = "n?vim"


def is_window_vim(window):
    fp = window.child.foreground_processes
    return any(
        re.search(VIM_ID, p["cmdline"][0] if len(p["cmdline"]) else "", re.I)
        for p in fp
    )


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main():
    pass


def send_notification(title, message):
    import subprocess  # Import subprocess untuk menjalankan perintah sistem

    """Send a notification using dunstify."""
    subprocess.run(["dunstify", title, message])


@result_handler(no_ui=True)
def handle_result(args, _, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    direction = args[2]
    key_mapping = args[3]

    if window is None:
        return
    if is_window_vim(window):
        for keymap in key_mapping.split(">"):
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)
    else:
        # send_notification("handle_result", direction)
        if (
            direction == "narrower"
            or direction == "wider"
            or direction == "taller"
            or direction == "shorter"
        ):
            boss.active_tab.resize_window(direction, 3)
        else:
            boss.active_tab.neighboring_window(direction)
