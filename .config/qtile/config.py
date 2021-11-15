# Copyright (c) 2010 Aldo Cortesi
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
from logging import warning
import os
import re
import subprocess

from scripts.rofi_scripts import edit_configs

import xcffib.xproto

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook, qtile, extension
from libqtile.backend.base import FloatStates
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.log_utils import logger
from libqtile.lazy import lazy

from xcffib.xproto import StackMode


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen) + 1
    if i == len(qtile.screens):
        i = 0
    group = qtile.screens[i].group.name
    qtile.current_window.togroup(group)

def window_to_prev_screen(qtile):
    i = qtile.screens.index(qtile.current_screen) - 1
    if i < 0:
        i = len(qtile.screens) - 1
    group = qtile.screens[i].group.name
    qtile.current_window.togroup(group)

def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)

def go_to_group(name):

    def helper(qtile):
        if (qtile.screens) == 1:
            qtile.groups_map[name].cmd_toscreen()
            return
        
        old = qtile.current_screen.group.name
        gs = group_screen(qtile.groups_map[name])
        qtile.focus_screen(gs)
        if qtile.current_screen.group.name != name:
            qtile.groups_map[name].cmd_toscreen()
    
    return helper

def group_screen(group):
    if group.name in '1230':
        return 0
    elif group.name in 'asd':
        return 1
    else:
        return 0

def next_group(qtile):
    cg = qtile.current_screen.group
    next = cg
    gs = -1
    while gs != group_screen(cg):
        next = next._get_group(1, False, False)
        gs = group_screen(next)
    next.cmd_toscreen()


def prev_group(qtile):
    cg = qtile.current_screen.group
    next = cg
    gs = -1
    while gs != group_screen(cg):
        next = next._get_group(-1, False, False)
        gs = group_screen(next)
    next.cmd_toscreen()

# Taken from https://gist.github.com/TauPan/9c09bd9defc5ac3c9e06 and modified 

def switch_to_same_class(qtile):
    curr = qtile.current_window
    if curr is not None:
        wm_class = curr.window.get_wm_class()
    else:
        return

    windows = windows_matching_shuffle(qtile, wmclass=wm_class)
    if windows:
        next_win = windows[0]
        if next_win.group != qtile.current_group:
            gs = group_screen(next_win.group)
            qtile.focus_screen(gs)
            qtile.current_screen.set_group(next_win.group)
        else:
            pass
        next_win.group.focus(next_win, False)
    return

def windows_matching_shuffle(qtile, **kwargs):
    """return a list of windows matching window_match_re with **kwargs,
    ordered so that the current Window (if it matches) comes last
    """
    windows = sorted(
        [
            w
            for w in qtile.windows_map.values()
            if w.group and window_match_re(w, **kwargs)
        ],
        key=lambda ww: ww.window.wid
    )
    
    idx = 0
    if qtile.current_window is not None:
        try:
            idx = windows.index(qtile.current_window)
            idx += 1
        except ValueError:
            pass
    if idx >= len(windows):
        idx = 0
    return windows[idx:] + windows[:idx]


def window_match_re(window, wmname=None, wmclass=None, role=None):
    """
    match windows by name/title, class or role, by regular expressions
    Multiple conditions will be OR'ed together
    """

    if not (wmname or wmclass or role):
        raise TypeError(
            "at least one of name, wmclass or role must be specified"
        )
    ret = False
    if wmname:
        ret = ret or re.match(wmname, window.name)
    try:
        if wmclass:
            if type(wmclass) != list:
                wmclass = [wmclass]
            cls = window.window.get_wm_class()
            if cls:
                for wc in wmclass:
                    for v in cls:
                        ret = ret or re.match(wc, v)
        if role:
            rol = window.window.get_wm_window_role()
            if rol:
                ret = ret or re.match(role, rol)
    except (xcffib.xproto.WindowError, xcffib.xproto.AccessError):
        return False
    return ret

