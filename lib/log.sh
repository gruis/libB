# Display a warning message. 
# If STDOUT is connected to a terminal the message will be in magenta.
function warn {
    [[ -n 1 ]] || return 0;
    if [[ -t 1 ]]; then
      echo -e "\e[00;35m$1\e[00m"
    else
      echo -e "$1"
    fi
    return 0;
}

# Display a message.
# If STDOUT is connected to a terminal the message will be in green.
function log {
    [[ -n 1 ]] || return 0;
    if [[ -t 1 ]]; then
      echo -e "\e[00;32m$1\e[00m"
    else
      echo -e "$1"
    fi
    return 0;
}

