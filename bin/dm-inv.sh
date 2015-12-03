#!/bin/bash -eu
#
# Ansible dynamic inventory based on `docker-machine ls`.
#

list::machines() {
    docker-machine ls -q
}

main() {
    local action=$1
    local host=${2:-}

    case $action in
    --list)
        
        comma1=
        echo '['
            while read machine
            do
                echo $comma1'"'$machine'"'
                comma1=,
            done < <(list::machines)
        echo ']'
        ;;

    --host)
        [ ! -d $MACHINES_DIR/$host ] && \
            echo "error: host unknown." && exit 1
        
        ip=$($DM ip $host)
        key_file="$MACHINES_DIR/$host/id_rsa"
        echo '{
            "host": "'$host'",
            "ansible_ssh_user": "admin",
            "ansible_ssh_host": "'$ip'",
            "ansible_ssh_private_key_file": "'$key_file'"
        }'
        ;;
    *)
        echo "error: action unknown. Use --list or --host <host>." && exit 1
    esac
}

main "$@"