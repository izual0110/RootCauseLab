bpftrace -e 'uprobe:/bin/bash:decode_prompt_string {printf("%s\n", str(arg0));}'

bpftrace -lv 'usdt:/usr/lib/jvm/java-25-openjdk-arm64/lib/server/libjvm.so:*'
