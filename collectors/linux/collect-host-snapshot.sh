#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${1:-rootcauselab-host-snapshot-$(date +%Y%m%d-%H%M%S)}"

mkdir -p "$OUT_DIR"

echo "[RootCauseLab] Collecting read-only host snapshot into: $OUT_DIR"

{
  echo "date: $(date)"
  echo "hostname: $(hostname)"
  echo "user: $(whoami)"
  echo "kernel: $(uname -a)"
} > "$OUT_DIR/identity.txt" 2>&1 || true

{
  uptime
  echo
  nproc
} > "$OUT_DIR/uptime-nproc.txt" 2>&1 || true

ps -eo pid,ppid,user,stat,pcpu,pmem,etime,args --sort=-pcpu \
  | head -50 > "$OUT_DIR/ps-top-cpu.txt" 2>&1 || true

ps -eo pid,ppid,user,stat,pcpu,pmem,etime,args --sort=-pmem \
  | head -50 > "$OUT_DIR/ps-top-mem.txt" 2>&1 || true

top -b -n1 > "$OUT_DIR/top.txt" 2>&1 || true

vmstat 1 5 > "$OUT_DIR/vmstat.txt" 2>&1 || true

free -m > "$OUT_DIR/free-m.txt" 2>&1 || true

df -h > "$OUT_DIR/df-h.txt" 2>&1 || true

if command -v iostat >/dev/null 2>&1; then
  iostat -xz 1 3 > "$OUT_DIR/iostat-xz.txt" 2>&1 || true
else
  echo "iostat not found" > "$OUT_DIR/iostat-xz.txt"
fi

if command -v mpstat >/dev/null 2>&1; then
  mpstat 1 3 > "$OUT_DIR/mpstat.txt" 2>&1 || true
else
  echo "mpstat not found" > "$OUT_DIR/mpstat.txt"
fi

ss -tanp > "$OUT_DIR/ss-tanp.txt" 2>&1 || true

echo "[RootCauseLab] Done."
echo "$OUT_DIR"
