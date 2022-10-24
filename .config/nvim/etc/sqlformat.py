import sys
import re
content = sys.stdin.read()
# remove all python string tokens from content
content = re.sub(r"[rf]?([\"']+)(.+)\s?\1", r"\2", content, flags=re.DOTALL)
try:
    import sqlparse

    formatted = sqlparse.format(
        content,
        reindent=True,
        keyword_case="upper",
        indent_after_first=True,
        wrap_after=120,
    )
    print(formatted.strip(), end='')
except Exception:
    print("ERROR", end="")
    exit()
