from libqtile.lazy import lazy
from libqtile.log_utils import logger


def get_firefox_url(win_title):
    import io
    import json
    import pathlib as p

    fpath = next(
        iter(
            p.Path("~/.mozilla/firefox")
            .expanduser()
            .glob("*.default*/sessionstore-backups/recovery.js*")
        )
    )
    with io.open(fpath, "rb") as fd:
        if fpath.suffix == ".jsonlz4":
            import lz4.block as lz4

            fd.read(8)  # b"mozLz40\0"
            jdata = json.loads(lz4.decompress(fd.read()).decode("utf-8"))
        else:
            jdata = json.load(fd)
        for win in jdata["windows"]:
            for tab in win["tabs"]:
                index = tab["index"] - 1
                url = tab["entries"][index]["url"]
                title = tab["entries"][index]["title"]
                if title in win_title:
                    return url
        return None


def firefox_scroll(qtile, direction, modifier=None):
    if modifier is None:
        if direction == "left":
            qtile.cmd_spawn("xdotool key ctrl+Shift+Tab")
        elif direction == "right":
            qtile.cmd_spawn("xdotool key ctrl+Tab")
    elif modifier == "control":
        url = get_firefox_url(qtile.current_window.name)
        if url and "reddit" in url:
            if direction == "left":
                qtile.cmd_spawn("xdotool key --clearmodifiers j")
            elif direction == "right":
                qtile.cmd_spawn("xdotool key --clearmodifiers k")
        else:
            if direction == "left":
                qtile.cmd_spawn("xdotool key --clearmodifiers Left")
            elif direction == "right":
                qtile.cmd_spawn("xdotool key --clearmodifiers Right")


def discord_scroll(qtile, direction, modifier=None):
    if modifier is None:
        if direction == "left":
            qtile.cmd_spawn("xdotool key ctrl+Tab")
        elif direction == "right":
            qtile.cmd_spawn("xdotool key ctrl+Shift+Tab")


def mpv_scroll(qtile, direction, modifier=None):
    if modifier is None:
        if direction == "left":
            qtile.cmd_spawn("xdotool key Page_Down")
        elif direction == "right":
            qtile.cmd_spawn("xdotool key Page_Up")
    if modifier == "control":
        if direction == "left":
            qtile.cmd_spawn("xdotool key --clearmodifiers 0x7b")
        elif direction == "right":
            qtile.cmd_spawn("xdotool key --clearmodifiers 0x7d")


def omni_scroll(direction, modifier=None):
    @lazy.function
    def _omni_scroll(qtile):
        if qtile.current_window:
            if "Firefox" in qtile.current_window.name:
                firefox_scroll(qtile, direction, modifier)
            elif "Discord" in qtile.current_window.name:
                discord_scroll(qtile, direction, modifier)
            elif "mpv" in qtile.current_window.name:
                mpv_scroll(qtile, direction, modifier)

    return _omni_scroll
