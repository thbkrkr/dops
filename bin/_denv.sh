#!/bin/bash
#
# Set up the environment for the Docker client using 2 variables:
# - ENV
# - MACHINE
#

ERROR=""
IS_ERROR=0
MACHINE_STORAGE_PATH=${MACHINE_STORAGE_PATH:-~/.docker/machine}

[[ ! -d $MACHINE_STORAGE_PATH ]] &&
    ERROR="error: directory $MACHINE_STORAGE_PATH not found" && IS_ERROR=1

SWARM="false"

get_swarm_master() {
  find $MACHINE_STORAGE_PATH/machines -name config.json \
    | xargs -n1 \
      jq -c '{"machine":.Driver.MachineName,"master":.HostOptions.SwarmOptions.Master}
      | select(.master==true)'
}

default_machine() {
  MACHINE=""

  # Try to get a swarm master
  if [[ -d $MACHINE_STORAGE_PATH/machines ]]; then
    MACHINE=$(get_swarm_master | jq -r .machine)
    SWARM=$(get_swarm_master | jq -r .master)
  fi

  # Get the first node
  [[ "$MACHINE" == "" ]] && \
  [[ -d $MACHINE_STORAGE_PATH ]] &&
    MACHINE=$(docker-machine ls -q | head -1)
}

valid_args() {
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
  valid_args "$@"

  set -u

  # Set up the environment for the Docker client
  # Speed up the setup by exporting directly the variables without the 'docker-machine env' command

  if [[ "$IS_ERROR" -eq 1 ]] ; then
    echo 'export ERROR="'"$ERROR"'. No docker environment set!"'
  else
    PORT=2376
    if [[ "$SWARM" == "true" ]]; then
      PORT=3376
    fi

    IP=$(docker-machine ip $MACHINE)

    echo 'export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://'$IP':'$PORT'"
export DOCKER_CERT_PATH="'$MACHINE_STORAGE_PATH'/machines/'$MACHINE'"
export DOCKER_MACHINE_NAME="'$MACHINE'"'
  fi
}

main "$@"