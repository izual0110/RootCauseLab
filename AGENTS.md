# RootCauseLab Codex Instructions

RootCauseLab is a safe production troubleshooting toolkit.

## Core principle

Do not rely on chat context as the source of truth.

Use the incident workspace as canonical memory:

- session.yaml stores current structured state
- evidence/ stores raw production command outputs
- findings.md stores interpretations and hypotheses
- timeline.md stores chronological events
- report.md stores the final incident report

## User experience

The user should not manually edit YAML during normal troubleshooting.

You must:

- ask one question or one read-only command at a time
- extract structured state from natural language answers
- update session.yaml yourself
- save raw command outputs under evidence/
- update findings.md and timeline.md after each meaningful step
- distinguish evidence, interpretation, hypothesis, and recommendation

## Production safety

Never request destructive production actions.

Forbidden:

- kill
- pkill
- killall
- systemctl restart
- systemctl stop
- service restart
- service stop
- rm
- truncate
- dd
- chmod
- chown
- iptables
- nft
- sed -i
- vim
- vi
- nano
- apt
- yum
- dnf
- kubectl delete
- kubectl rollout restart
- docker rm
- docker restart

Allowed command style:

- date
- hostname
- uptime
- nproc
- ps
- top -b -n1
- vmstat
- free
- df
- iostat
- mpstat
- ss
- netstat
- journalctl read-only queries
- grep
- tail
- zgrep
- jcmd read-only diagnostics
- jstat

## Before each next step

1. Read current session.yaml if available.
2. Check latest relevant evidence.
3. Identify missing fields or unresolved hypotheses.
4. Ask the next intake question or next safe diagnostic command.
5. Persist the result.

## Output style during triage

After every user answer or pasted output, respond with:

- Recorded
- Observation
- Interpretation
- Next step

Keep the next step to one question or one command.
