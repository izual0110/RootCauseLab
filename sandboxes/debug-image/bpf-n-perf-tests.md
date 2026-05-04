bpftrace -e 'uprobe:/bin/bash:decode_prompt_string {printf("%s\n", str(arg0));}'

bpftrace -lv 'usdt:/usr/lib/jvm/java-25-openjdk-arm64/lib/server/libjvm.so:*'
bpftrace -e 't:block:block_rq_issue {printf("size: %d bytes\n", args->bytes);}'

perf list tracepoint
perf trace -e block:block_rq_issue
cat /sys/kernel/debug/tracing/events/block/block_rq_issue/format

perf record -F 49 -a -g -- sleep 30
+
perf script

# perf system calls
perf trace -s
# perf sendto
perf trace -e sendto