# 0 Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import yaml

from Xlib import display as xdisplay
from xcffib.xproto import StackMode

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Match, Screen, EzKey
from libqtile.log_utils import logger
from libqtile.lazy import lazy

from group_config import groups_list, group_keys
from scroll import omni_scroll

groups = groups_list

hostname = os.uname().nodename
laptop = "MSI" in hostname


@lazy.function
def top_window(qtile):
    qtile.current_window.window.configure(stackmode=StackMode.Above)


# @lazy.function
# def test(qtile):
#     pass


# https://github.com/ValveSoftware/steam-for-linux/issues/2685
# https://old.reddit.com/r/i3wm/comments/9i81rf/close_steam_to_tray_instead_of_killing_the_process/
@lazy.function
def kill_or_steam(qtile):
    if "Steam" in qtile.current_window.window.get_wm_class():
        qtile.cmd_spawn("xdotool windowunmap $(xdotool getactivewindow)", shell=True)
    else:
        qtile.current_window.kill()


def print_debug(obj):
    odict = obj.__dict__
    ostr = "\n"
    for k in odict:
        if k == "icons":
            continue
        ostr += f"{k}: {odict[k]}\n"
    logger.warning(ostr)


theme = os.path.expanduser("~") + "/.config/qtile/themes/tokyonight.yml"
with open(theme) as theme_file:
    colors = yaml.load(theme_file, yaml.Loader)

powerline_colors = [[colors[9], colors[10]], [colors[7], colors[8]]]


EzKey.modifier_keys = {
    "M": "mod4",
    "A": "mod1",
    "S": "shift",
    "C": "control",
    "H": "mod3",
}
mod = "mod4"
home = os.path.expanduser("~")
# terminal = "alacritty"
terminal = "kitty"
file_manager = "pcmanfm"
term_file_manager = "ranger"
browser = "firefox"
calendar = "morgen"
rofi_cmd = "colorful_launcher"

my_keys = [
    # Window keys
    ["M-j", lazy.group.next_window(), top_window, "Move focus next"],
    ["M-k", lazy.group.prev_window(), top_window, "Move focus prev"],
    ["M-h", lazy.layout.left(), "Grow main window"],
    ["M-l", lazy.layout.right(), "Shrink main window"],
    ["M-S-h", lazy.layout.shuffle_left(), "Move window left"],
    ["M-S-l", lazy.layout.shuffle_right(), "Move window right"],
    ["M-S-j", lazy.layout.shuffle_down(), "Move window down"],
    ["M-S-k", lazy.layout.shuffle_up(), "Move window up"],
    ["M-C-h", lazy.layout.grow_left(), "Grow window left"],
    ["M-C-l", lazy.layout.grow_right(), "Grow window right"],
    ["M-C-j", lazy.layout.grow_down(), "Grow window down"],
    ["M-C-k", lazy.layout.grow_up(), "Grow window up"],
    ["M-i", lazy.layout.normalize(), "Normalize"],
    # Layout keys
    ["M-<Tab>", lazy.next_layout(), "Toggle between layouts"],
    ["M-f", lazy.window.toggle_floating(), "toggle floating"],
    ["M-S-f", lazy.window.toggle_fullscreen(), "toggle fullscreen"],
    ["M-S-<Right>", lazy.next_screen(), "Move focus to next monitor"],
    ["M-S-<Left>", lazy.prev_screen(), "Move focus to prev monitor"],
    # Launch keys
    ["M-e", lazy.spawn(terminal), "Launch Terminal"],
    ["M-C-e", lazy.spawn("rosterm"), "Launch Ros Terminal"],
    ["M-<Return>", lazy.spawn(terminal), "Launch Terminal alt"],
    ["M-b", lazy.spawn(terminal + " -e btop"), "Launch BTOP"],
    ["M-m", lazy.spawn(file_manager), "Launch File manager"],
    [
        "M-S-m",
        lazy.spawn(terminal + " -e " + term_file_manager),
        "Launch Terminal File manager",
    ],
    ["M-u", lazy.spawn("steam steam://open/friends"), "Launch Steam Friends"],
    ["M-w", lazy.spawn("firefox"), "Launch Firefox"],
    ["M-S-w", lazy.spawn("firefox -private-window"), "Launch Private Firefox"],
    ["M-x", lazy.spawn("qalculate-gtk"), "Launch Calculator"],
    ["M-S-e", lazy.spawn("copyq show"), "Show Copyq"],
    ["M-r", lazy.spawn(rofi_cmd + " -show run -i", shell=True), "Run Launcher"],
    [
        "M-S-r",
        lazy.spawn(rofi_cmd + " -show drun -i", shell=True),
        "Application Launcher",
    ],
    ["M-c", lazy.spawn("edit_configs"), "Config Launcher"],
    ["M-o", lazy.spawn("edit_homework"), "Homework Launcher"],
    ["M-z", lazy.spawn("zathura"), "Open PDF reader"],
    ["M-v", lazy.spawn(terminal + " -e nvim"), "Launch Neovim"],
    ["<Print>", lazy.spawn("flameshot gui"), "Take Screenshot"],
    # Command keys
    ["M-C-r", lazy.reload_config(), "Reload Qtile config"],
    ["M-A-r", lazy.restart(), "Restart Qtile"],
    ["M-C-q", lazy.shutdown(), "Shutdown Qtile"],
    ["M-q", kill_or_steam, "Kill focused window"],
    ["M-C-q", lazy.spawn("xkill"), "Kill focused window"],
    ["M-<F1>", lazy.spawn("powermenu"), "Logout Menu"],
    ["M-<F2>", lazy.spawn("systemctl suspend"), "Suspend"],
    # Media keys
    [
        "<XF86AudioRaiseVolume>",
        lazy.spawn("amixer -q -D pulse set Master 5%+"),
        "Raise volume by 5%",
    ],
    [
        "<XF86AudioLowerVolume>",
        lazy.spawn("amixer -q -D pulse set Master 5%-"),
        "Lower volume by 5%",
    ],
    [
        "<XF86AudioMute>",
        lazy.spawn("amixer -q -D pulse set Master toggle"),
        "Toggle Mute",
    ],
    ["S-<XF86AudioPlay>", lazy.spawn("amixer -q -D pulse set Master toggle"), "Toggle Mute"],
    ["<XF86AudioPlay>", lazy.spawn("playerctl play-pause"), "Play/Pause"],
    ["M-p", lazy.spawn("playerctl play-pause"), "Play/Pause"],
    ["M-n", lazy.spawn("playerctl next"), "Next"],
    # Mouse keys
    ["M-<F3>", omni_scroll("left"), "Scroll left"],
    ["M-<F4>", omni_scroll("right"), "Scroll right"],
    ["M-S-<F3>", lazy.spawn("amixer -q -D pulse set Master 5%-"), "Lower volume"],
    ["M-S-<F4>", lazy.spawn("amixer -q -D pulse set Master 5%+"), "Raise volume"],
    ["M-C-<F3>", omni_scroll("left", "control"), "Scroll left control"],
    ["M-C-<F4>", omni_scroll("right", "control"), "Scroll right control"],
]


