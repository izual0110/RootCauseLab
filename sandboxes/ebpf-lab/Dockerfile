FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    bpftrace \
    bpfcc-tools \
    bpftool \
    clang \
    llvm \
    make \
    gcc \
    git \
    pkg-config \
    libelf-dev \
    zlib1g-dev \
    ca-certificates \
    curl \
    vim \
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
# ENTRYPOINT ["bash"]