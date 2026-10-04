# Java debug-image

Отдельный Linux-образ для диагностики JVM и анализа JFR/heap dump. Существующий `../debug-image` не меняется.

## Состав

- **OpenJDK 27 JDK** — последний стабильный Java на момент добавления образа (не early access): `java`, `javac`, `jcmd`, `jstack`, `jmap`, `jstat`, `jps`, `jfr`, `jhsdb`.
- **[JOL](https://github.com/openjdk/jol)** — CLI собирается Maven из исходников; команда `jol`.
- **[jfr-merger](https://github.com/izual0110/jfr-merger)** — собирается в uberjar и запускается по умолчанию на порту 8080.
- **[async-profiler 4.5](https://github.com/async-profiler/async-profiler)** — `asprof`, `jfrconv`, отдельная команда `jfr-converter` для конвертации JFR в flamegraph/heatmap.
- `ps`, `top`, `ss`, `ip`, `lsof`, `strace`, `curl`, `jq`, `less`, `file`, `binutils`, `unzip`.

База — Fedora 44; целевые архитектуры — `linux/amd64` и `linux/arm64`. Пакеты обновляются из репозитория Fedora при сборке; major-версия Java закреплена на 27, а не на плавающем `latest`/EA. JOL и jfr-merger закреплены на commit SHA в Dockerfile. Maven, Clojure CLI и исходники остаются в build stages, не в конечном образе. Архивы async-profiler и converter проверяются по SHA-256.

## Запуск

Из этой директории:

```bash
docker compose up -d --build
docker compose logs -f java-debug
docker compose exec java-debug bash
```

UI: http://localhost:8080/index.html. Проверка доступности сервиса встроена в `HEALTHCHECK`.

Данные RocksDB и временные файлы сохраняются в named volume `java-debug-data`, в `/data/storage`. Чтобы передать файл для CLI-анализа:

```bash
docker compose cp ./capture.jfr java-debug:/data/capture.jfr
docker compose exec java-debug jfr summary /data/capture.jfr
```

Можно загрузить `.jfr`/`.hprof` через веб-интерфейс. Не публикуйте сервис в интернете: JFR и heap dump содержат чувствительные данные, а API включает операции с локальными файлами и удаление данных. Compose публикует порт только на `127.0.0.1`.

Без Compose:

```bash
docker build -t java-debug-image .
docker run --rm --init --name java-debug \
  -p 127.0.0.1:8080:8080 \
  -v java-debug-data:/data \
  java-debug-image
```

Отдельная интерактивная CLI-сессия **без запуска jfr-merger**:

```bash
docker run --rm --init -it -v java-debug-data:/data java-debug-image bash
```

Память Java можно ограничить, например, через `-e JAVA_TOOL_OPTIONS=-Xmx4g`. Эта переменная действует на все Java-команды в контейнере; heap-анализ может требовать больше памяти. Общий лимит памяти контейнера должен оставлять запас для native memory/RocksDB.

## CLI-примеры

PID `1234` ниже — пример: замените его PID целевой JVM.

### Встроенные инструменты JDK

```bash
jcmd -l
jcmd 1234 VM.version
jcmd 1234 VM.flags
jcmd 1234 Thread.print -l
jcmd 1234 GC.class_histogram
jstat -gcutil 1234 1000 10

jcmd 1234 JFR.start name=debug settings=profile duration=60s filename=/data/profile.jfr
jfr summary /data/profile.jfr
jfr print --events jdk.CPULoad,jdk.GarbageCollection /data/profile.jfr

jcmd 1234 GC.heap_dump /data/heap.hprof
```

`GC.class_histogram` и `GC.heap_dump` могут вызвать заметную паузу и/или GC. Сначала оцените допустимое влияние на production. Запись JFR появляется после завершения записи; `filename` и путь heap dump относятся к файловой системе **целевой JVM**, не debug-контейнера.

### JOL

```bash
jol help
jol internals java.util.HashMap
jol estimates java.util.HashMap
jol heapdump-stats /data/heap.hprof
jol heapdump-estimates /data/heap.hprof
jol heapdump-duplicates /data/heap.hprof
jol heapdump-strings /data/heap.hprof.gz
```

JOL анализирует уже снятый heap dump. `internals` показывает layout объектов своей JVM, а не удалённого процесса; размеры из heap dump могут зависеть от модели JVM, используемой для анализа. Для собственных классов: `jol internals -cp /data/app.jar com.example.MyClass`.

### async-profiler и JFR converter

```bash
asprof -e cpu -d 30 -f /data/cpu.jfr 1234
asprof -e alloc -d 30 -f /data/alloc.jfr 1234
asprof -e wall -d 30 -f /data/wall.html 1234

jfr-converter --cpu -o html /data/cpu.jfr /data/cpu.html
jfr-converter --alloc -o html /data/alloc.jfr /data/alloc.html
jfrconv --cpu -o html /data/cpu.jfr /data/cpu-via-jfrconv.html
```

Если perf events недоступны, можно попробовать `asprof -e ctimer -d 30 -f /data/cpu.jfr 1234`; kernel stacks в таком режиме отсутствуют. Для лучшей детализации профилей целевую JVM желательно запускать с `-XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints`.

## Диагностика JVM другого контейнера

Доступ к PID namespace не означает автоматический доступ к attach socket, файлам или perf events. Для начала используйте JFR/дампы, полученные инструментами самой целевой JVM, либо запускайте инструменты внутри её контейнера.

Пример debug-sidecar (замените `TARGET_CONTAINER` реальным именем):

```bash
docker run --rm --init -it \
  --pid=container:TARGET_CONTAINER \
  --cap-add=SYS_PTRACE \
  java-debug-image bash
```

Особенности:

- Attach требует совместимых UID/GID с целевой JVM. При необходимости добавьте `--user UID:GID`; attach может быть выключен флагом `-XX:+DisableAttachMechanism`.
- JDK attach использует socket в `/tmp` целевой JVM. Для надёжной работы нужен доступ к её mount namespace/`/proc/PID/root/tmp` или заранее организованный общий `/tmp`. Контейнеры с разными UID, user namespace и security policy могут запретить такой доступ.
- `libasyncProfiler.so` должна быть доступна **целевой JVM по пути, переданному при attach**. Только наличия `/opt/async-profiler` в debug-sidecar недостаточно. Организуйте общий mount с библиотекой соответствующей архитектуры; если нужно, передайте `asprof --libpath /shared/libasyncProfiler.so ...`.
- Файлы профилей и дампов пишет целевая JVM. Создайте общий writable volume и используйте в обоих контейнерах один и тот же путь, например `/data`.
- CPU/perf-профилирование зависит от host `perf_event_paranoid`, capabilities и seccomp. `SYS_PTRACE` не даёт автоматически доступ к `perf_event_open`. Ослаблять seccomp/добавлять `PERFMON` следует только при необходимости; `--privileged` по умолчанию не нужен.
- Для attach к старой JVM предпочтительны инструменты той же версии JDK. Особенно `jhsdb`/Serviceability Agent требуют совпадения версии с целевой JVM и могут приостановить процесс. Этот образ предназначен прежде всего для Java 27 и offline-анализа.

Не давайте jfr-merger доступ к файлам production-контейнера без необходимости: используйте отдельную CLI-сессию с командой `bash`, без опубликованного HTTP-порта.

## Обновление исходников

```bash
docker build \
  --build-arg JOL_REF=master \
  --build-arg JFR_MERGER_REF=master \
  -t java-debug-image .
```

Для стабильной повторяемой сборки лучше передавать новые commit SHA. Если собираете движущийся `master`, используйте `--no-cache`: Docker не знает, что удалённая ветка обновилась. При обновлении async-profiler измените версию и соответствующие SHA-256 в Dockerfile. Обновление major Java требует смены пакета JDK в Dockerfile и проверки совместимости инструментов.

## Что ещё стоит добавить при необходимости

| CLI | Для чего | Почему не включён по умолчанию |
| --- | --- | --- |
| [Arthas](https://github.com/alibaba/arthas) | Интерактивные `thread`, `dashboard`, `sc`, `jad`, `watch`, `trace`, `tt` в живой JVM | Динамический attach/инструментация, влияние на приложение; проверить поддержку JDK 27 и не публиковать telnet/HTTP-порты |
| [jattach](https://github.com/apangin/jattach) | Маленький native-клиент attach (`threaddump`, `jcmd`, загрузка агента), полезен в контейнерах | В образе уже есть `jcmd`; права и namespace всё равно нужно учитывать |
| [Eclipse MAT ParseHeapDump.sh](https://eclipse.dev/mat/) | Headless leak suspects, dominator tree, retained heap для HPROF | Существенно тяжелее JOL, большие дампы требуют много RAM; нужен отдельный подходящий headless дистрибутив |
| [GCViewer](https://github.com/chewiebug/GCViewer) | Анализ GC-логов и экспорт summary из командной строки | Полезен при GC-specific расследованиях; проверить поддержку формата логов JDK 27 |
| `gdb` + debug symbols JDK | Native crash, JNI, core dump | Требует symbols соответствующей версии/архитектуры и отдельных прав; `jhsdb` уже есть в JDK |

Практический следующий шаг: **Arthas** для live-диагностики и **MAT** для серьёзного heap/leak-анализа. Для CPU/allocation/JFR базовый набор в образе уже покрывает большинство задач.
