#!/bin/sh

VIVOSCRIPTS_PATH=$(dirname $(readlink -f "$0"))

. $VIVOSCRIPTS_PATH/vivoFunctions.sh

case $1 in
"login")
    login $2
    ;;
"getipv6-pd")
    getIpV6PD
    ;;
"reboot")
    reboot $2
    ;;
*)
    echo "Usage: $0 <login | getipv6-pd | reboot> [-d | -v]"
    ;;
esac
