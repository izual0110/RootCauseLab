FROM quay.io/fedora/fedora-minimal:44

ARG CLOJURE_VERSION=1.12.6.1673

RUN dnf install -y \
      curl \
      docker-cli \
      docker-compose \
      findutils \
      git \
      gzip \
      java-27-openjdk-devel \
      rlwrap \
      tar \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && git config --global --add safe.directory /workspace/RootCauseLab

WORKDIR /workspace/RootCauseLab

CMD ["sleep", "infinity"]
