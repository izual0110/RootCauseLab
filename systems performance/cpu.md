# CPU Observability 

1. `uptime` — Shows system uptime and load averages.
2. `vmstat` — Shows CPU, memory, swap, and I/O stats.
3. `mpstat` — Shows per-CPU usage statistics.
4. `sar <PID>` — Shows historical system activity stats.
5. `ps` — Lists running processes.
> `ps aux` Shows all processes with user, CPU, memory, and command details.
>
> `ps -ef` Shows all processes in full-format output.
6. `top` — Shows live process and CPU/memory usage.
7. `pidstat <PID>` — Shows per-process CPU, memory, and I/O stats.
> `pidstat -t -p ALL` - `t`: threads, `-p`: processes
8. `time` — Measures command execution time.
9. `turbostat` — Shows CPU frequency, power, and C-state stats. (only for x86, MSR)
10. `showboost` — Shows CPU turbo/boost behavior. (only for x86, MSR)
11. `pmcarch` — Shows CPU performance counter architecture info. (https://github.com/brendangregg/pmc-cloud-tools.git)
12. `tlbstat` — Shows TLB activity and TLB miss statistics. (https://github.com/brendangregg/pmc-cloud-tools.git)
13. `perf` — Profiles CPU events and kernel/user activity.
> `perf record -F 99 <command>`
>
> `perf record -F 99 -a -g -- sleep 10` - profile whole system
>
> `perf record -e sched:sched_process_exec -a` - profile new processes through `exec`
>
> results >> `perf report -n --stdio` || `perf script --header`
>
> `perf stat -e LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches <command>` - stats for CPU L3 cache
>
> `perf stat -e sched:sched_switch -a -I 1000` - stats for context switching
>
> `perf stat -e sched:sched_switch --filter 'prev_state == 0' -a -I 1000` - stats for context switching + filer prev_state = task_running
>
> `perf sched record -- sleep 10` - register system scheduler and `perf sched latency` + `perf sched timehist` print stats
>
```bash
# git clone https://github.com/brendangregg/FlameGraph.git; cd FlameGraph
# perf record -F 99 -a -g -- sleep 10
# perf script > out.perf
# ./stackcollapse-perf.pl out.perf > out.folded
# ./flamegraph.pl out.folded > out.svg
```


14. `profile (profile-bpfcc)` — Samples stack traces for profiling.
15. `cpudist (cpudist-bpfcc)` — Shows CPU time distribution as a histogram.
16. `runqlat (runqlat-bpfcc)` — Shows scheduler run queue latency.
17. `runqlen (runqlen-bpfcc)` — Shows scheduler run queue length.
18. `softirqs (softirqs-bpfcc)` — Shows software interrupt activity.
19. `hardirqs (hardirqs-bpfcc)` — Shows hardware interrupt activity.
20. `bpftrace` — Runs eBPF tracing scripts.