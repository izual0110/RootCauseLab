---
name: incident-intake
description: Guides the user through the beginning of a troubleshooting session and fills RootCauseLab incident state.
---

# Incident Intake

Use this skill when the user starts a new production troubleshooting session.

The user should not manually edit YAML.

Codex is responsible for:

- asking one question at a time
- extracting structured state from the answer
- updating session.yaml
- appending timeline events
- deciding when intake is complete
- switching to the relevant triage skill

## Required fields

Collect:

- service.name
- service.environment
- service.host, pod, instance, dc, or region if known
- symptom.primary
- symptom.secondary
- symptom.started_at
- symptom.scope
- impact.severity if known
- impact latency/error/rps/queue details if known
- recent_changes
- process.pid if already known

## Intake questions

Ask one question at a time.

1. What service is affected?
2. Where is it affected: one host, one pod, one DC/AZ, or globally?
3. What symptom is visible: high latency, timeouts, errors, CPU, memory, GC, queue lag, FD leak, socket leak, or something else?
4. When did it start?
5. Was there a recent deploy, config change, traffic spike, dependency incident, or infrastructure change?
6. Is there known impact: users affected, error rate, p95/p99 latency, RPS drop, queue lag?
7. Do you already know the PID? If not, collect it later via jcmd or ps.

## Behavior

After each answer:

- update session.yaml
- append a timeline event
- summarize what was recorded
- ask the next question

When enough fields are collected:

- choose the next triage skill
- ask for the first read-only diagnostic command

## Mapping examples

If user says:

"p99 latency and timeouts"

Map:

```yaml
symptom:
  primary: high_latency
  secondary:
    - timeouts
  notes: "p99 latency and timeouts"
```

If user says:

"only sms-dr-processor-17"

Map:

```yaml
symptom:
  scope: single_host
service:
  host: sms-dr-processor-17
```

If user says:

"started 15 minutes ago"

Map to absolute timestamp if current time is known.
If not, preserve the original phrase in symptom.notes.

## Do not

- Do not ask the user to write YAML manually.
- Do not ask multiple questions at once unless the user requested fast mode.
- Do not proceed to destructive actions.
- Do not assume PID without evidence.
