# Instructor Reference — Expected Artifacts

After a successful Lab 4A run on canaries you should see:

- **Junos** diffs: `set vlans DEMO-123 vlan-id 123`, interface membership on `ge-0/0/10`, description applied.
- **IOS** diffs: `vlan 123` + `name DEMO-123`; interface block for target port with description and access VLAN.

Validation task outputs should include:
- IOS: `show vlan brief | include 123` line with active ports; `show interface <port> description` containing `LAB4A access port`.
- Junos: `show vlans | display set | match DEMO-123` and `show interfaces descriptions ge-0/0/10` showing the description.

Troubleshooting quick hits:
- Authentication/transport: test `ssh ansible@<host>` and NETCONF `telnet <host> 830`.
- Concurrency: reduce `forks` and `serial` on low‑end devices.
- Diff shows no change but validation fails: check **VRF/VLAN domain** or platform‑specific nuances.
