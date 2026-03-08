FROM quay.io/fedora/fedora-minimal:43

RUN microdnf install -y \
      bash \
      ca-certificates \
      bind-utils \
      iptables \
      ipset \
      procps-ng \
      grep \
      findutils \
      coreutils \
      util-linux \
    && microdnf clean all

WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]