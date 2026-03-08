FROM quay.io/fedora/fedora-minimal:43

RUN microdnf -y update \
    && microdnf -y install \
        ca-certificates \
        curl \
        gzip \
        nodejs \
        npm \
        python3 \
        python3-pip \
        tar \
    && microdnf clean all

RUN set -eux; \
    curl -fsSL "https://corretto.aws/downloads/latest/amazon-corretto-25-x64-linux-jdk.tar.gz" -o /tmp/corretto.tar.gz; \
    mkdir -p /opt; \
    tar -xzf /tmp/corretto.tar.gz -C /opt; \
    rm -f /tmp/corretto.tar.gz; \
    ln -s /opt/amazon-corretto-25* /opt/amazon-corretto-25

ENV JAVA_HOME=/opt/amazon-corretto-25
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN npm i -g @openai/codex \
    && npm cache clean --force

WORKDIR /work

ENTRYPOINT ["codex"]
