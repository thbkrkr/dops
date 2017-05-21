#!/bin/bash -eu
#
# Ansible dynamic inventory based on $(docker-machine ls).
#
set -o pipefail

main() {
    declare action=${1:-}

    case $action in
    --list)
        echo '{
            "all": {
                "hosts":
                    '$(docker-machine ls -q | sed -r 's|(.*)|"\1"|g' | jq -sM .)',
                "vars": {
                }
            }
        }'
    ;;
    --host)
        declare host=${2:-""}
        declare machine_dir=$MACHINE_STORAGE_PATH/machines/$host

        [ ! -d $machine_dir ] && echo "error: host unknown." && exit 1

        echo '{
            "host": "'$host'",
            "ansible_user": "'$(jq -r .Driver.SSHUser $machine_dir/config.json)'",
            "ansible_host": "'$(docker-machine ip $host)'",
            "ansible_private_key_file": "'$machine_dir/id_rsa'"
        }' | jq -M .
    ;;
    *)
        echo "error: action unknown. Use --list or --host <host>." && exit 1
    ;;
    esac
}

main "$@"