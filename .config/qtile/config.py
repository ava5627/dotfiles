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
import os
import subprocess
import importlib
import sys
import yaml

from Xlib import display as xdisplay
from xcffib.xproto import StackMode

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Match, Screen, EzKey
from libqtile.log_utils import logger
from libqtile.lazy import lazy

# Config imports
def reload(module):
    if module in sys.modules:
        importlib.reload(sys.modules[module])

reload('groups')
from groups import groups, group_keys
groups = groups

@lazy.function
def top_window(qtile):
    qtile.current_window.window.configure(stackmode=StackMode.Above)
    

# https://github.com/ValveSoftware/steam-for-linux/issues/2685
# https://old.reddit.com/r/i3wm/comments/9i81rf/close_steam_to_tray_instead_of_killing_the_process/
@lazy.function
def kill_or_steam(qtile):
    if 'Steam' in qtile.current_window.window.get_wm_class():
        qtile.cmd_spawn("xdotool windowunmap $(xdotool getactivewindow)", shell=True)
    else:
        qtile.current_window.kill()


def print_debug(obj):
    odict = obj.__dict__
    ostr = "\n"
    for k in odict:
        if k == 'icons':
            continue
        ostr += f"{k}: {odict[k]}\n"
    logger.warning(ostr)

theme = os.path.expanduser('~') + '/.config/qtile/themes/blue.yml'
with open(theme) as theme_file:
    colors = yaml.load(theme_file, yaml.Loader)

powerline_colors = [colors[6], colors[5]]

mod = "mod4"
terminal = "alacritty"
file_manager = "pcmanfm"
browser = "firefox"
calendar = "morgen"
rofi_cmd = ".config/rofi/launchers/colorful/launcher.sh"
rofi_scripts = ".config/rofi/scripts/"

my_keys = [
    # window keys
    ["M-j", 	                    lazy.group.next_window(), top_window,   	                    "Move focus next",],
    ["M-k", 	                    lazy.group.prev_window(), top_window,   	                    "Move focus prev",],
    ["M-h", 	                    lazy.layout.shrink_main(), 	                                    "Grow main window",],
    ["M-l", 	                    lazy.layout.grow_main(), 	                                    "Shrink main window",],
    ["M-S-h", 	                    lazy.layout.shrink(), 	                                        "Grow window",],
    ["M-S-l", 	                    lazy.layout.grow(), 	                                        "Shrink window",],
    ["M-S-j", 	                    lazy.layout.shuffle_down(), 	                                "Move window down",],
    ["M-S-k", 	                    lazy.layout.shuffle_up(),  	                                    "Move window up",],
    ["M-<Tab>", 	                lazy.next_layout(),  	                                        "Toggle between layouts",],
    ["M-f", 	                    lazy.window.toggle_floating(), 	                                "toggle floating",],
    ["M-S-f",         	            lazy.window.toggle_fullscreen(), 	                            "toggle fullscreen",],
    ["M-S-<Right>", 	            lazy.next_screen(), 	                                        "Move focus to next monitor",],
    ["M-S-<Left>", 	                lazy.prev_screen(), 	                                        "Move focus to prev monitor",],

    # launch keys
    ["M-e", 	                    lazy.spawn(terminal),  	                                        "Launch Terminal",],
    ["M-<Return>", 	                lazy.spawn(terminal),  	                                        "Launch Terminal alt",],
    ["M-b", 	                    lazy.spawn(terminal + " -e btop"),                              "Launch BTOP",],
    ["M-m", 	                    lazy.spawn(file_manager),  	                                    "Launch File manager",],
    ["M-u", 	                    lazy.spawn('steam steam://open/friends'),  	                    "Launch Steam Friends",],
    ["M-w", 	                    lazy.spawn("firefox"),                                          "Launch Firefox",],
    ["M-S-w", 	                    lazy.spawn("firefox -private-window"),                          "Launch Private Firefox",],
    ["M-z", 	                    lazy.spawn("qalculate-gtk"),                                    "Launch Calculator",],
    ["M-S-e", 	                    lazy.spawn("copyq show"), 	                                    "Show Copyq",],
    ["M-r", 	                    lazy.spawn(rofi_cmd + " -show run -i", shell=True), 	        "Run Launcher",],
    ["M-S-r", 	                    lazy.spawn(rofi_cmd + " -show drun -i", shell=True),            "Application Launcher",],
    ["M-c", 	                    lazy.spawn(rofi_scripts + "edit_configs"), 	                    "Config Launcher",],
    ["<Print>",                     lazy.spawn("flameshot gui"),                                    "Take Screenshot",],

    # command keys
    ["M-C-r", 	                    lazy.reload_config(),  	                                        "Reload the config",],
    ["M-A-r", 	                    lazy.restart(),  	                                            "Restart Qtile",],
    ["M-C-q", 	                    lazy.shutdown(),    	                                        "Shutdown Qtile",],
    ["M-q", 	                    kill_or_steam,  	                                            "Kill focused window",],
    ["M-<F1>", 	                    lazy.spawn("arcolinux-logout"), 	                            "Logout Menu",],
    ["M-<F2>", 	                    lazy.spawn("systemctl suspend"),           	                    "Suspend",],
    ["<XF86AudioRaiseVolume>",  	lazy.spawn("amixer -q -D pulse set Master 5%+"), 	            "Raise volume by 5%",],
    ["<XF86AudioLowerVolume>", 	    lazy.spawn("amixer -q -D pulse set Master 5%-"), 	            "Lower volume by 5%",],
    ["<XF86AudioMute>",             lazy.spawn("amixer -q -D pulse set Master toggle"),             "Toggle Mute",],
    ["<XF86AudioPlay>", 	        lazy.spawn("playerctl play-pause"), 	                        "Play/Pause",],
    ["M-p", 	                    lazy.spawn("playerctl play-pause"), 	                        "Play/Pause",],
    ["M-n", 	                    lazy.spawn("playerctl next"),                                   "Next",],
]

my_keys += group_keys
keys = [EzKey(bind, *cmd, desc=desc) for bind, *cmd, desc in my_keys]


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
    font='Source Code Pro',
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
                font='Source Code Pro',
                foreground = bg,
                background = fg,
                text="", # Icon: nf-oct-triangle_left
                fontsize=18,
                padding=0,
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
            font = 'Source Code Pro Bold',
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
            # visible_groups = [g.name for g in groups if group_screen(g) == screen]
        ),
        widget.TaskList(
            rounded = False,
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
            # prefix = 'M',
            padding = 5
        ),
        [widget.TextBox(
            text = " Vol:",
            padding = 0,
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('pavucontrol')},
        ),
        widget.Volume(
            padding = 5,
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('pavucontrol')},
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
            font = 'Source Code Pro Bold',
            padding = 5,
            format = "%A, %B %d - %H:%M ",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(calendar)},
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
    except Exception as _:
        # always setup at least one monitor
        return 1
    else:
        return num_monitors

num_monitors = get_num_monitors()


screens = [Screen(top=bar.Bar(widgets=make_widgets(i), size = 24)) for i in range(num_monitors)]


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = [] 
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class='copyq'),
        Match(wm_class='qalculate-gtk'),
        Match(title='Friends List'),
        Match(title='Volume Control'),
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
        Match(wm_class='arcolinux-logout'),
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
        qtile.groups_map['a'].cmd_toscreen(1, toggle=False)
        qtile.groups_map['1'].cmd_toscreen(0, toggle=False)
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

# @hook.subscribe.client_focus
# def focus_change(window):
#     window.window.configure(stackmode=StackMode.Above)

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
