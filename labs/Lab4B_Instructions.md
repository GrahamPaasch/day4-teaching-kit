# Lab 4B — OSPF adjacency parameters (optional)

**Objective:** Change OSPF hello/dead timers on both platforms and verify neighbors recover.

## Steps
1. Confirm your OSPF is active on the target links (lab or sandbox).
2. Set `hello` and `dead` variables directly in the playbook or pass via `-e`:
   ```bash
   ansible-playbook playbooks/lab4b_ospf_params.yml -e target=canary -e hello=10 -e dead=40
   ```
3. Validate neighbor states return to **FULL**.
4. Record outputs in your PR notes.

**Note:** Use a maintenance window in real networks; timer mismatches flap adjacencies.
