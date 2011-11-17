# RUSER is the name of teh real user executing the current script even if tthe script is executed via sudo.
RUSER=$SUDO_USER
[[ -z "RMUSER" ]] && RUSER=$USER

# Display an error message and exit with a status of 1.
# If STDOUT is connected to a terminal the error message will be in red.
# @param [String] msg
function punt {
    [[ -n 1 ]] || exit 1;
    if [[ -t 1 ]]; then
      echo -e "\e[00;31m$1\e[00m"
    else
      echo -e "$1"
    fi
    exit 1;
}

# Require that the script be run wint an effective user id of 0.
function require_root {
  [[ $EUID -ne 0 ]] && punt "This script must be run as root"
}

echo $BASH_SOURCE
LIBBPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Search for a given bash source file and load it into the current script. If the file is not found
# the script will punt.
function require {
  for lib in "$@"; do
    [[ ! -e "$LIBBPATH/$lib.sh" ]] && punt "$lib not found in ${LIBBPATH}/${lib}.sh"
    . ${LIBBPATH}/${lib}.sh
  done
}
