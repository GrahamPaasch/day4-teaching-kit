# Day 4 — Speaker Notes

**Pacing (approx):**
- 25 min: Why Ansible + NETCONF, architecture, safety patterns
- 35 min: Inventory + ansible.cfg walkthrough
- 30 min: Live coding Lab 4A (dry-run only)
- 20 min: Break
- 45 min: Apply to canaries, show validation & artifacts
- 25 min: Debrief, common failure modes, Q&A
- 30 min: Optional Lab 4B preview (+ homework)

**Demo script:**
1) `cd ansible && source .venv/bin/activate` (or demonstrate from a clean shell).
2) `ansible-galaxy collection install -r requirements.yml`.
3) Show `inventories/production/hosts.yml`: groups `junos`, `ios`, `canary`, `prod`.
4) Show `group_vars`: VLAN parameters and commit-confirm seconds.
5) Run `preflight.yml` against `canary`.
6) Run `lab4a_multivendor_vlan.yml` with `--check --diff` (explain diffs).
7) Remove `--check`, run canary. Show REST health check is *not* used today (config plane only).
8) Show `logs/ansible.log` and where backups/diffs were stored.
9) Widen rollout with `--limit` demonstrating serial batching.
10) Q&A: 'When would I use Nornir or pyATS here?' (see final slide).

**Common pitfalls to point out live:**
- SSH auth problems → use keys; vault only when required.
- IOS config parser: `parents` vs flat `lines`.
- Junos `commit_confirm_seconds` too short → increase if validation probes run slow.
- Concurrency too high → CPU spikes on devices. Lower `forks`, increase `serial`.
