# RootCauseLab

RootCauseLab is a safe, guided production diagnostics toolkit for investigating degraded services and collecting evidence toward a likely root cause.

It combines:

- Codex-guided production triage
- reusable diagnostic skills
- read-only collectors
- incident workspaces
- JVM/Linux troubleshooting workflows

RootCauseLab does not give Codex direct SSH access to production.

The main operating model:

1. Codex asks the operator a question or requests one read-only command.
2. The operator answers or runs the command on the production host.
3. The operator pastes the output back into Codex.
4. Codex saves the evidence and updates the incident state.
5. Codex chooses the next safe diagnostic step.

The user should not manually edit YAML during normal troubleshooting.
Codex maintains the incident state.
