# Ansible + NETCONF Cheat Sheet (Network Edition)

## Dry-run & diffs
- `--check` = simulate (no commit on device).
- `--diff`  = show intended changes.
- Combine with `serial` to preview in safe batches.

## Junos safety
- `commit: yes`, `confirm: <seconds>` to auto‑rollback unless confirmed.
- Confirm with a follow-up commit task when validation passes.
- Backups: `junipernetworks.junos.junos_config: backup: yes`.

## IOS patterns
- Use `cisco.ios.ios_config` with `parents` for hierarchical config.
- `save_when: modified` to write NVRAM only when needed.
- Show commands for validation: `ios_command`.

## Inventory tips
- Group by platform and by rollout stage (`canary`, `prod`).
- Put per‑platform defaults in `group_vars/junos.yml` and `group_vars/ios.yml`.
- Use host_vars for device‑specific exceptions.

## Operational guardrails
- Start with **canaries**. Stop rollout if failure rate > X%.
- Keep **concurrency modest** (`forks`, `serial`).
- Store **artifacts** (logs, diffs) with your PR for audit.

## When to use other tools
- **Nornir:** custom concurrency, multi‑protocol orchestration in Python.
- **pyATS/Genie:** structured parsing and assertions for continuous verification.
- **gNMI/OpenConfig:** telemetry/state collection at scale.
