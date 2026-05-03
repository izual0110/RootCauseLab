FROM ubuntu:26.04

RUN apt-get update && apt-get install -y \
    # for mpstat ->
    sysstat \ 
    bpftrace \
    # for usdt test
    openjdk-25-jdk \ 
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
# ENTRYPOINT ["bash"]