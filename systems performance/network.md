# Network Observability 
1. ss - Socket Statistics
> `ss -tiepm` - `t` - only tcp, `i` - detailed tcp, `e` - extended info about sockets, `p` - show process, `m` - memory usage
>
> rto - Retransmission Timeout, rtt - Round Trip Time, mss - Maximum Segment Size, cwnd - Congestion Window
>
> == `strace -e sendmsg,recvmsg ss -t`
2. ip - Show IP routing information
> `ip -s link` - Show detailed information about network interfaces
>
> `ip route` - Show IP routing table
3. ifconfig - Show network interface configuration (use ip instead of ifconfig)
4. nstat - Show network statistics
> `nstat -s` - `s` - noreset statistics after each run, `-rs` - restore statistics from starting machine
5. netstat - Show network statistics
> `-a` - all sockets
>
> `-s` - network stack
>
> `-i` - interface statistics
>
> `-r` - routing table
6. sar - System Activity Reporter
> `sar -n DEV` - network device statistics, `sar -n EDEV` - error device statistics, `sar -n IP` - IP statistics, `sar -n EIP` - error IP statistics, `sar -n TCP` - TCP statistics, `sar -n ETCP` - error TCP statistics, `sar -n SOCK` - socket statistics
>
> `sar -n TCP 1` - `1` - interval in seconds
7. nicstat - Network Interface Statistics
8. ethtool - Display or change Ethernet device settings
> `ethtool -i eth0` - `i` - show driver info, `eth0` - name of the network interface
9. tcplife-bpfcc - trace TCP connection life cycle
10. tcptop-bpfcc - trace TCP connection top (`-C` no reset screen)
11. tcpretrans-bpfcc - trace TCP retransmissions
12. bpftrace
> `bpftrace -e 't:syscalls:sys_enter_accept* { @[pid,comm] = count();}'` - trace `accept` syscalls
>
> `bpftrace -e 't:syscalls:sys_enter_connect { @[pid,comm] = count();}'` - trace `connect` syscalls
>
> `bpftrace -e 't:syscalls:sys_enter_connect { @[ustack,comm] = count();}'` - trace `connect` syscalls by user stack
```bash
# bpftrace -e 't:sock:inet_sock_set_state /args->newstate == 1 && args->family == 2/ {@[ntop(args->saddr), ntop(args->daddr)] = count();}'
```
13. tcpdump
> `tcpdump -i any -nn -c 1000 -w 1.pcap 'host 10.10.10.10 and port 8080'`
14. wireshark

# Experiments
1. ping
2. traceroute
3. pathchar
4. iperf
5. netperf
6. tc

# setup
1. `sysctl -a | grep tcp`
