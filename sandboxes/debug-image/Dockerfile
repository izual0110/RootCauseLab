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
    linux-headers-6.8.0-100 \
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
# ENTRYPOINT ["bash"]