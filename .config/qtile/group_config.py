from libqtile import qtile
from libqtile.config import Group, Match
from libqtile.lazy import lazy


def go_to_group(name):

    @lazy.function
    def _go_to_group(qtile):
        old = qtile.current_screen
        group = qtile.groups_map[name]
        gs = group_screen(group)
        group.cmd_toscreen(gs)
        qtile.focus_screen(gs, warp=True)
        if qtile.current_screen != old:
            qtile.warp_to_screen()
        if qtile.current_window:
            qtile.current_window.focus(False)

    return _go_to_group


def group_screen(group):
    if len(qtile.screens) == 1:
        return 0

    if group.name in '123':
        return 0
    elif group.name in 'asd':
        return 1
    else:
        return 0


def switch_group(direction):

    @lazy.function
    def _switch_group(qtile):
        cg = qtile.current_screen.group
        next = cg
        gs = -1
        while gs != group_screen(cg):
            next = next._get_group(direction, False, False)
            gs = group_screen(next)
        next.cmd_toscreen()

    return _switch_group


groups_list = [
    Group("1", layout='max', matches=[]),
    Group("2", matches=[]),
    Group("3", matches=[]),
    Group("a", matches=[Match(wm_class="discord")]),
    Group("s", matches=[]),
    Group("d", matches=[]),
]

group_keys = []
for i in groups_list:
    group_keys.extend([
        # mod1 + key of group = switch to group
        ['M-' + i.name, go_to_group(i.name),                                f"Switch to group {i.name}"],
        # mod1 + shift + key of group = move focused window to group
        ['M-S-' + i.name, lazy.window.togroup(i.name),                      f"Move window to group {i.name}"],
        # mod1 + control + key of group = move focused window and switch to group
        ['M-C-' + i.name, lazy.window.togroup(i.name), go_to_group(i.name), f"Move and switch to group {i.name}"],
    ])

group_keys.extend([
    ["M-<period>", 	    switch_group(direction=1),     "Switch to next group", ],
    ["M-<comma>", 	    switch_group(direction=-1),    "Switch to previous group", ],
])