my_keys += group_keys

keys = [EzKey(bind, *cmd, desc=desc) for bind, *cmd, desc in my_keys]

layout_theme = {
    "border_width": 2,
    "margin": 2,
    "border_focus": colors[3],
    "border_normal": colors[1],
    "single_border_width": 0,
    "single_margin": 0,
    "border_on_single": 2,
    "margin_on_single": 4,
}

layouts = [
    # layout.MonadTall(**layout_theme),
    layout.Columns(**layout_theme, insert_position=1),
    layout.Max(**(layout_theme | {"border_width": 0, "margin": 0})),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(**layout_theme, num_stacks=2),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]


widget_defaults = dict(
    font="Source Code Pro",
    fontsize=12,
    padding=2,
    foreground=colors[2],
    background=colors[0],
)
extension_defaults = widget_defaults.copy()


def make_powerline(widgets):
    powerline = []
    for i, w in enumerate(widgets):
        index = i % len(powerline_colors)
        next_index = (i - 1) % len(powerline_colors)
        bg = powerline_colors[index][0]
        fg = powerline_colors[next_index][0]
        text_fg = powerline_colors[index][1]
        if i == 0:
            fg = colors[0]
        powerline.append(
            widget.TextBox(
                font="Source Code Pro",
                foreground=bg,
                background=fg,
                text="",  # Icon: nf-oct-triangle_left
                fontsize=22,
                padding=0
            )
        )
        if type(w) == list:
            for w2 in w:
                w2.background = bg
                w2.foreground = text_fg
                powerline.append(w2)
        else:
            w.background = bg
            w.foreground = text_fg
            w.colour_have_updates = text_fg
            w.colour_no_updates = text_fg
            powerline.append(w)
    return powerline


