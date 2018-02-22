# 2015-10-21
# añadidas personalización
# Variables de entorno
if [ -n "$BASH_ENV" ]; then . "$BASH_ENV" ;fi
. ~/bin/my_home_IP.sh
#. ~/.sistema/sbin/iniciar-X.sh
#. ~/bin/set_display.sh
loginfrom=$(who am i | cut -f2 -d"(" | cut  -f1 -d")")
display=${loginfrom}
if [ ! "$display" == ":0" ] ; then
DISPLAY=${display}:0.0
fi
#
export display
export DISPLAY
echo bash_Display: $DISPLAY
export XAUTHORITY=$HOME/.Xauthority
#
#
cd $SIC
# setxkbmap es
# Verificaciones
IFVPN=$(ifconfig | grep "tun" | cut -d " " -f 1)
if [ "$IFVPN" = "" ]
then
 echo .·: ----------------------------------:·.
 echo .   Recuerda ARMAR la VPN,               .
 echo ·.: ----------------------------------:.·
if [ "$DISPLAY" == ":0" ] ; then
zenity --error --timeout=5 --title="Error - ARMAR LA vpn" --text=" Recuerda ARMAR la VPN,"
notify-send --urgency=low "Interfaces VPN  $IFVPN  DesActivas"
fi
else 
 echo Interfaces VPN  $IFVPN  Activas
echo
fi
 IPTABLESSTATUS=$(cat /etc/default/iptables.status)
 echo " El estado de las reglas IPTABLES es $(cat /etc/default/iptables.status)"
 
if [ "$IPTABLESSTATUS" = "OFF" ]
then
 echo .·: -----------------------------------:·.
 echo .   Recuerda Activar las reglas IPTABLES, .
 echo ·.: -----------------------------------:.·
if [ "$DISPLAY" == ":0" ] ; then
zenity --error --timeout=5 --title="Error - reglas IPTABLES" --text=" Recuerda Activar las reglas IPTABLES,"
notify-send " El estado de las reglas IPTABLES es $IPTABLESSTATUS"
fi
fi
echo Asuntos Pendientes de HOY:
calendar


 