def switch_window(direction=1):

    @lazy.function
    def _switch_window(qtile):
        if direction == 1:
            qtile.current_group.cmd_next_window(),
        if direction == -1:
            qtile.current_group.cmd_prev_window(),
        qtile.current_window.window.configure(stackmode=StackMode.Above)

    return _switch_window

def group_floating_windows(window):
    return window.group.floating_layout.find_clients(window.group)

def fullscreen_neighbors(window):
    for win in window.group.windows:
        if win._float_state == FloatStates.FULLSCREEN:
            return True
    return False
    
def print_debug(obj):
    odict = obj.__dict__
    ostr = "\n"
    for k in odict:
        if k == 'icons':
            continue
        ostr += f"{k}: {odict[k]}\n"
    logger.warning(ostr)


mod = "mod4"
# terminal = "urxvt"
terminal = "alacritty"
browser = "firefox"
num_screens = 2



def init_colors(theme):
    theme_dict = dict(
        dracula = [["#282c34", "#282c34"], # 0 panel background
                   ["#3d3f4b", "#3d3f4b"], # 1 Inactive Window Margin Background
                   ["#f8f8f2", "#f8f8f2"], # 2 font color for group names
                   ["#74438f", "#74438f"], # 3 Current Window Background
                   ["#74438f", "#74438f"], # 4 border line color for 'other tabs'
                   ["#74438f", "#74438f"], # 5 color for 'odd widgets'
                   ["#3d3f4b", "#3d3f4b"], # 6 color for the 'even widgets'
                   ["#bd93f9", "#bd93f9"], # 7 Current Workspace
                   ["#ecbbfb", "#ecbbfb"]  # 8 background for inactive screens
        ],
        arcolinux = [["#282c34", "#282c34"], # 0 panel background
                     ["#2F343F", "#2F343F"], # 1 Inactive Window Margin Background
                     ["#f8f8f2", "#f8f8f2"], # 2 font color for everything
                     ["#3384d0", "#3384d0"], # 3 Current Window Background # 3384d0
                     ["#4c566a", "#4c566a"], # 4 Workspace open on other screen
                     ["#3384d0", "#3384d0"], # 5 color for 'odd widgets'
                     ["#2F343F", "#2F343F"], # 6 color for the 'even widgets'
                     ["#3384d0", "#3384d0"], # 7 Current Workspace # 3384d0
                     ["#a9a9a9", "#a9a9a9"], # 8 Inactive group with windows
        ],
        cyan = [["#282c34", "#282c34"], # 0 panel background
                     ["#2F343F", "#2F343F"], # 1 Inactive Window Margin Background
                     ["#f8f8f2", "#f8f8f2"], # 2 font color for everything
                     ["#06989a", "#06989a"], # 3 Current Window Background
                     ["#014142", "#014142"], # 4 Workspace open on other screen
                     ["#1e666b", "#1e666b"], # 5 color for 'odd widgets'
                     ["#3d3f4b", "#3d3f4b"], # 6 color for the 'even widgets'
                     ["#0f6f75", "#0f6f75"], # 7 Current Workspace
                     ["#33e8e2", "#33e8e2"], # 8 Inactive group with windows
        ],
        debug = [["#000000", "#000000"], # 0 panel background
                ["#00ff00", "#00ff00"], # 1 Inactive Window Margin Background
                ["#f8f8f2", "#f8f8f2"], # 2 font color for group names
                ["#fba922", "#fba922"], # 3 Current Window Background
                ["#ff00ff", "#ff00ff"], # 4 border line color for 'other tabs'
                ["#ff0000", "#ff0000"], # 5 color for 'odd widgets'
                ["#0000ff", "#0000ff"], # 6 color for the 'even widgets'
                ["#ffff00", "#ffff00"], # 7 Current Workspace
                ["#00ffff", "#00ffff"], # 8 background for inactive screens
        ],
    )
    return theme_dict[theme]


