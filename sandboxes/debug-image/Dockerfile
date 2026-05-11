FROM ubuntu:24.04
#           ^ colima dependency 

RUN apt-get update && apt-get install -y \
    # for mpstat ->
    sysstat \ 
    bpftrace \
    # for usdt test
    openjdk-25-jdk \ 
    # perf
    linux-tools-generic \
    # tcptop-bpfcc
    # profile-bpfcc
    bpfcc-tools \
    # for profile-bpfcc
    # for syscount-bpfcc
    linux-headers-$(uname -r) \
    auditd \
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
# ENTRYPOINT ["bash"]