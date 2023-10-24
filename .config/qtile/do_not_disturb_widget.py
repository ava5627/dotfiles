import subprocess
from libqtile.widget import base, GenPollCommand


class DoNotDisturb(base.ThreadPoolText):
    """A generic text widget to display output from scripts or shell commands"""

    defaults = [
        ("update_interval", 60, "update time in seconds"),
        ("cmd", None, "command line as a string or list of arguments to execute"),
        ("shell", False, "run command through shell to enable piping and shell expansion"),
    ]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(GenPollCommand.defaults)
        self.dnd_background = config.get("dnd_background", "ff0000")
        self.dnd_foreground = config.get("dnd_foreground", "ffffff")
        self.off_background = config.get("off_background", self.background)
        self.off_foreground = config.get("off_foreground", self.foreground)
        self.dnd_text = config.get("dnd_text", " ")
        self.off_text = config.get("off_text", " ")

    def _configure(self, qtile, bar):
        base.ThreadPoolText._configure(self, qtile, bar)
        self.add_callbacks({"Button1": self.force_update})

    def poll(self):
        cmd = "dunstctl is-paused",
        process = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            shell=True,
        )
        is_dnd = process.stdout.strip()
        if is_dnd == "false":
            output = self.off_text
            self.background = self.off_background
            self.foreground = self.off_foreground
        else:
            output = self.dnd_text
            self.background = self.dnd_background
            self.foreground = self.dnd_foreground
        return output
