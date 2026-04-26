#!/usr/bin/env bash
set -euo pipefail

PID="${1:-}"

if [[ -z "$PID" ]]; then
  echo "Usage: $0 <java-pid> [output-dir]"
  echo
  echo "Available JVM processes:"
  jcmd || true
  exit 1
fi

OUT_DIR="${2:-rootcauselab-jvm-snapshot-${PID}-$(date +%Y%m%d-%H%M%S)}"

mkdir -p "$OUT_DIR"

echo "[RootCauseLab] Collecting read-only JVM snapshot for PID=$PID into: $OUT_DIR"

jcmd "$PID" VM.command_line > "$OUT_DIR/vm-command-line.txt" 2>&1 || true
jcmd "$PID" VM.flags > "$OUT_DIR/vm-flags.txt" 2>&1 || true
jcmd "$PID" VM.system_properties > "$OUT_DIR/vm-system-properties.txt" 2>&1 || true
jcmd "$PID" GC.heap_info > "$OUT_DIR/gc-heap-info.txt" 2>&1 || true

for i in 1 2 3; do
  jcmd "$PID" Thread.print -l > "$OUT_DIR/thread-dump-${i}.txt" 2>&1 || true
  sleep 5
done

if command -v jstat >/dev/null 2>&1; then
  jstat -gcutil "$PID" 1000 5 > "$OUT_DIR/jstat-gcutil.txt" 2>&1 || true
else
  echo "jstat not found" > "$OUT_DIR/jstat-gcutil.txt"
fi

echo "[RootCauseLab] Done."
echo "$OUT_DIR"
