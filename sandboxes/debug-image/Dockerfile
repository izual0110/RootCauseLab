FROM ubuntu:26.04

RUN apt-get update && apt-get install -y \
    # for mpstat ->
    sysstat \ 
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
# ENTRYPOINT ["bash"]