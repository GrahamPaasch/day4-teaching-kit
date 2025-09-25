---
marp: true
theme: default
paginate: true
title: "Day 4 — Multi‑Vendor Configuration & Ansible"
author: "Instructor Kit"
size: 16:9
---

# Day 4 — Multi‑Vendor Configuration & Ansible

**Goals today**
- Build a mental model for Ansible on networks (inventory → templates → modules → diffs → validate → rollback)
- Do a **multi‑vendor change** safely (Cisco IOS‑XE + Junos)
- Practice **check mode**, **diffs**, **commit‑confirm**, **staged rollouts**, and **post‑validation**
- Understand when to add **Nornir/pyATS** to the stack

---

## Where today fits in the course

Day 1–3 covered: Python, device access, SNMP/syslog, REST/RESTCONF/Junos REST.  
**Day 4**: Idempotent **configuration at scale** with Ansible, plus vendor specifics.  
**Day 5**: Capstone — bring it all together (inventory → policy → change → validation → artifacts).

---

## Why Ansible for config?

- **Idempotent** diffs and check mode (dry‑run).
- **Transaction safety** on Junos (commit, commit‑check, commit‑confirm, rollback).
- **Governance**: Git/PR review, CI artifacts, auditable runs.
- **Scale controls**: inventory groups, `serial` batching, per‑task timeouts.
- **Interop**: Junos + IOS‑XE in one playbook.

> Complement with **pyATS/Genie** for assertions and **Nornir** for custom control loops when needed.

---

## Architecture (mental model)

```
Source of Truth (inventory + vars) ──► Jinja2 templates / intent
     │                                   │
     ├──► Ansible modules (junos_config / ios_config / *vendor*)
     │                                   │
     └──► Check mode + Diffs ──► Validation tasks ──► Commit / Rollback
```

Key patterns: **canary first**, **serial waves**, **commit‑confirm on Junos**, **artifact capture**.

---

## Inventory & groups (example)

```yaml
all:
  children:
    junos:
      children:
        canary:
          hosts:
            jnx-nyc-01: { ansible_host: 10.10.0.11 }
        prod:
          hosts:
            jnx-sfo-01: { ansible_host: 10.10.2.11 }
      vars:
        ansible_connection: netconf
        ansible_network_os: junipernetworks.junos.junos
        ansible_user: ansible
    ios:
      children:
        canary:
          hosts:
            ios-chi-01: { ansible_host: 10.20.0.21 }
      vars:
        ansible_connection: network_cli
        ansible_network_os: cisco.ios.ios
        ansible_user: ansible
```

---

## Safety defaults (`ansible.cfg`)

- `forks = 50` (start conservative; adjust after observing load)
- `timeout = 30`, `command_timeout = 60`
- `stdout_callback = yaml`, `log_path = logs/ansible.log`
- SSH ControlPersist, pipelining on
- Host key checking **on** (preload known_hosts in lab)

---

## Lab 4A (what we’ll build)

**Goal:** Create a VLAN and apply interface descriptions on IOS‑XE and Junos with:  
1) **Dry‑run** and diffs  
2) **Apply with safeguards**  
3) **Validate** using show commands  
4) Save artifacts (logs/diffs)

---

## Playbook structure (Lab 4A)

- Preflight backup / facts
- Build vendor‑specific config (Jinja2 or inline lines)
- `--check --diff` to preview
- Apply:
  - Junos with **confirm timer** (auto‑rollback)
  - IOS in **serial** batches
- Validate:
  - IOS: `show vlan brief`, `show interface description`
  - Junos: `show vlans`, `show interfaces descriptions`
- Record summary

---

## Junos task (example)

```yaml
- name: Apply VLAN + descriptions (Junos)
  when: "'junos' in group_names"
  junipernetworks.junos.junos_config:
    lines:
      - "set vlans {{ vlan_name }} vlan-id {{ vlan_id }}"
      - "set interfaces {{ junos_access_port }} unit 0 family ethernet-switching port-mode access"
      - "set interfaces {{ junos_access_port }} unit 0 family ethernet-switching vlan members {{ vlan_name }}"
      - "set interfaces {{ junos_access_port }} description {{ iface_desc }}"
    comment: "Lab4A multi-vendor change"
    commit: yes
    confirm: "{{ commit_confirm_seconds }}"
    diff: true
```

---

## IOS‑XE task (example)

```yaml
- name: Ensure VLAN exists (IOS)
  when: "'ios' in group_names"
  cisco.ios.ios_config:
    parents: ["vlan {{ vlan_id }}"]
    lines:
      - "name {{ vlan_name }}"

- name: Configure access port + description (IOS)
  when: "'ios' in group_names"
  cisco.ios.ios_config:
    parents: ["interface {{ ios_access_port }}"]
    lines:
      - "description {{ iface_desc }}"
      - "switchport mode access"
      - "switchport access vlan {{ vlan_id }}"
```

---

## Validation steps

- IOS:
  - `ios_command: commands=['show vlan brief', 'show interface {{ ios_access_port }} description']`
- Junos:
  - `junos_command: commands=['show vlans', 'show interfaces descriptions {{ junos_access_port }}']`
- Use `failed_when` assertions to **gate** commit confirmation on Junos.

---

## Operational guardrails

- **Canaries**: `--limit canary` first, then widen.
- **Serial** batching: `serial: 25` to bound risk.
- **Circuit breaker**: stop rollout if failure rate exceeds threshold.
- **Artifact capture**: keep pre‑change backups, diffs, and validation outputs.

---

## When to add Nornir/pyATS

- Nornir: need **custom batching/throttling**, multi‑protocol orchestration in Python.
- pyATS/Genie: **parse & assert** post‑change behavior (e.g., OSPF neighbors, VLAN present across distro).

---

## Lab 4B (optional stretch)

Automate **OSPF adjacency parameters**: hello/dead timers + passive interface policy across IOS‑XE and Junos.  
Pattern identical: preview → apply (commit‑confirm on Junos) → validate OSPF neighbor state.

---

## Key takeaways

- Prefer **NETCONF/RESTCONF (YANG)** for config where available.
- Use Ansible for **policy + idempotent change control**.
- Protect changes with **canaries, serial waves, commit‑confirm, and validations**.
- Keep CLI/Netmiko as **break‑glass**.

---

## Q&A and next steps

- Run Lab 4A on canaries now.  
- Save diffs and validation outputs to your PR.  
- If time permits, try Lab 4B or extend Lab 4A to trunk ports.
