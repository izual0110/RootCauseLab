---
name: fd-leak-triage
description: Read-only production triage workflow for suspected file descriptor leaks.
---

# FD Leak Triage

Use this skill when a process has too many open file descriptors, too many sockets, or errors like "Too many open files".

## Safety

Only read /proc and lsof output.
Do not kill, restart, truncate, or modify anything.

## Step 1: find top processes by FD count

Ask:

```bash
for p in /proc/[0-9]*; do pid=${p##*/}; n=$(ls "$p/fd" 2>/dev/null | wc -l); [ "$n" -gt 1000 ] && printf "%7d pid=%-7s cmd=%s\n" "$n" "$pid" "$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)"; done | sort -nr | head -50
```

Persist suspicious PID in session.yaml.

## Step 2: classify descriptor types for target PID

Ask:

```bash
sudo lsof -nP -p <PID> 2>/dev/null | awk 'NR>1{c[$5]++} END{for (k in c) print c[k], k}' | sort -nr
```

Interpretation:

- many REG: likely file leak
- many IPv4 / IPv6: likely TCP/UDP socket leak
- many unix: local IPC / sidecar / docker / systemd / JVM attach
- many PIPE / FIFO: subprocess or pipe leak

## Step 3: inspect socket descriptors

Ask:

```bash
sudo lsof -nP -p <PID> 2>/dev/null | awk '$5 ~ /IPv4|IPv6|unix/ {print}' | head -200
```

## Step 4: inspect file descriptors

Ask:

```bash
sudo lsof -nP -p <PID> 2>/dev/null | awk '$5=="REG" || $5=="DIR" || $5=="CHR" {print}' | head -200
```

## Step 5: inspect proc targets

Ask:

```bash
ls -l /proc/<PID>/fd 2>/dev/null | head -200
```

## Output format

After every step:

- Recorded
- Observation
- Interpretation
- Next step
