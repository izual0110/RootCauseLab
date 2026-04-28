```bash
bpftrace --info
bpftrace -e 'BEGIN { printf("hello from eBPF lab\n"); exit(); }'
```
