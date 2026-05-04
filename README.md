RootCauseLab is a safe, guided production diagnostics toolkit for investigating degraded services and collecting evidence toward a likely root cause.


run sendboxed codex

```bash

CODEX_WORKDIR="$PWD" docker-compose -f .../RootCauseLab/sandboxes/compose.yaml run --rm --build codex
```

run ebpf-lab

```bash
cd sandboxes/ebpf-lab
docker-compose run ebpf-lab
```

run debug-image
```bash
cd sandboxes/debug-image
docker build -t debug-image . && docker run --privileged -it -v /sys:/sys -v /lib/modules:/lib/modules:ro debug-image
```
