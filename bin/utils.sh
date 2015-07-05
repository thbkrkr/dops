#
# Utils functions.
#

WORKDIR=/ops

PWD_FILE=$WORKDIR/config/.password
[ -f $PWD_FILE ] && PASSWORD=$(cat $PWD_FILE)

# Print message error and exit.
#
error() {
  local cmd="$1"
  local msg="$2"
  echo -e "[error] $msg. \nSee '$cmd -h.'" >&2 && exit 2
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