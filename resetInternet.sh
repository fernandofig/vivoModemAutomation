#!/bin/sh

echo -n "* Enviando comando de reset ao Modem... "
curl -s --data 'loginUsername=admin&loginPassword=motorola' http://192.168.100.1/goform/login
#curl -s http://192.168.100.1/RgConfiguration.asp > /tmp/RgConfig.html
#DF=`sed -n 's/.*name="DownstreamFrequency".* value=\(.*\) readonly.*/\1/p' /tmp/RgConfig.html`
#UCID=`sed -n 's/.*name="UpstreamChannelId".* value=\(.*\) readonly.*/\1/p' /tmp/RgConfig.html`

#curl -s --data 'DownstreamFrequency=$DF&UpstreamChannelId=$UCID&DownstreamPlan=0&SaveChanges=Reboot' http://192.168.100.1/goform/RgConfiguration > /dev/null
curl -s --data 'SaveChanges=Reboot' http://192.168.100.1/goform/RgConfiguration > /dev/null

#rm /tmp/RgConfig.html

ifdown wan
echo "Ok."

echo -n "* Preparando novo Mac address... "

MACPB=`hexdump -n 1 -v -e '1/1 "%02X"' /dev/urandom`
MACUB=`hexdump -n 1 -v -e '1/1 "%02X"' /dev/urandom`

# Default : A4:2B:B0:D9:59:87
#MACCFG=`uci show network.wan.macaddr | awk -F "=" '{print $2}' | awk -F "'" '{print $2}' | sed 's/..:..$//'`
MACCFG="88:1F:A1:28:"
NEWMAC="$MACCFG$MACPB:$MACUB"

uci set network.wan.macaddr=$NEWMAC
uci commit network

echo "Ok."

echo -n "* Aguardando a reinicializacao do modem (25s) ... "

sleep 25

echo "Ok."

#echo -n "* Enviando comando de reinicializacao do roteador Dysnomia... "
#ssh -i /root/.ssh/id_dropbear root@192.168.4.126 /root/bin/reboota.sh
#sleep 5
#echo "Ok."

/root/bin/rebootDysnomia.sh

echo "--- Reiniciando..."
reboot

