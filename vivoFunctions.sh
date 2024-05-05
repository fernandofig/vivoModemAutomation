#!/bin/sh

if [ -z "$VIVOSCRIPTS_PATH" ]; then
	VIVOSCRIPTS_PATH=$(dirname $(readlink -f "$0"))
fi

. $VIVOSCRIPTS_PATH/vivoOnt.conf

login() {
	[ "$1" != "-s" ] && echo -n "* Logging in on ONT... "
	SIDPGLOGIN=$(curl -s $ONT_HOST$LOGIN_URL | grep "var sid" | awk -F "=" '{print $2}' | sed -r "s/['; \r\n]+//g")
	PASSHASH=$(echo -n "$LOGIN_PASS:$SIDPGLOGIN" | md5sum | awk -F " " '{print $1}')

	LOGIN_POST_DATA="Loginuser=$LOGIN_USER&LoginPasswordValue=$PASSHASH&acceptLoginIndex=1"

	if [ "$1" = "-d" ]; then
		echo
		echo "[DEBUG] SIDPGLOGIN      : $SIDPGLOGIN"
		echo "[DEBUG] PASSHASH        : $PASSHASH"
		echo "[DEBUG] LOGIN_POST_DATA : $LOGIN_POST_DATA"
	fi

	rm -f $COOKIES_FILE
	LOGINOUT=$(curl -s -c $COOKIES_FILE --data "$LOGIN_POST_DATA" $ONT_HOST$LOGIN_URL)
	[ "$1" != "-s" ] && echo "Ok!"

	return $?
}

getIpV6PD() {
	IPVS="::/64"

	while [ "$IPVS" = "::/64" ]; do
		INFOPAGEOUT=$(curl -s -b $COOKIES_FILE $ONT_HOST$STATUS_VIEW)
		RETVAL=$?
		IPBLOCK=$(echo "$INFOPAGEOUT" | sed -n '/<div id="internet_v6_table">/,/<\/li>/p' |  tr -d '\r\n \t')
		IPVS="$(echo $IPBLOCK | sed -r 's/.*<li>([^<]+)<\/li>.*/\1/')"
	done

	echo $IPVS

	return $RETVAL
}

reboot() {
	[ "$1" != "-s" ] && echo -n "* Sending Reboot command to ONT... "
	REBOOTOUT=$(curl -s -b $COOKIES_FILE $ONT_HOST$REBOOT_CALL)
	[ "$1" = "-d" ] && echo && echo "$REBOOTOUT"
	[ "$1" != "-s" ] && echo "Ok! "
}