# colors = init_colors("dracula")
# colors = init_colors("cyan")
colors = init_colors("arcolinux")
# colors = init_colors("debug")


powerline_colors = [colors[6], colors[5]]

keys = [
    #region Switch/Resize Windows
    Key(
        [mod], "j", 
        switch_window(direction=1),
        desc="Move focus previous"
    ),
    Key(
        [mod], "k", 
        switch_window(direction=-1),
        desc="Move focus next"
    ),
    Key(
        [mod], "h", 
        lazy.layout.shrink_main(),
        desc="Grow window"
    ),
    Key(
        [mod], "l", 
        lazy.layout.grow_main(),
        desc="Shrink window"
    ),
    Key(
        [mod], "space",
        lazy.group.next_window()
    ),
    Key(
        [mod, "shift"], "j", 
        lazy.layout.shuffle_down(),
        desc="Move window down"
    ),
    Key(
        [mod, "shift"], "k", 
        lazy.layout.shuffle_up(), 
        desc="Move window up"
    ),
    Key(
        [mod, "shift"], "h", 
        lazy.layout.shrink(),
        desc="Move window down"
    ),
    Key(
        [mod, "shift"], "l", 
        lazy.layout.grow(),
        desc="Move window up"
    ),
    #endregion
    #region Launchers
    Key(
        [mod], "e", 
        lazy.spawn(terminal), 
        desc="Launch terminal"
    ),
    Key(
        [mod], "Return", 
        lazy.spawn(terminal), 
        desc="Launch terminal alt"
    ),   
    Key(
        [mod], "m", 
        lazy.spawn("pcmanfm"), 
        desc="Launch pcmanfm"
    ),
    Key(
        [mod], "w", 
        lazy.spawn(browser), 
        desc="Launch Browswer"
    ),
    Key(
        ["control", "shift"], "e", 
        lazy.spawn("copyq show"),
        desc="Show Copyq"
    ),
    Key(
        [mod], "r",
        lazy.run_extension(extension.DmenuRun(
            dmenu_prompt = "Run:",
            dmenu_command = "rofi -show run -i",
            background=colors[0][0],
            foreground=colors[2][0],
            selected_background=colors[7][0],
            selected_foreground=colors[2][0],
        )),
        desc='Run Launcher'
    ),  
    Key(
        ["mod1", "shift"], "r",
        lazy.run_extension(extension.J4DmenuDesktop(
            dmenu_prompt = "Run:",
            dmenu_command = "rofi -dmenu -i",
            background=colors[0][0],
            foreground=colors[2][0],
            selected_background=colors[7][0],
            selected_foreground=colors[2][0],
        )),
        desc='Run Launcher'
    ),
    Key(
        [mod, "shift"], "r",
        lazy.function(edit_configs),
        # lazy.run_extension(extension.J4DmenuDesktop(
        #     dmenu_prompt = "Run:",
        #     dmenu_command = "rofi -dmenu -i",
        #     background=colors[0][0],
        #     foreground=colors[2][0],
        #     selected_background=colors[7][0],
        #     selected_foreground=colors[2][0],
        # )),
        desc='Run Launcher'
    ),
    #endregion
    #region Window Management
    # Key(
    #     [mod], "grave",
    #     lazy.function(window_to_next_screen),
    #     desc="Move winow to next screen"
    # ),
    # Key(
    #     [mod, "shift"], "grave",
    #     lazy.function(window_to_prev_screen),
    #     desc="Move winow to prev screen"
    # ),
    Key(
        [mod], "grave",
        lazy.function(switch_to_same_class)
    ),
    Key(
        [mod, "shift"], "Right",
        lazy.next_screen(),
        desc='Move focus to next monitor'
    ),
    Key(
        ["mod1"], "Tab",
        lazy.function(next_group)
    ),
    Key(
        [mod, "shift"], "Left",
        lazy.prev_screen(),
        desc='Move focus to prev monitor'
    ),
    Key(
        ["mod1", "shift"], "Tab",
        lazy.function(prev_group)
    ),
    

    # Key(
    #     [mod], "m",
    #     lazy.layout.maximize(),
    #     desc='toggle window between minimum and maximum sizes'
    # ),
    Key(
        [mod, "shift"], "f",
        lazy.window.toggle_floating(),
        desc='toggle floating'
    ),
    Key(
        [mod], "f",
        lazy.window.toggle_fullscreen(),
        desc='toggle fullscreen'
    ),
    Key(
        [mod], "q", 
        lazy.window.kill(), 
        desc="Kill focused window"
    ),
    #endregion
    #region Screenshot
    Key(
        [], "Print", lazy.spawn("maim -s | xclip -selection clipboard -t image/png", shell=True)
    ),
    #endregion
    #region Switch focus of monitors
    Key([mod], "period",
        lazy.function(next_group)
    ),
    Key([mod], "comma",
        lazy.function(prev_group)
    ),
    #endregion
    #region Toggle between different layouts as defined below
    Key(
        [mod], "Tab", 
        lazy.next_layout(), 
        desc="Toggle between layouts"
    ),
    #endregion
    #region System / WM
    Key(
        [mod, "control"], "r", 
        lazy.restart(), 
        desc="Reload the config"
    ),
    Key(
        [mod, "control"], "q", 
        lazy.shutdown(), 
        desc="Shutdown Qtile"
    ),
    Key(
        [mod], "F12",
        lazy.spawn("arcolinux-logout"),
        desc="Suspend"
    ),
    KeyChord(
        [mod], "z",[
            Key([], "h", lazy.layout.grow_left(), lazy.window.resize_floating(dw=-50, dh=0)),
            Key([], "l", lazy.layout.grow_right(), lazy.window.resize_floating(dw=50, dh=0)),
            Key([], "j", lazy.layout.grow_down(), lazy.window.resize_floating(dw=0,dh=50)),
            Key([], "k", lazy.layout.grow_up(), lazy.window.resize_floating(dw=0,dh=-50)),
        ],
        mode="Windows"
    ),
    #endregion
    #region Volume/Media
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("amixer -q -D pulse set Master 5%+"),
        desc="Raise volume by 5%"
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("amixer -q -D pulse set Master 5%-"),
        desc="Lower volume by 5%"
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("amixer -q -D pulse set Master toggle"),
        desc="Toggle Mute"
    ),
    Key(
        [], "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Toggle Mute"
    ),
    #endregion
]

