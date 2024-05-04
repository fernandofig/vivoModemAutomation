#!/bin/sh

. /root/bin/logaModemVivo.sh

STATUSVIEW="/cgi-bin/statusview.cgi"

fazLogin

IPVS="::/64"

while [ "$IPVS" = "::/64" ]; do
	DATAATUAL="$(date '+%y-%m-%d %H:%M:%S')"

	MODEMOUT=$(curl -s -b $COOKIES $MDMHOST$STATUSVIEW | sed -n "/<span id='MLG_Home_IPv6_Prefix\'>/,/<tr >/p" |  tr -d '\r\n \t')
	IPVS="$(echo $MODEMOUT | sed -r 's/.*"table_fontw_blue">([^<]+)<\/td>.*/\1/')/64"
	IPVS="$(echo $IPVS | xargs)"
	# IPVS="::/64"
	echo "$DATAATUAL : Prefixo no roteador da Vivo    : $IPVS"
done
