# CPU Observability 

1. `uptime` — Shows system uptime and load averages.
2. `vmstat` — Shows CPU, memory, swap, and I/O stats.
3. `mpstat` — Shows per-CPU usage statistics.
4. `sar <PID>` — Shows historical system activity stats.
5. `ps` — Lists running processes.
> `ps aux` Shows all processes with user, CPU, memory, and command details.
6. `top` — Shows live process and CPU/memory usage.
7. `pidstat` — Shows per-process CPU, memory, and I/O stats.
8. `time` — Measures command execution time.
9. `turbostat` — Shows CPU frequency, power, and C-state stats. (only for x86)
10. `showboost` — Shows CPU turbo/boost behavior. (only for x86)
11. `pmcarch` — Shows CPU performance counter architecture info. (https://github.com/brendangregg/pmc-cloud-tools.git)
12. `tlbstat` — Shows TLB activity and TLB miss statistics. (https://github.com/brendangregg/pmc-cloud-tools.git)
13. `perf` — Profiles CPU events and kernel/user activity.
14. `profile (profile-bpfcc)` — Samples stack traces for profiling.
15. `cpudist (cpudist-bpfcc)` — Shows CPU time distribution as a histogram.
16. `runqlat (runqlat-bpfcc)` — Shows scheduler run queue latency.
17. `runqlen (runqlen-bpfcc)` — Shows scheduler run queue length.
18. `softirqs (softirqs-bpfcc)` — Shows software interrupt activity.
19. `hardirqs (hardirqs-bpfcc)` — Shows hardware interrupt activity.
20. `bpftrace` — Runs eBPF tracing scripts.