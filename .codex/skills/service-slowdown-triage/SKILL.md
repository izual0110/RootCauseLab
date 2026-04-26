---
name: service-slowdown-triage
description: Read-only production triage workflow for slow Java/Kotlin services.
---

# Service Slowdown Triage

Use this skill when a production service is slow, timing out, overloaded, or showing degraded latency.

## Operating model

Codex does not access production directly.

The human operator runs read-only commands on the production host and pastes the output back.

Codex must save output under evidence/ and update session.yaml, findings.md, and timeline.md.

## Step 1: host baseline

Ask:

```bash
date; hostname; uptime; nproc
```

Interpretation:

- high load relative to CPU count suggests host saturation
- recent boot may indicate restart/failover
- hostname mismatch means stop and clarify

## Step 2: process baseline

Ask:

```bash
ps -eo pid,ppid,user,stat,pcpu,pmem,etime,args --sort=-pcpu | head -30
```

Interpretation:

- Java process high CPU: continue to JVM CPU branch
- many unrelated processes high CPU: host-level contention
- low CPU but service slow: check IO, locks, network, dependency latency

## Step 3: CPU, memory, IO snapshot

Ask:

```bash
vmstat 1 5
```

Interpretation:

- high r: runnable CPU pressure
- high b: blocked processes or IO pressure
- swap in/out: memory pressure
- high wa: IO wait
- high sy: kernel/system overhead

## Step 4: memory and disk

Ask:

```bash
free -m; df -h
```

Interpretation:

- low available memory plus swap activity: memory pressure
- disk near 100%: urgent operational risk
- full log partition can cause service degradation

## Step 5: JVM process identity

Ask:

```bash
jcmd
```

Then identify the target JVM PID and persist it.

## Step 6: JVM quick diagnostics

Ask:

```bash
jcmd <PID> VM.command_line
jcmd <PID> VM.flags
jcmd <PID> GC.heap_info
```

Interpretation:

- heap close to max: possible GC/memory pressure
- unexpected JVM flags: possible configuration issue
- wrong command line: wrong process selected

## Step 7: thread state sample

Ask:

```bash
jcmd <PID> Thread.print -l | head -300
```

Interpretation:

- many BLOCKED threads: lock contention
- many RUNNABLE same stack: CPU hot path
- many WAITING on connection pool: dependency or pool exhaustion
- many parked worker threads with low load: bottleneck may be outside JVM

## Branching

If high CPU:

- request repeated thread dumps
- identify repeated RUNNABLE stacks
- classify hot path

If GC pressure:

- inspect GC.heap_info
- request GC logs if available
- classify allocation pressure vs old-gen pressure

If IO wait:

- request iostat if available
- check disk fullness and log volume

If dependency latency:

- inspect thread dumps for client calls
- inspect recent logs for timeout keywords
- inspect socket states with ss

If FD leak suspected:

- switch to fd-leak-triage

## Output format

After every step:

- Recorded
- Observation
- Interpretation
- Next step
