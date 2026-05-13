# Memory Observability 

1. vmstat - virtual memory statistics
> `vmstat -Sm 5 1` - `5`: delay, `1`: count, `-Sm` - megabytes instead of kylobytes
>
> si - swap input, so - swap output
2. PSI - Pressure Stall Information
> `cat /proc/pressure/memory`
3. swapon - enable/show swap devices
4. `sar <PID>` — Shows historical system activity stats.
> `sar -B <PID>` - `B` - page activity and reclaim
>
> `sar -H <PID>` - `H` - stats of huge pages
>
> `sar -r <PID>` - `r` - stats of memory
>
> `sar -S <PID>` - `S` - swap capacity usage
>
> `sar -W <PID>` - `W` - swap traffic
5. slabtop - kernel slab cache usage
> `slabtop -sc` - `sc` - sort by cache size
6. numastat - NUMA memory statistics
7. ps - process status
> `ps aux` Shows all processes with user, CPU, memory, and command details.
8. top - real-time process monitor
> `top -o %MEM` - sort by memory
9. pmap - process memory map (heap, stack, libraries, mmap)
> `pmap -x <PID>` - `x` additional fields
> 
> `pmap -X <PID>` - `X` more additional fields
> 
> `pmap -XX <PID>` - `XX` all fields
10. perf
```bash
# git clone https://github.com/brendangregg/FlameGraph.git; cd FlameGraph
# perf record -e page-faults -a -g -- sleep 60
# perf script --header > out.stacks
# ./stackcollapse-perf.pl out.stacks | ./flamegraph.pl --hash --bgcolor=green --count=pages --title="Page Fault Flame Graph" > out.svg
# cat out.svg | gzip | base64
```
11. drsnoop (drsnoop-bpfcc) - direct reclaim snooper
12. wss - working set size (dangerous, huge overhead) 
> https://github.com/brendangregg/wss
13. bpftrace
> `bpftrace -l | grep software` - `l` list
>
> `bpftrace -e 'software:page-faults:1 {@[comm, pid] = count(); }'`
>
```bash
# bpftrace -e 'u:/lib/aarch64-linux-gnu/libc.so.6:malloc /pid == 1/ {@[ustack] = hist(arg0);}' > out.stack`
# ./stackcollapse-perf.pl out.stacks | ./flamegraph.pl --hash --bgcolor=green --count=pages --title="malloc() bytes" > out.svg
# cat out.svg | gzip | base64
```

