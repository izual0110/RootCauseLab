#!/usr/bin/env bash
set -euo pipefail

PID="${1:-}"

OUT_DIR="${2:-rootcauselab-fd-snapshot-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$OUT_DIR"

echo "[RootCauseLab] Collecting read-only FD snapshot into: $OUT_DIR"

{
  for p in /proc/[0-9]*; do
    pid=${p##*/}
    n=$(ls "$p/fd" 2>/dev/null | wc -l)
    if [ "$n" -gt 1000 ]; then
      printf "%7d pid=%-7s cmd=%s\n" "$n" "$pid" "$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)"
    fi
  done | sort -nr | head -50
} > "$OUT_DIR/top-processes-by-fd.txt" 2>&1 || true

if command -v lsof >/dev/null 2>&1; then
  sudo lsof -nP 2>/dev/null \
    | awk 'NR>1{c[$1" pid=" $2" user=" $3" type=" $5]++} END{for (k in c) print c[k], k}' \
    | sort -nr \
    | head -100 > "$OUT_DIR/lsof-type-summary-global.txt" 2>&1 || true
else
  echo "lsof not found" > "$OUT_DIR/lsof-type-summary-global.txt"
fi

if [[ -n "$PID" ]]; then
  ls -l "/proc/$PID/fd" > "$OUT_DIR/proc-fd-${PID}.txt" 2>&1 || true

  if command -v lsof >/dev/null 2>&1; then
    sudo lsof -nP -p "$PID" > "$OUT_DIR/lsof-${PID}.txt" 2>&1 || true
    sudo lsof -nP -p "$PID" 2>/dev/null \
      | awk 'NR>1{c[$5]++} END{for (k in c) print c[k], k}' \
      | sort -nr > "$OUT_DIR/lsof-type-summary-${PID}.txt" 2>&1 || true
  fi
fi

echo "[RootCauseLab] Done."
echo "$OUT_DIR"
