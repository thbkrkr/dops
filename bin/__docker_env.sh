#!/bin/bash
#
# Set up the environment for the Docker client.
#
# You can set the Docker remote host using the
# env var MACHINE.
#
# Or the Docker remote host is automatically discovered.
# If swarm master exists, it is used else the first node is used.
#

ERROR=""
IS_ERROR=0

SWARM="false"

get_swarm_master() {
  if [[ ! -d $MACHINE_STORAGE_PATH ]]; then
    echo "{}"
    return
  fi

  find $MACHINE_STORAGE_PATH/machines -name config.json \
    | xargs -n1 \
      jq -c '{"machine":.Driver.MachineName,"master":.HostOptions.SwarmOptions.Master}
      | select(.master==true)'
}

set_machine() {
  [[ ! -z $MACHINE ]] && return

  # Try to get a swarm master
  if [[ -d $MACHINE_STORAGE_PATH/machines ]]; then
    MACHINE=$(get_swarm_master | jq -r .machine)
    SWARM=$(get_swarm_master | jq -r .master)
  fi

  # Get the first node if no swarm master
  [[ "$MACHINE" == "" ]] && \
  MACHINE=$(docker-machine ls -q | head -1)
}

xxxxxvalid_args() {
  ENV_MACHINE=${MACHINE:-""}
  ARG_MACHINE=${1:-""}

  # MACHINE arg
  if [[ "$ARG_MACHINE" != "" ]]; then
    MACHINE=$ARG_MACHINE
    shift
    SWARM=${1:-"maybe"}
  fi
  # MACHINE env var
  if [[ "$ARG_MACHINE" == "" ]] && [[ "$ENV_MACHINE" != "" ]]; then
    MACHINE=$ENV_MACHINE
    SWARM=${SWARM:-"maybe"}
  elif [[ "$ARG_MACHINE" == "" ]] && [[ "$ENV_MACHINE" == "" ]]; then
    default_machine
  fi

  MACHINE=${MACHINE:-""}

  # Valid MACHINE
  [[ "$MACHINE" == "" ]] && \
      ERROR="No docker MACHINE defined" && IS_ERROR=1

  [[ "$MACHINE" != "" ]] && [[ ! -f $MACHINE_STORAGE_PATH/machines/$MACHINE/config.json ]] && \
      ERROR="error: file $MACHINE_STORAGE_PATH/machines/$MACHINE/config.json not found" && IS_ERROR=1

  # Set SWARM
  case $SWARM in
    --no-swarm|false)
      SWARM=false
      ;;
    maybe|*)
      [[ -f $MACHINE_STORAGE_PATH/machines/$MACHINE/config.json ]] && \
        SWARM=$(jq .HostOptions.SwarmOptions.Master $MACHINE_STORAGE_PATH/machines/$MACHINE/config.json)
      ;;
  esac
}

main() {
  #valid_args "$@"
  set_machine

  set -u

  # Set up the environment for the Docker client
  # Speed up the setup by exporting directly the variables without the 'docker-machine env' command

  # if [[ "$IS_ERROR" -eq 1 ]] ; then
  #   echo 'export ERROR="'"$ERROR"'. No docker environment set!"'
  # else
  if [[ "$MACHINE" == "" ]]; then
    return
  fi
    PORT=2376
    if [[ "$SWARM" == "true" ]]; then
      PORT=3376
    fi

    IP=$(docker-machine ip $MACHINE)

    echo 'export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://'$IP':'$PORT'"
export DOCKER_CERT_PATH="'$MACHINE_STORAGE_PATH'/machines/'$MACHINE'"
export DOCKER_MACHINE_NAME="'$MACHINE'"'
  # fi
}

main "$@"