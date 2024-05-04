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

IPVS_CFG="$(uci get network.wan6.ip6prefix | xargs)"

echo "$DATAATUAL : Prefixo configurado atualmente : $IPVS_CFG"

if [ -n "$IPVS" ] && [ "$IPVS" != "::/64" ] && [ "$IPVS" != "/64"  ] && [ -n $IPVS_CFG ] && [ "$IPVS" != "$IPVS_CFG" ]; then
	echo "$DATAATUAL : Diferenca de prefixos detectada. Atualizando..."

	/etc/init.d/dnsmasq stop
	/etc/init.d/odhcpd stop

	uci set network.wan6.ip6prefix="$IPVS"
	uci commit network

	ifdown wan6 > /dev/null 2>&1
	ifup wan6 > /dev/null 2>&1

	/etc/init.d/odhcpd start
	/etc/init.d/dnsmasq start

	echo "$DATAATUAL : Atualizado!"

	/root/bin/consertaReflections.sh -s > /tmp/log/consertaReflections.log
fi

echo "---"
