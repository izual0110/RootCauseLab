FROM ubuntu:24.04
#           ^ colima dependency 

RUN apt-get update && apt-get install -y \
    git \
    # for mpstat ->
    sysstat \ 
    bpftrace \
    # for usdt test
    openjdk-25-jdk \ 
    # perf
    linux-tools-$(uname -r) \
    # tcptop-bpfcc
    # profile-bpfcc
    bpfcc-tools \
    # for profile-bpfcc
    # for syscount-bpfcc
    linux-headers-$(uname -r) \
    auditd \
    strace \
    fatrace \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/brendangregg/FlameGraph.git

CMD ["bash"]
# ENTRYPOINT ["bash"]