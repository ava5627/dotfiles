import subprocess


def edit_configs(qtile):
    configs = [
        "~/.config/qtile",
        "~/.config/alacritty",
        "~/.config/fish",
        "~/.config/nvim",
        "~/.bashrc",
    ]
    config_str = "\\n".join(configs)
    choice = subprocess.getoutput(f"echo -e \"{config_str}\" | rofi -dmenu -i -p \"Edit Configs\"")
    if choice:
        qtile.cmd_spawn(f"code {choice}", shell=True)