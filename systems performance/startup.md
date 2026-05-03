A short tool for checking Linux boot time and systemd service startup delays.

```bash
systemd-analyze
```

Shows total boot time: firmware, bootloader, kernel, and userspace.

```bash
systemd-analyze critical-chain
```

Shows the critical chain of services that had the biggest impact on boot time.
