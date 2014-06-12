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

prompt() {
  local msg answer default yn=false password=false
  case $# in
    0) msg="${prompt_msg:-Press <ENTER> to continue, or <CTL>-C to exit.}" ;;
    1)
      msg="$1"
      if [[ "$msg" =~ \[yN\] ]]; then
        default=n
        yn=true
      elif [[ "$msg" =~ \[Yn\] ]]; then
        default=y
        yn=true
      fi
      ;;
    2)
      msg="$1"
      default="$2"
      ;;
    *) die "Invalid usage of prompt" ;;
  esac
  if [[ "$msg" =~ [Pp]assword ]]; then
    password=true
    msg=$'\n'"$msg"
  fi
  while true; do
    if "$password"; then
      read -s -p "$msg" answer
    else
      read -p "$msg" answer
    fi
    [ $# -eq 0 ] && return 0
    [ -n "$answer" -o -n "$default" ] && break
  done
  if "$yn"; then
    [[ "$answer" =~ ^[yY] ]] && echo y && return 0
    [[ "$answer" =~ ^[nN] ]] && echo n && return 0
    echo "$default"
    return 0
  fi
  if [ -n "$answer" ]; then
    echo "$answer"
  else
    echo "$default"
  fi
}
