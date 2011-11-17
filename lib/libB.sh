# RUSER is the name of teh real user executing the current script even if tthe script is executed via sudo.
RUSER=$SUDO_USER
[[ -z "RMUSER" ]] && RUSER=$USER

# Display an error message and exit with a status of 1.
# If STDOUT is connected to a terminal the error message will be in red.
# @param [String] msg
function punt {
    [[ -n 1 ]] || exit 1;
    if [[ -t 1 ]]; then
      echo -e "\033[00;31m$1\033[00m"
    else
      echo -e "$1"
    fi
    exit 1;
}

# Require that the script be run wint an effective user id of 0.
function require_root {
  [[ $EUID -ne 0 ]] && punt "This script must be run as root"
}

# Retrieve a libB source file from an http server and require it.
# @todo check for curl or wget
function require_http {
  [[ -n 1 ]] || punt "require_http needs an argument"
  log "retrieving and requiring $1"
  #source < <(curl -s $1)
  #. <(curl -s $1)
  #export `(curl -s $1)`
  eval $(curl -s $1)
  #source /dev/stdin <$(curl -s $1)
  #curl -s $1 | source /dev/stdin
}

LIBBPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Search for a given bash source file and load it into the current script. If the file is not found
# the script will punt.
function require {
  for lib in "$@"; do
    if (echo $lib | grep -q '^https\?://'); then
      require_http $lib
    else
      [[ ! -e "$LIBBPATH/$lib.sh" ]] && punt "$lib not found in ${LIBBPATH}/${lib}.sh"
      . ${LIBBPATH}/${lib}.sh
    fi
  done
}


