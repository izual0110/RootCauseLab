# syntax=docker/dockerfile:1
ARG BASE_IMAGE=quay.io/fedora/fedora-minimal:44

FROM ${BASE_IMAGE} AS base
RUN dnf install -y java-27-openjdk-devel ca-certificates curl tar gzip \
    && dnf clean all

FROM base AS jol-builder
ARG JOL_REF=db2cc744485031c8149991a004ab02f2ea9b24dd
RUN dnf install -y git maven && dnf clean all
WORKDIR /src/jol
RUN git init . \
    && git remote add origin https://github.com/openjdk/jol.git \
    && git fetch --depth=1 origin "${JOL_REF}" \
    && git checkout --detach FETCH_HEAD \
    && mvn -B -ntp -pl jol-cli -am -DskipTests clean package

FROM base AS merger-builder
ARG JFR_MERGER_REF=6c8f5c0fdb838e865ed0ae6824b9396d685da10a
ARG CLOJURE_VERSION=1.12.6.1673
RUN dnf install -y git && dnf clean all
WORKDIR /tmp/clojure
RUN curl -fSL --retry 3 -o linux-install.sh \
        "https://github.com/clojure/brew-install/releases/download/${CLOJURE_VERSION}/linux-install.sh" \
    && bash linux-install.sh --prefix /usr/local \
    && rm -rf /tmp/clojure
WORKDIR /src/jfr-merger
RUN git init . \
    && git remote add origin https://github.com/izual0110/jfr-merger.git \
    && git fetch --depth=1 origin "${JFR_MERGER_REF}" \
    && git checkout --detach FETCH_HEAD \
    && clojure -T:build uber \
    && mkdir -p /out \
    && cp target/jfr-merger-*.jar /out/jfr-merger.jar

FROM base AS profiler
ARG TARGETARCH
ARG ASYNC_PROFILER_VERSION=4.5
ARG ASYNC_PROFILER_X64_SHA256=89546fbb9ee0fc5496c7edd4099b0709489bc78b0d8057ccbb4b801f6b032b62
ARG ASYNC_PROFILER_ARM64_SHA256=64c41d1465d60097439c50d7e924b4946f1f62b1cbd21ce5b034fad09c0d6979
ARG JFR_CONVERTER_SHA256=41a3b07cd73a8f800814856a622449530f645662d5b274fbd040f1a82b032aee
RUN case "${TARGETARCH}" in \
        amd64) arch=x64; checksum="${ASYNC_PROFILER_X64_SHA256}" ;; \
        arm64) arch=arm64; checksum="${ASYNC_PROFILER_ARM64_SHA256}" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && mkdir -p /opt/async-profiler \
    && curl -fSL --retry 3 -o /tmp/async-profiler.tar.gz \
        "https://github.com/async-profiler/async-profiler/releases/download/v${ASYNC_PROFILER_VERSION}/async-profiler-${ASYNC_PROFILER_VERSION}-linux-${arch}.tar.gz" \
    && echo "${checksum}  /tmp/async-profiler.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/async-profiler.tar.gz --strip-components=1 -C /opt/async-profiler \
    && curl -fSL --retry 3 -o /opt/async-profiler/lib/jfr-converter.jar \
        "https://github.com/async-profiler/async-profiler/releases/download/v${ASYNC_PROFILER_VERSION}/jfr-converter.jar" \
    && echo "${JFR_CONVERTER_SHA256}  /opt/async-profiler/lib/jfr-converter.jar" | sha256sum -c - \
    && rm /tmp/async-profiler.tar.gz

FROM base AS runtime
RUN dnf install -y bash procps-ng iproute lsof strace jq less findutils \
        file binutils unzip \
    && dnf clean all \
    && mkdir -p /opt/jol /opt/jfr-merger /data/storage/jfrs /data/storage/temp
COPY --from=jol-builder /src/jol/jol-cli/target/jol-cli.jar /opt/jol/jol-cli.jar
COPY --from=merger-builder /out/jfr-merger.jar /opt/jfr-merger/jfr-merger.jar
COPY --from=profiler /opt/async-profiler /opt/async-profiler
COPY --chmod=755 jol jfr-converter /usr/local/bin/
ENV PATH="/opt/async-profiler/bin:${PATH}"
WORKDIR /data
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8080/index.html > /dev/null || exit 1
CMD ["java", "--enable-native-access=ALL-UNNAMED", "-jar", "/opt/jfr-merger/jfr-merger.jar"]
