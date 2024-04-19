
import importlib

c = get_config()  # NOQA
# The name or class of a Pygments style to use for syntax
#          highlighting. To see available styles, run `pygmentize -L styles`.
#  Default: traitlets.Undefined
c.TerminalInteractiveShell.highlighting_style = 'monokai'
# Use 24bit colors instead of 256 colors in prompt highlighting.
#          If your terminal supports true color, the following command should
#          print ``TRUECOLOR`` in orange::
#
#              printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
#  Default: False
c.TerminalInteractiveShell.true_color = True

# Enable rich if installed
if importlib.util.find_spec('rich'):
    c.InteractiveShellApp.extensions.append('rich')

# Enable autoreload
c.InteractiveShellApp.extensions.append('autoreload')
c.InteractiveShellApp.exec_lines = ['%autoreload 2']

