#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  setup)
    python3 -m venv .venv && source .venv/bin/activate
    pip install --upgrade pip "ansible-core>=2.16" ncclient
    ansible-galaxy collection install -r requirements.yml --collections-path ./collections
    ;;
  preflight)
    ansible-playbook playbooks/preflight.yml -e target=canary
    ;;
  dryrun)
    ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=canary --check --diff
    ;;
  apply)
    ansible-playbook playbooks/lab4a_multivendor_vlan.yml -e target=canary
    ;;
  *)
    echo "Usage: ./kit.sh {setup|preflight|dryrun|apply}"
    ;;
esac
