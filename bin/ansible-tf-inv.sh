#!/bin/bash -eu
#
# Ansible dynamic inventory based on a Terraform state.

TF_STATE=$MACHINE_STORAGE_PATH/terraform.tfstate

SSH_USER="${SSH_USER:-admin}"
SSH_PRIVATE_KEY_FILE="${SSH_PRIVATE_KEY_FILE:-/ops/ssh/admin.id_rsa}"

provider="openstack"
type_key="openstack_compute_instance_v2"
ip_key="access_ip_v4"

hosts() {
  jq '.modules[] |
    .resources | to_entries |
    map(.value) |
    map(select(.type == "'$type_key'")) |
    .[] |
    .primary.attributes' $MACHINE_STORAGE_PATH/terraform.tfstate
}

list_groups() {
  hosts | jq -r '.["metadata.groups"] | split(",") | unique[]'
}

main() {
  local action=$1
  local host=${2:-}

  case $action in
  --list)
    all=$(hosts | jq -s 'map(.name)')
    echo '{'
    echo '"all" : '$all''
    comma=,

    if [[ "$(hosts | jq -M .metadata | uniq)" != "null" ]]; then
      for group in $(list_groups)
      do
        echo $comma
        echo '"'$group'":'
        hosts | jq 'select(.["metadata.groups"] | split(",")[] == "'$group'") .name' | jq -s .
      done
    fi
    echo '}'
    ;;

  --host)
    data=$(hosts | jq 'select(.name == "'$host'")')
    ip=$( echo $data | jq '.["'$ip_key'"]')
    ansible='{
      "ansible_ssh_user": "'$SSH_USER'",
      "ansible_ssh_host": '$ip',
      "ansible_ssh_private_key_file": "'$SSH_PRIVATE_KEY_FILE'"
    }'
    echo "$data$ansible" | jq -s '.[0] * .[1]'
    ;;

  *)
    echo "error: action unknown. Use --list or --host <host>." && exit 1
  esac
}

main "$@"
