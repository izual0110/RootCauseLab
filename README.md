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
docker build -t debug-image . && docker run --privileged -it -v /sys:/sys debug-image
```

```bash
cd sandboxes/debug-image
docker build -t debug-image . 
docker run --rm -it --privileged --pid=container:<TARGET_CONTAINER> -v /sys:/sys debug-image
```

run Java debug-image (JDK 27, JOL built from source, async-profiler, and jfr-merger)

```bash
cd sandboxes/java-debug-image
docker compose up -d --build
docker compose exec java-debug bash
```

jfr-merger UI: http://localhost:8080/index.html. See [Java debug-image documentation](sandboxes/java-debug-image/README.md) for CLI examples and attaching to another container's JVM.
