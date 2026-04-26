# RootCauseLab Session State Schema

`session.yaml` is the canonical state of one troubleshooting session.

Codex must update this file after each user answer or evidence submission.

## Main sections

- `incident`: metadata about the troubleshooting session
- `service`: affected service and location
- `symptom`: what is wrong
- `impact`: user-visible and operational impact
- `recent_changes`: deploys, config changes, dependency incidents, traffic changes
- `process`: target process and JVM details
- `host`: host-level facts
- `classification`: current diagnostic classification
- `hypotheses`: possible root causes
- `evidence_index`: raw evidence files
- `decisions`: diagnostic decisions made so far
- `next_step`: next question or command

## Update rules

Codex should:

1. Preserve existing known fields unless contradicted by newer evidence.
2. Prefer observed evidence over guesses.
3. Mark uncertainty explicitly.
4. Never overwrite raw evidence.
5. Append decisions instead of replacing them.
6. Keep `next_step` current.

## Evidence vs interpretation

Evidence is raw observed data.

Interpretation is the meaning inferred from evidence.

Hypothesis is a possible root cause with confidence and supporting evidence.