groups = [
    Group("1", layout='monadtall', position=0),
    Group("2", layout='monadtall', position=1),
    Group("3", layout='monadtall', position=2),
    # Group("0", layout='monadtall', position=2, matches=[Match(title="")]),
    Group("a", layout='monadtall', position=4, matches=[Match(wm_class="discord")]),
    Group("s", layout='monadtall', position=5, matches=[]),
    Group("d", layout='monadtall', position=6, matches=[]),
]

group_keys = []
for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        # Key([mod], i.name, lazy.group[i.name].toscreen(),
        Key([mod], i.name, lazy.function(go_to_group(i.name)),
            desc=f"Switch to group {i.name}"),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            desc=f"Move focused window to group {i.name}"),
    ])

layout_theme = {"border_width": 2,
                "margin": 4,
                "border_focus": colors[3],
                "border_normal": colors[1],
                "single_border_width": 0,
                "single_margin": 0,
            }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Columns(**layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]




widget_defaults = dict(
    font='UbuntuMono Nerd Font',
    fontsize=12,
    padding=2,
    foreground = colors[2],
    background=colors[0]
)
extension_defaults = widget_defaults.copy()


def make_powerline(widgets):
    powerline = []
    for i, w in enumerate(widgets):
        bg = powerline_colors[i % len(powerline_colors)]
        fg = powerline_colors[(i-1) % len(powerline_colors)]
        if i == 0:
            fg = colors[0]
        powerline.append(
            widget.TextBox(
                foreground = bg,
                background = fg,
                text="", # Icon: nf-oct-triangle_left
                fontsize=37,
                padding=-3,
            )
        )
        if type(w) == list:
            for w2 in w:
                w2.background = bg
                powerline.append(w2)
        else:
            w.background = bg
            powerline.append(w)
    return powerline

