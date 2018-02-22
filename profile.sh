#!/bin/bash
# ~/profile.sh : executed by ~/.profile or ~/.bash_profile or ~/.bash_login
# 2015-10-21
# Variables de entorno base
SIC=$HOME/SIC
export SIC
SICSCRIPTS=$SIC/script_SIC
#Display base
DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DISPLAY
echo profile Display  $DISPLAY
# Cortafuegos
IPTABLESSTATUS=$(cat /etc/default/iptables.status)
#
if [ ! "$IPTABLESSTATUS" = "ON" ]; then
echo " El estado de las reglas IPTABLES es $(cat /etc/default/iptables.status) ... Cargando"
 sudo  /etc/init.d/iptables.sh start
fi
# VPNs
IFVPN=$(ifconfig | grep "tun" | cut -d " " -f 1)
if [ "$IFVPN" = "" ]; then
echo " El estado  de las VPN desactivado ... Cargando"
. ~/bin/vpn.sh
fi

