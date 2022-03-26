from libqtile import qtile
from libqtile.config import Group, Match
from libqtile.lazy import lazy


def go_to_group(name):

    def _go_to_group(qtile):
        old = qtile.current_screen
        gs = group_screen(qtile.groups_map[name])
        qtile.focus_screen(gs, warp=True)
        qtile.groups_map[name].cmd_toscreen(gs)
        if qtile.current_screen != old:
            qtile.warp_to_screen()
    
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


groups = [
    Group("1", layout='max',       matches=[]),
    Group("2", layout='monadtall', matches=[]),
    Group("3", layout='monadtall', matches=[]),
    Group("a", layout='monadtall', matches=[Match(wm_class="discord")]),
    Group("s", layout='monadtall', matches=[]),
    Group("d", layout='monadtall', matches=[]),
]

group_keys = []
for i in groups:
    group_keys.extend([
        # mod1 + letter of group = switch to group
        # Key([mod], i.name, lazy.group[i.name].toscreen(),
        ['M-' + i.name, lazy.function(go_to_group(i.name)), f"Switch to group {i.name}"],

        # mod1 + shift + letter of group = switch to & move focused window to group
        ['M-S-' + i.name, lazy.window.togroup(i.name),      f"Switch to group {i.name}"],
    ])

group_keys.extend([
    ["M-<period>", 	    switch_group(direction=1),     "Switch to next group",],
    ["M-<comma>", 	    switch_group(direction=-1),    "Switch to previous group",],
])

