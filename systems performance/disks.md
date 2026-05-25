# Disks System Observability

1. iostat - Disk I/O stats
> `iostat 1 10` - `1` second interval, `10` iterations
>
> `iostat -sxz 1` - `1` second interval, `s` - tight output, `x` - extended stats, `z` - skip stats with zero values
>
> look at `%await`
2. sar - System activity report
> `sar -d 1` - `1` second interval, `d` disk stats
3. PSI - Pressure Stall Information
> `cat /proc/pressure/io` - saturation
4. pidstat - Process stats
> `pidstat -d 1` - `d` disks, `1` second interval
5. perf
> `perf list 'block:*'` - list block events
```bash
# perf record -e block:block_rq_issue -a -g sleep 10
# perf script --header
```

```bash
# perf record -e block:block_rq_issue,block:block_rq_complete -a sleep 60
# perf script --header
```
6. biolatency-bpfcc - Block I/O latency
> `biolatency-bpfcc -Fm 10 1` - `10` second interval, `1` second sleep, `F` split by flag, `m` time in milliseconds
7. biosnoop-bpfcc - Block I/O snooping
```bash
# biosnoop-bpfcc > output.txt
# sort -n -k 8,8 output.txt | tail -5
### check operations before huge latency ->
# vi output.txt 
```
> `biosnoop-bpfcc -Q` `Q` - queues
8. iotop - Disk I/O stats
9. biotop-bpfcc - Block I/O stats
10. biostacks-bpfcc - Block I/O stacks
> `biostacks.bt` - show histogram of block I/O stacks with latencies in milliseconds
11. blktrace - trace driver of blocking devices
> `blktrace -d <device>` - trace `device`
12. bpftrace
> `bpftrace -e 'tracepoint:block:* {@[probe]=count();}'`
13. smartctl - S.M.A.R.T. monitoring
14. enable logging for scsi
```bash
# sysctl -w dev.scsi.logging_level=03333333333
# echo 03333333333 > /proc/sys/dev/scsi/logging_level
# dmesg
```
