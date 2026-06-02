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
9. tcplife
10. tcptop
11. tcpetrans
12. bpftrace
13. tcpdump
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
