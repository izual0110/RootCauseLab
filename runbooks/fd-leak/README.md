# FD Leak Runbook

This runbook helps identify processes with high file descriptor counts and classify descriptor types.

Common interpretations:

- many REG: regular file leak
- many IPv4 / IPv6: socket leak
- many unix: Unix domain socket / IPC issue
- many PIPE / FIFO: subprocess or pipe leak
- many deleted files: log rotation or file lifecycle issue

Start with the fd-leak-triage skill.
