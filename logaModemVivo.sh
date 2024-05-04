#!/bin/sh

. /root/bin/vivoConfig.sh

COOKIES="/root/data/mdmVivoCookies.txt"

fazLogin() {
    LOGIN_USER="support"
    LOGIN_PASS="kyYeisPm"

    MDMHOST="http://192.168.15.1"
    LOGINURL="/cgi-bin/login_advance.cgi"    

    echo -n "* Fazendo login no Modem... "
    SIDPGLOGIN=$(curl -s $MDMHOST$LOGINURL | grep "var sid" | awk -F "=" '{print $2}' | sed -r "s/['; \r\n]+//g")
    PASSHASH=$(echo -n "$LOGIN_PASS:$SIDPGLOGIN" | md5sum | awk -F " " '{print $1}')

    LOGINPOSTDATA="Loginuser=$LOGIN_USER&fake_username=&fake_pass=&LoginPasswordValue=$PASSHASH&submitValue=1&LoginSidValue=$SIDPGLOGIN&Prestige_Login=Início+de+sessão"

    rm -f $COOKIES
    curl -s -c $COOKIES --data "$LOGINPOSTDATA" $MDMHOST$LOGINURL > /dev/null
    echo "Ok!"
}

fazLoginBasico() {
    LOGIN_USER="admin"
    LOGIN_PASS="kyYeisPm"
    echo $MDMHOST

    LOGINURL="/cgi-bin/login.cgi"    

    echo -n "* Fazendo login no Modem... "
    SIDPGLOGIN=$(curl -s $MDMHOST$LOGINURL | grep "var sid" | awk -F "=" '{print $2}' | sed -r "s/['; \r\n]+//g")
    PASSHASH=$(echo -n "$LOGIN_PASS:$SIDPGLOGIN" | md5sum | awk -F " " '{print $1}')

    LOGINPOSTDATA="Loginuser=$LOGIN_USER&LoginPasswordValue=$PASSHASH&acceptLoginIndex=1"

    rm -f $COOKIES
    curl -s -c $COOKIES --data "$LOGINPOSTDATA" $MDMHOST$LOGINURL > /dev/null
    echo "Ok!"
}