def make_widgets(screen):
    widget_list = [
        widget.Sep(
            linewidth = 0,
            padding = 6,
            background = colors[0]
        ),
        widget.GroupBox(
            font = "Ubuntu Bold",
            fontsize = 12,
            margin_y = 3,
            margin_x = 0,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 3,
            active = colors[8],
            inactive = colors[2],
            rounded = False,
            highlight_method = "block",
            this_current_screen_border = colors[7],
            this_screen_border = colors [4],
            other_current_screen_border = colors[7],
            other_screen_border = colors[4],
        ),
        widget.TaskList(
            font = "Ubuntu mono",
            rounded = False,
            fontsize = 12,
            background=colors[0],
            highlight_method = "block",
            margin_y=0,
            margin_x=0,
            padding_y=6,
            padding_x=3,
            borderwidth = 3,
            icon_size = 0,
            border=colors[3],
        ),
        widget.Sep(
            linewidth = 0,
            padding = 6,
        ),
        # widget.Prompt(),
        # widget.WindowName(),
        widget.Chord(
            chords_colors={
                'launch': ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
    ]
    pl_list = [
        widget.CPU(
            padding = 6,
        ),
        widget.Memory(
            format = '{MemUsed: .0f}{mm} /{MemTotal: .0f}{mm}',
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')},
            padding = 5
        ),
        widget.Net(
            format = '{down} ↓↑ {up}',
            padding = 5
        ),
        [widget.TextBox(
            text = " Vol:",
            padding = 0
        ),
        widget.Volume(
            padding = 5,
            mute_command = 'amixer -q -D pulse set Master toggle',
            volume_up_command = 'amixer -q -D pulse set Master 5%+',
            volume_down_command = 'amixer -q -D pulse set Master 5%-',
            get_volume_command = 'amixer -D pulse get Master'.split(),
        )],  
        widget.CurrentLayout(
            padding = 5
        ),
        widget.CheckUpdates(
            update_interval = 3600,
            distro = "Arch_checkupdates",
            display_format = "{updates} Updates",
            foreground = colors[2],
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e sudo pacman -Syu')},
            background = colors[5],
            no_update_string = '0 Updates',
            padding = 5,
        ),
        widget.Clock(
            padding = 5,
            format = "%A, %B %d - %H:%M "
        ),
    ]

    systray = [
        widget.Systray(
            icon_size = 20,
            padding = 5,
        ),
        widget.Sep(
            linewidth = 0,
            padding = 6,
        ),
    ]
    
    if screen == 0:
        pl_list.insert(-1, systray)


    widget_list += make_powerline(pl_list)
    return widget_list

screens = [
    Screen(top=bar.Bar(widgets=make_widgets(0), size = 24)),
    Screen(top=bar.Bar(widgets=make_widgets(1), size = 24))
]


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class='copyq'),
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
        Match(wm_class='Arcolinux-welcome-app.py'),
        Match(wm_class='Arcolinux-tweak-tool.py'),
        Match(wm_class='Arcolinux-calamares-tool.py'),
        Match(wm_class='Arandr'),
        Match(wm_class='feh'),
        Match(wm_class='Galculator'),
        Match(wm_class='arcolinux-logout'),
        Match(wm_class='xfce4-terminal'),
    ],
    border_focus=colors[7],
    border_normal=colors[4],
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
        qtile.groups_map['1'].cmd_toscreen(1, toggle=False)
        qtile.groups_map['a'].cmd_toscreen(1, toggle=False)
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"