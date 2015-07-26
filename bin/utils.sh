#
# Utils functions.
#

WORKDIR=/ops
MACHINE_DIR=$WORKDIR/machine
MACHINES_DIR=$MACHINE_DIR/machines

DM="docker-machine -s $MACHINE_DIR"

PASSWORD=${PASSWORD:-"no"}
PWD_FILE=$WORKDIR/config/.password
[ -f $PWD_FILE ] && PASSWORD=$(cat $PWD_FILE)

# Print message error and exit.
#
error() {
  local cmd="$1"
  local msg="[error] $2."
  if [[ "$cmd" != "-" ]]; then
    msg="$msg \nSee '$cmd -h.'"
  fi
  echo -e "$msg" >&2 && exit 2
}

log() {
  local level="$1"
  local msg="$2"
  echo "[$level] $msg"
}

# Encrypt a file.
#
encrypt() {
  local src=$1
  local dest=$2
  openssl aes-256-cbc -salt -in $src -out $dest -k $PASSWORD
}

# Decrypt a file.
#
decrypt() {
  local src=$1
  local dest=$2
  openssl aes-256-cbc -d -salt -in $src -out $dest -k $PASSWORD
}

# Read machine IP from machine config files.
# Try '.Driver.Ip' then '.Driver.IPAddress'.
#
get_ip() {
  local machine_path=$1
  local ip="null"

  ip=$(jq -r .Driver.Ip $machine_path/config.json)

  [ "$ip" == "null" ] \
    && ip=$(jq -r .Driver.IPAddress $machine_path/config.json)

  [ "$ip" == "null" ] \
    && error compose 'Cannot read IP in $machine_path/config.json' \
    || echo "$ip"
}

refresh() {
  . ~/.bashrc
}

# Export DOCKER_TLS_VERIFY, DOCKER_HOST and DOCKER_CERT_PATH
# using the machines files (/ops/machines/<$MACHINE>/*) to get IP
# or just set MACHINE if DOCKER_TLS_VERIFY is already set.
#
set_machine() {
  local machine=${1:-no}
  [ "$machine" == "no" ] && machine=${MACHINE:-no}

  DOCKER_CERT_PATH=${DOCKER_CERT_PATH:-no}

  if [ "$machine" != "no" ]; then
    MACHINE=$machine
    # Read variables from machine files
    local machine_path=$MACHINES_DIR/$MACHINE

    [ ! -d $machine_path ] \
      && error "-" "No machine directory: $machine_path"

    IP=$(get_ip $machine_path)

    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://$IP:2376"
    export DOCKER_CERT_PATH="$machine_path"
    export DOCKER_MACHINE_NAME="$MACHINE"

  elif [ "$DOCKER_CERT_PATH" != "no" ]; then
    # Assumes env vars DOCKER_* are set
    [ ! -d $DOCKER_CERT_PATH ] \
      && error "-" 'No cert directory: $DOCKER_CERT_PATH'

    MACHINE=$(echo $DOCKER_CERT_PATH | sed "s|.*/||")
  else
    MACHINE=""
  fi

  refresh
}

set_compose() {
  local name=${1:-no}
  [ "$name" == "no" ] && name=${NAME:-no}

  if [ "$machine" != "no" ]; then
    export NAME="$app"
  else
    export NAME=""
  fi

  refresh
}