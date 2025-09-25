# Day 4 Operator Runbook (Instructor)

## Before class
- Verify DevNet/Juniper vLab or local lab access. If offline, use the mock fixtures only to demonstrate diffs.
- Preload device host keys to avoid first-run SSH prompts.
- Confirm the controller can reach TCP/22 (IOS) and TCP/830 (Junos NETCONF).

## During class
1. Clone the repo and walk through the `ansible` folder structure.
2. Fill `inventories/production/hosts.yml` with two canary devices (1x IOS, 1x Junos).
3. Run `preflight.yml` (expect facts to populate).
4. Demonstrate `--check --diff` on `lab4a_multivendor_vlan.yml`.
5. Apply to canary and show the confirm/validate/commit sequence on Junos.
6. Examine logs and diffs. Emphasize idempotence by re-running.
7. Expand cautiously with `--limit` and `serial`.
8. Field Q&A; compare with a Nornir-based approach.

## After class
- Collect student artifacts for rubric scoring.
- Push a tag `day4-solution` to your repo with your final inventory (sanitized) and diffs.
