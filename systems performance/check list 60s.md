| Command | Description | Params |
|---|---|---|
| `uptime` | System uptime and load. | — |
| `dmesg -T \| tail` | Latest kernel logs. | `-T`: readable time |
| `vmstat -SM 1` | CPU/memory/I/O stats. | `-S M`: MB, `1`: interval |
| `mpstat -P ALL 1` | Per-CPU usage. | `-P ALL`: all CPUs, `1`: interval |
| `pidstat 1` | Per-process stats. | `1`: interval |
| `iostat -sxz 1` | Disk I/O stats. | `-s`: summary, `-x`: extended, `-z`: hide idle |
| `free -m` | Memory usage. | `-m`: MB |
| `sar -n DEV 1` | Network interface stats. | `-n DEV`: devices, `1`: interval |
| `sar -n TCP,ETCP 1` | TCP stats/errors. | `-n TCP,ETCP`: TCP metrics, `1`: interval |
| `top` | Live process view. | — |