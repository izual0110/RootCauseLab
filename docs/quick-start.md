# RootCauseLab Quick Start

## Start a troubleshooting session

```bash
./bin/rcl-start-triage service-slowdown
```

Copy the printed prompt into Codex.

## Expected Codex behavior

Codex should:

- Use prod-triage-agent.
- Start with incident-intake.
- Ask one question at a time.
- Fill session.yaml automatically.
- Ask for one read-only production command at a time.
- Save pasted output under evidence/.
- Update findings.md and timeline.md.
- Produce report.md when the investigation is complete.

## Manual evidence example

```bash
{
  date
  hostname
  uptime
  nproc
} | ./bin/rcl-add-evidence incidents/<incident-id> host-baseline
```

Normally Codex should save evidence itself when operating inside the repository.
