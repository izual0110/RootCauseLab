# examples for ftrace

```bash
# cd /sys/kernel/debug/tracing/
# echo 'tcp*' > set_ftrace_filter
# echo 1 > function_profile_enabled
# sleep 10
# echo 0 > function_profile_enabled
# echo > set_ftrace_filter
```

```bash
# cd /sys/kernel/debug/tracing/
# echo '*sleep' > set_ftrace_filter
# echo function > current_tracer
# cat trace_pipe
# echo nop > current_tracer
# echo > set_ftrace_filter
```

```bash
# cd /sys/kernel/debug/tracing/
# echo 'p:m do_nanosleep' >> kprobe_events
# echo 1 > events/kprobes/m/enable
# cat trace_pipe
# echo 0 > events/kprobes/m/enable
# echo '-:m' >> kprobe_events
```

```bash
# cd /sys/kernel/debug/tracing/
# echo 'hist:key=common_pid' > events/raw_syscalls/sys_enter/trigger
# sleep 10
# cat events/raw_syscalls/sys_enter/hist
# echo '!hist:key=common_pid' > events/raw_syscalls/sys_enter/trigger
```
