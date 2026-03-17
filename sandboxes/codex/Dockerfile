FROM quay.io/fedora/fedora-minimal:43

RUN microdnf -y update \
    && microdnf -y install \
        ca-certificates \
        nodejs \
        npm \
        python3 \
        python3-pip \
    && microdnf -y install \
        https://corretto.aws/downloads/latest/amazon-corretto-26-x64-linux-jdk.rpm \
    && microdnf clean all

RUN npm i -g @openai/codex \
    && npm cache clean --force

WORKDIR /work

ENTRYPOINT ["codex"]
