# RUSER is the name of the real user executing the current script even if tthe script is executed via sudo.
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
# @todo cache the results
function require_http {
  [[ -n 1 ]] || punt "require_http needs an argument"
  log "retrieving and requiring $1"
  lib=$(curl -f -s $1)
  [[ $? -ne 0 ]] && punt "unable to retrieve $1: $?"
  eval $lib
}

LIBBPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
libb_loaded=( libB )
# Search for a given bash source file and load it into the current script. If the file is not found
# the script will punt.
# @todo search multiple locations and defined in  LIBBPATH
# @todo as a last resort do an http request to the libB repo
# @todo prevent require loops
function require {
  for lib in ${libb_loaded[@]}; do
    [[ $lib == "$1" ]] && return 0;
  done

  for lib in "$@"; do
    if (echo $lib | grep -q '^https\?://'); then
      require_http $lib
    else
      [[ ! -e "$LIBBPATH/$lib.sh" ]] && punt "$lib not found in ${LIBBPATH}/${lib}.sh"
      libb_loaded=("${libb_loaded[@]}" "$1")
      . ${LIBBPATH}/${lib}.sh
    fi
  done
}


