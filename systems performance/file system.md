# File System Observability 

1. mount - shows and attaches filesystems
> relatime - improves performance, updates last read rarely
>
> noatime - improves performance, disable updating last read
2. free - shows RAM and swap usage
> `free -mw` look at buff and cache. buff - data from device, cache - page cache
3. top
4. vmstat - shows CPU, memory, swap, paging, I/O, and scheduler pressure.
> `vmstat 1` - `1` - interval, looks at buff, cache
5. sar
> `sar -v 1` - `1` - interval, reports kernel table usage: file handles, inode cache, dentry cache, and pseudo-terminal usage.
6. slabtop - shows kernel slab cache usage and kernel object memory.
> `slabtop -o` - `o` - once
7. strace - traces system calls made by a process.
> `strace -ttT -p <PID>`
8. fatrace - shows which processes access files in real time
9. latencytop - deprecated
10. opensnoop (opensnoop-bpfcc) - traces file open attempts system-wide using eBPF/BCC
> `opensnoop-bpfcc -T` - `T` prints time
11. filetop (filetop-bpfcc) - shows the busiest files by read/write activity.
> `filetop-bpfcc -a -C` - `a` - all, shows sockets+other, `C - don't clear screen 
12. cachestat (cachestat-bpfcc) - shows Linux page cache hit/miss behavior.
> `cachestat-bpfcc -T 1` - `T` - time, `1` - interval
13. ext4dist (xfs,zfs,btrfs,nfs) - tracing operations by latency
> `ext4dist-bpfcc 10 1` - `10` - dalay, `1` - count
14. ext4slower (xfs,zfs,btrfs,nfs) - tracing slow operations 
> `ext4slower-bpfcc 10` - `10` -  tracing ext4 operations slower than 10 ms
15. bpftrace
> `bpftrace -e 'tracepoint:syscalls:sys_enter_*read* { @[probe] = count();}'` - trace reads
> `bpftrace -e 'tracepoint:syscalls:sys_enter_*write* { @[probe] = count();}'` - trace writes
> `bpftrace -e 'tracepoint:syscalls:sys_enter_read { @ = hist(args->count);}'` - histo
> `bpftrace -e 't:syscalls:sys_enter_openat {printf("%s %s\n", comm, str(args->filename));}'` - print process and opened file