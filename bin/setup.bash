set -e

BASHLIB="${BASH_SOURCE%/*}/../ext/bashplus/lib"
PATH="$BASHLIB:$PATH" source bash+.bash
bash+:import :std
CONF=conf/conf.sh

read-conf() {
  source "$CONF"
  check-var-dir apps_directory
  check-var-dir get_stackato_store_path
  get-var-file apps_ini_file
}

check-var-dir() {
  [ -n "${!1}" ] ||
    die "'$1' not specified in '$CONF'"
  printf -v "$1" "$(abspath "${!1}" "conf")"
  [ -d "${!1}" ] ||
    die "'$1' is not a directory"
}

get-var-file() {
  [ -n "${!1}" ] ||
    die "'$1' not specified in '$CONF'"
  printf -v "$1" "$(abspath "${!1}" "conf")"
}

abspath() {
  local path="${1:-/}"
  local base="${2:-.}"

  [[ "$path" =~ ^/ ]] || path="$base/$path"
  while [[ "$path" =~ /$ && "${#path}" -gt 1 ]]; do
    path="${path%/}"
  done

  (
    cd "$(dirname "$path")" &> /dev/null &&
      echo "$PWD/$(basename "$path")"
    true
  )
}
