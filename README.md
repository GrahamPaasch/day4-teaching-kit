# Day 4 Teaching Kit — Multi‑Vendor Configuration & Ansible

This folder contains **slides**, **labs**, and a ready‑to‑run **Ansible skeleton** for Day 4 of *Integrated Python for Network Engineers* (Multi‑Vendor Configuration & Ansible).

> Tested with: Python 3.11+, `ansible-core >= 2.16`.

## Quick Start (student)
```bash
git clone <your_repo_url> day4
cd day4/ansible
python3 -m venv .venv && source .venv/bin/activate
pip install --upgrade pip "ansible-core>=2.16" ncclient
ansible-galaxy collection install -r requirements.yml --collections-path ./collections
# Edit inventories/production/hosts.yml with your device addresses.
# Optional: edit inventories/production/group_vars/* with VLAN/OSPF params.

# Preflight (canary group only)
ansible-playbook playbooks/preflight.yml -e target=canary

# Dry-run VLAN + interface desc change
ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=canary --check --diff

# Apply to canary (commit-confirm safe on Junos)
ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=canary

# Expand to prod gradually
ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=prod --limit "site_dfw:&prod"
```

## Contents
- `slides/` — Marp Markdown deck: **Day4_MultiVendor_Ansible.md** (+ speaker notes).
- `ansible/` — working repo scaffold with `requirements.yml`, `ansible.cfg`, inventory, playbooks, templates.
- `labs/` — step‑by‑step student worksheets for **Lab 4A (VLAN + descriptions)** & **Lab 4B (OSPF adjacency params)**.
- `solutions/` — instructor reference outputs & diffs.
- `cheatsheets/` — quick references for Ansible + NETCONF + idempotent patterns.
- `scripts/` — helper shell snippets (optional Makefile not included to keep cross‑platform friendly).

## Safety knobs (important)
- Use **canary groups** and `serial` batching in playbooks.
- Junos changes use **commit-confirm**; if validation fails, they auto‑rollback.
- IOS changes are pushed in **bounded batches**; review **--check --diff** artifacts before applying.
- Store secrets in **Ansible Vault**; sample inventory assumes SSH keys for scale.
