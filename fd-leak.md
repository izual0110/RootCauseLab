# fd-leak-one-liners.md

Quick cheat sheet for cases where some process has consumed tens of thousands of file descriptors and you need to quickly answer:

- who is responsible;
- what is open;
- whether they are files or sockets;
- where those descriptors point.

## 1. Top processes by FD count

Shows processes with the highest number of open file descriptors.

```bash
for p in /proc/[0-9]*; do pid=${p##*/}; n=$(ls "$p/fd" 2>/dev/null | wc -l); [ "$n" -gt 1000 ] && printf "%7d pid=%-7s cmd=%s\n" "$n" "$pid" "$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)"; done | sort -nr | head -50
```

## 2. Top processes by descriptor type

Quickly shows who is holding `REG`, `IPv4`, `IPv6`, `unix`, and so on.

```bash
sudo lsof -nP 2>/dev/null | awk 'NR>1{c[$1" pid=" $2" type=" $5]++} END{for (k in c) print c[k], k}' | sort -nr | head -100
```

Where:
- `REG` = regular files
- `DIR` = directories
- `CHR` = character devices
- `IPv4` / `IPv6` = network sockets
- `unix` = Unix domain sockets
- `FIFO` / `PIPE` = pipes

## 3. Top processes without type breakdown

Useful when you just want the main offender immediately.

```bash
sudo lsof -nP 2>/dev/null | awk 'NR>1{c[$1" pid=" $2]++} END{for (k in c) print c[k], k}' | sort -nr | head -50
```

## 4. Type summary for a specific PID

After finding the suspicious process, this shows what exactly it is holding.

```bash
sudo lsof -nP -p $PID 2>/dev/null | awk 'NR>1{c[$5]++} END{for (k in c) print c[k], k}' | sort -nr
```

Typical interpretation:
- many `REG` → likely file leak
- many `IPv4` / `IPv6` → likely TCP/UDP socket leak
- many `unix` → local IPC / sidecar / docker / systemd / JVM attach
- many `PIPE` / `FIFO` → pipes / subprocess leak

## 5. Files only for a specific PID

```bash
sudo lsof -nP -p $PID 2>/dev/null | awk '$5=="REG" || $5=="DIR" || $5=="CHR" {print}'
```

## 6. Sockets only for a specific PID

```bash
sudo lsof -nP -p $PID 2>/dev/null | awk '$5 ~ /IPv4|IPv6|unix/ {print}'
```

## 7. All FDs for a process with targets

Useful when you want the real `/proc` symlink targets.

```bash
ls -l /proc/$PID/fd 2>/dev/null
```

## 8. Sockets only via /proc

```bash
find /proc/$PID/fd -lname 'socket:*' -printf '%f -> %l\n' 2>/dev/null | head
```

## 9. Best incident-response one-liner

Usually the most useful first command during an active incident.

```bash
sudo lsof -nP 2>/dev/null | awk 'NR>1{c[$1" pid=" $2" user=" $3" type=" $5]++} END{for (k in c) print c[k], k}' | sort -nr | head -100
```

## 10. Drill into one PID manually

When the PID is already known and you want full detail.

```bash
sudo lsof -nP -p $PID 2>/dev/null | less
```

## 11. What it usually means

- Many `REG` → logs, temp files, DB files, JARs, mmap/open without close
- Many `IPv4` / `IPv6` → leaked client or server sockets, pool/keepalive issues
- Many `unix` → local sockets between services or system components
- Many `PIPE` → child processes, shell pipelines, subprocess misuse