def make_widgets(screen):
    widget_list = [
        widget.Sep(linewidth=0, padding=6, background=colors[0]),
        widget.GroupBox(
            font="Source Code Pro Bold",
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active=colors[6],
            inactive=colors[2],
            rounded=False,
            highlight_method="block",
            this_current_screen_border=colors[5],
            this_screen_border=colors[4],
            other_current_screen_border=colors[5],
            other_screen_border=colors[4],
            use_mouse_wheel=False,
            # visible_groups=[g.name for g in groups if group_screen(g) == screen]
        ),
        widget.TaskList(
            rounded=False,
            background=colors[0],
            highlight_method="block",
            margin_y=0,
            margin_x=0,
            padding_y=4,
            padding_x=3,
            borderwidth=3,
            icon_size=0,
            border=colors[3],
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
        # widget.Prompt(),
        # widget.WindowName(),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
    ]
    pl_list = [
        widget.CPU(
            format="CPU {load_percent}%",
            padding=6,
        ),
        widget.Memory(
            format="{MemUsed: .0f}{mm} /{MemTotal: .0f}{mm}",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(terminal + " -e btop")},
            padding=5,
        ),
        widget.Net(
            format="{down} ↓↑ {up}",
            # prefix='M',
            padding=5,
        ),
        widget.PulseVolume(
            fmt=" {}",
            padding=5,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol"),
                "Button3": lambda: qtile.cmd_spawn(
                    "amixer -q -D pulse set Master toggle"
                ),
            },
            step=5,
        ),
        widget.CheckUpdates(
            update_interval=3600,
            distro="Arch_checkupdates",
            display_format="{updates} Updates",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(terminal + " -e sudo pacman -Syu")
            },
            no_update_string="0 Updates",
            padding=5,
        ),
        widget.Clock(
            font="Source Code Pro Bold",
            padding=5,
            format="%A, %B %d - %H:%M ",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn('xdotool key "alt+c"')},
        ),
    ]

    systray = [
        widget.Systray(
            icon_size=20,
            padding=5,
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
    ]

    if screen == 0:
        pl_list.insert(-1, systray)
    if laptop:
        battery_widget = widget.Battery(
            format=" {percent:2.0%} {char}{hour:d}:{min:02d}",
            charge_char="+",
            discharge_char="-",
            empty_char="x",
            notify_below=10,
        )
        current_layout = widget.CurrentLayoutIcon(
            padding=5,
            scale=0.7,
        )
        pl_list.insert(3, battery_widget)
        pl_list.insert(5, current_layout)
    else:
        current_layout = widget.CurrentLayout(
            padding=5,
        )
        pl_list.insert(4, current_layout)

    widget_list += make_powerline(pl_list)
    return widget_list


def get_num_monitors():
    num_monitors = 0
    try:
        display = xdisplay.Display()
        screen = display.screen()
        resources = screen.root.xrandr_get_screen_resources()

        for output in resources.outputs:
            monitor = display.xrandr_get_output_info(output, resources.config_timestamp)
            preferred = False
            if hasattr(monitor, "preferred"):
                preferred = monitor.preferred
            elif hasattr(monitor, "num_preferred"):
                preferred = monitor.num_preferred
            if preferred:
                num_monitors += 1
    except Exception as e:
        # always setup at least one monitor
        logger.error(f"Exception while getting num monitors: {e}")
        return 1
    else:
        return num_monitors


num_monitors = get_num_monitors()


screens = [
    Screen(top=bar.Bar(widgets=make_widgets(i), size=24)) for i in range(num_monitors)
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="copyq"),
        Match(wm_class="qalculate-gtk"),
        Match(title="Friends List", wm_class="Steam"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="Arandr"),
        Match(wm_class="feh"),
    ],
    border_focus=colors[3],
    border_normal=colors[1],
    border_width=2,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False


@hook.subscribe.startup_once
def start_once():
    if len(qtile.screens) > 1:
        qtile.groups_map["a"].cmd_toscreen(1)
        qtile.groups_map["1"].cmd_toscreen(0)
    subprocess.call([home + "/.config/qtile/scripts/autostart.sh"])


@hook.subscribe.client_new
def set_floating(window):
    if window.window.get_wm_transient_for():
        window.floating = True


@hook.subscribe.client_focus
def client_focus(window):
    # qtile 0.21 implemented _NET_WM_STATE_FOCUSED
    # if fullscreen windows have this set tabbing out of them removes it
    # this re-sets the _NET_WM_STATE_FULLSCREEN state
    # setting the stackmode of the new window directly afterwards doesn't work so the focused state is removed early
    if window.fullscreen:
        focused = window.qtile.core.conn.atoms["_NET_WM_STATE_FOCUSED"]
        state = list(window.window.get_property("_NET_WM_STATE", "ATOM", unpack=int))
        if focused in state:
            state.remove(focused)
            window.window.set_property("_NET_WM_STATE", state)


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
