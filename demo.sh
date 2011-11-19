#!/usr/bin/env bash

source lib/libB.sh
#LIBB_LOAD_PATH=( $LIBBPATH ./test )
LIBB_LOAD_PATH="$LIBB_LOAD_PATH ./test"

echo "requiring another lib"
require log
require keys

warn "this is a warning"
log "this is a log message"
error "this is an error message"

require "https://raw.github.com/gist/3e8493af52164763b7c9/echo"
debug "http based require worked"

#require "https://raw.github.com/gist/3e8493af52164763b7c9/404"

log "testing require loops"
require a
require b
