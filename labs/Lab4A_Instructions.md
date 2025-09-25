# Lab 4A — Multi‑Vendor VLAN + Interface Descriptions

**Objective:** Use Ansible to create VLAN **`{{ vlan_id }}`** named **`{{ vlan_name }}`** and set an access‑port description on both IOS‑XE and Junos devices **safely**.

## Steps
1. Open `ansible/inventories/production/hosts.yml` and put your device addresses in the `canary` groups.
2. Adjust interfaces in `group_vars/junos.yml` and `group_vars/ios.yml` if needed (e.g., `ge-0/0/10`, `GigabitEthernet1/0/10`).
3. Preflight:
   ```bash
   ansible-playbook playbooks/preflight.yml -e target=canary
   ```
4. Dry‑run and review diffs:
   ```bash
   ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=canary --check --diff
   ```
5. Apply to canary:
   ```bash
   ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=canary
   ```
   - Junos uses **commit‑confirm**; if the validation fails, it auto‑rolls back.
6. Validate: look for the VLAN line and interface description in the task outputs.
7. (Instructor) Expand to `prod` with a limited `--limit` subset and `serial` control.

## Deliverables
- Screenshot or copy of `--check --diff` preview.
- Post‑change validation output for each device.
- Short note: any deviations you observed across vendors and how you handled them.

## Cleanup (optional)
- Remove VLAN/description by editing group vars and re‑running with `--check` then apply,
  or use `rollback 1` on Junos if needed.
