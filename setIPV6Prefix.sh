#!/bin/sh

DATAATUAL="$(date '+%y-%m-%d %H:%M:%S')"

/root/bin/vivoAutomate.sh login
IPVS=$(/root/bin/vivoAutomate.sh getipv6-pd)

echo "$DATAATUAL : Prefix on Vivo ONT : $IPVS"

IPVS_CFG="$(uci get network.wan6.ip6prefix | xargs)"

echo "$DATAATUAL : Prefix on OpenWRT  : $IPVS_CFG"

if [ -n "$IPVS" ] && [ "$IPVS" != "::/64" ] && [ "$IPVS" != "/64"  ] && [ -n $IPVS_CFG ] && [ "$IPVS" != "$IPVS_CFG" ]; then
	echo "$DATAATUAL : Prefix mismatch detected. Updating..."

	/etc/init.d/dnsmasq stop
	/etc/init.d/odhcpd stop

	uci set network.wan6.ip6prefix="$IPVS"
	uci commit network

	ifdown wan6 > /dev/null 2>&1
	ifup wan6 > /dev/null 2>&1

	/etc/init.d/odhcpd start
	/etc/init.d/dnsmasq start

	echo "$DATAATUAL : Uodated!"

	/root/bin/consertaReflections.sh -s > /tmp/log/consertaReflections.log
fi

echo "---"
