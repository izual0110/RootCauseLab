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

# 49hz + 10sec
profile-bpfcc -F 49 10

# trace waiting locks/queues for 5sec
offcputime-bpfcc 5

# -ttt — print absolute Unix timestamps with microseconds.
# -T — print time spent inside each syscall.
strace -ttt -T -p <PID>

# trace command "dd"
strace -c dd if=/dev/zero of=/dev/null bs=1k count=500k

# trace new processes
execsnoop-bpfcc

# count of system calls
syscount-bpfcc
# -P - count by pid
syscount-bpfcc -P
