#!/bin/sh

. /root/bin/logaModemVivo.sh

REBOOTURL="/cgi-bin/reboot.cgi"

echo -n "* Enviando comando de reset ao Modem... "
curl -s -b $COOKIES --data "restoreFlag=1&RestartBtn=RESTART" $MDMHOST$REBOOTURL

echo "Ok!"
